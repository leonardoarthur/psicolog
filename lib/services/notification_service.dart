import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:math';
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
      final dynamic localTimezoneParams =
          await FlutterTimezone.getLocalTimezone();
      final String timeZoneName = localTimezoneParams.toString();
      tz.setLocalLocation(tz.getLocation(timeZoneName));
    } catch (e) {
      try {
        tz.setLocalLocation(tz.getLocation('America/Sao_Paulo'));
      } catch (_) {
        // Default to UTC
      }
    }

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (response) {
        // Handle notification tap
      },
    );
  }

  Future<void> requestPermissions() async {
    final androidImplementation = flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidImplementation != null) {
      await androidImplementation.requestNotificationsPermission();
      // Explicitly request exact alarms permission for Android 12+ (API 31+)
      await androidImplementation.requestExactAlarmsPermission();
    }
  }

  static const List<String> _therapyMessages = [
    'Como foi a sessão hoje? Escreva para não esquecer.',
    'Terapia finalizada. Que tal registrar seus insights?',
    'O que você aprendeu sobre si mesmo hoje?',
    'Tire um momento para refletir sobre sua sessão.',
    'Registrar seus sentimentos agora ajuda a processá-los melhor.',
    'Algum insight importante? Anote agora!',
    'Como você está se sentindo após a terapia?',
  ];

  Future<String> scheduleWeeklyTherapyNotification({
    required int dayOfWeek, // 1 = Monday, 7 = Sunday
    required int hour,
    required int minute,
  }) async {
    // ID 1 for Therapy
    await flutterLocalNotificationsPlugin.cancel(id: 1);

    final random = Random();
    final message = _therapyMessages[random.nextInt(_therapyMessages.length)];

    final scheduledDate = _nextInstanceOfTherapy(dayOfWeek, hour, minute);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id: 1,
      title: 'Como foi a terapia?',
      body: message,
      scheduledDate: scheduledDate,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'therapy_channel_v2',
          'Lembretes de Terapia',
          channelDescription: 'Notificações para registrar sessão de terapia',
          importance: Importance.max,
          priority: Priority.high,
          fullScreenIntent: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.alarmClock,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    );

    return '${scheduledDate.day}/${scheduledDate.month} às ${scheduledDate.hour}:${scheduledDate.minute.toString().padLeft(2, '0')}';
  }

  tz.TZDateTime _nextInstanceOfTherapy(int dayOfWeek, int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);

    // Start with the target time for THIS week (or today)
    // We construct the date using "now" year/month/day but target time
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    // Initial Adjustment: Find the correct Day of Week
    // We want the scheduledDate to be on 'dayOfWeek'.
    // Note: This naive while loop moves forward.
    // Ideally we should find the closest day match.
    // If today is Friday (5) and we want Monday (1).
    // Loop adds days until weekday is 1.
    while (scheduledDate.weekday != dayOfWeek) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    // Apply the 30-minute delay
    // This is crucial: we apply delay BEFORE checking if it's in the past.
    // This allows "catching" a session that just finished 5 mins ago.
    scheduledDate = scheduledDate.add(const Duration(minutes: 30));

    // Now check if this calculated time is in the past
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 7));
    }

    return scheduledDate;
  }

  Future<void> cancelTherapyNotification() async {
    await flutterLocalNotificationsPlugin.cancel(id: 1);
  }

  Future<void> showTestNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'test_channel',
          'Canal de Teste',
          channelDescription: 'Canal para testar notificações',
          importance: Importance.max,
          priority: Priority.high,
        );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    final random = Random();
    final message = _therapyMessages[random.nextInt(_therapyMessages.length)];

    await flutterLocalNotificationsPlugin.show(
      id: 999,
      title: 'Teste de Notificação',
      body: message,
      notificationDetails: platformChannelSpecifics,
    );
  }

  Future<List<PendingNotificationRequest>> checkPendingNotifications() async {
    final pending = await flutterLocalNotificationsPlugin
        .pendingNotificationRequests();
    for (var p in pending) {
      print(
        'Pending notification: id=${p.id}, title=${p.title}, body=${p.body}, payload=${p.payload}',
      );
    }
    return pending;
  }
}
