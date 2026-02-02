import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    try {
      tz.initializeTimeZones();
      // Handle potential type mismatch or failure defensively
      final dynamic localTimezoneParams =
          await FlutterTimezone.getLocalTimezone();
      final String timeZoneName = localTimezoneParams.toString();
      tz.setLocalLocation(tz.getLocation(timeZoneName));
    } catch (e) {
      // Fallback if detection fails
      try {
        tz.setLocalLocation(tz.getLocation('America/Sao_Paulo'));
      } catch (_) {
        // If even that fails, default is UTC which is safe enough for basic usage
        // or we could set it to the first available location.
      }
    }

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // Note: iOS permissions not handled here for brevity, assuming Android focus based on logs.

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (response) {
        // Handle notification tap
      },
    );

    // Request permissions for Android 13+
    final androidImplementation = flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidImplementation != null) {
      await androidImplementation.requestNotificationsPermission();
    }
  }

  Future<void> scheduleWeeklyTherapyNotification({
    required int dayOfWeek, // 1 = Monday, 7 = Sunday
    required int hour,
    required int minute,
  }) async {
    // ID 1 for Therapy
    await flutterLocalNotificationsPlugin.cancel(id: 1);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id: 1,
      title: 'Como foi a terapia?',
      body: 'Registre seus insights enquanto estão frescos.',
      scheduledDate: _nextInstanceOfDayTime(dayOfWeek, hour, minute),
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'therapy_channel',
          'Lembretes de Terapia',
          channelDescription: 'Notificações para registrar sessão de terapia',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    );
  }

  tz.TZDateTime _nextInstanceOfDayTime(int dayOfWeek, int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    while (scheduledDate.weekday != dayOfWeek) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    // If today is the day but time has passed, add 7 days (actually the loop above might handle it?
    // No, loop just finds NEXT day of week. If today match, we check time.)

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 7));
    }
    return scheduledDate;
  }

  Future<void> cancelTherapyNotification() async {
    await flutterLocalNotificationsPlugin.cancel(id: 1);
  }
}
