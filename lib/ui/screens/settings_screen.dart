import 'package:flutter/material.dart';
import '../../data/services/database_service.dart';
import '../../logic/services/auth_service.dart';
import '../../logic/services/backup_service.dart';
import '../../services/notification_service.dart';
import '../../logic/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:psicolog/l10n/app_localizations.dart';

class SettingsScreen extends StatefulWidget {
  final DatabaseService databaseService;

  const SettingsScreen({super.key, required this.databaseService});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isBiometricEnabled = false;
  bool _isLoading = true;
  final AuthService _authService = AuthService();
  late BackupService _backupService;

  int? _therapyDay; // 1 = Monday
  TimeOfDay? _therapyTime;

  @override
  void initState() {
    super.initState();
    _backupService = BackupService(widget.databaseService);
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final settings = await widget.databaseService.getAppSettings();
    setState(() {
      _isBiometricEnabled = settings.isBiometricEnabled;
      _therapyDay = settings.therapyDayOfWeek;
      if (settings.therapyHour != null && settings.therapyMinute != null) {
        _therapyTime = TimeOfDay(
          hour: settings.therapyHour!,
          minute: settings.therapyMinute!,
        );
      }
      _isLoading = false;
    });
  }

  Future<void> _toggleBiometrics(bool value) async {
    // If enabling, verify auth first
    if (value) {
      final canCheck = await _authService.canCheckBiometrics();
      if (!canCheck) {
        if (mounted) {
          final l10n = AppLocalizations.of(context)!;
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(l10n.biometricsNotAvailable)));
        }
        return;
      }

      final authenticated = await _authService.authenticate();
      if (!authenticated) return;
    }

    // Save preference
    await widget.databaseService.updateAppSettings((s) {
      s.isBiometricEnabled = value;
    });

    setState(() {
      _isBiometricEnabled = value;
    });
  }

  Future<void> _exportData() async {
    try {
      await _backupService.exportData();
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.backupSuccess)));
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.backupError(e.toString()))));
      }
    }
  }

  Future<void> _restoreData() async {
    try {
      final success = await _backupService.restoreData();
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        if (success) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(l10n.restoreSuccess)));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.restoreError('Cancelado/Falha'))),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.restoreError(e.toString()))),
        );
      }
    }
  }

  Future<void> _updateTherapySchedule() async {
    // 1. Pick Day
    final l10n = AppLocalizations.of(context)!;
    final int? pickedDay = await showDialog<int>(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text(l10n.therapyDayTitle),
          children: [
            SimpleDialogOption(
              child: Text(l10n.monday),
              onPressed: () => Navigator.pop(context, 1),
            ),
            SimpleDialogOption(
              child: Text(l10n.tuesday),
              onPressed: () => Navigator.pop(context, 2),
            ),
            SimpleDialogOption(
              child: Text(l10n.wednesday),
              onPressed: () => Navigator.pop(context, 3),
            ),
            SimpleDialogOption(
              child: Text(l10n.thursday),
              onPressed: () => Navigator.pop(context, 4),
            ),
            SimpleDialogOption(
              child: Text(l10n.friday),
              onPressed: () => Navigator.pop(context, 5),
            ),
            SimpleDialogOption(
              child: Text(l10n.saturday),
              onPressed: () => Navigator.pop(context, 6),
            ),
            SimpleDialogOption(
              child: Text(l10n.sunday),
              onPressed: () => Navigator.pop(context, 7),
            ),
          ],
        );
      },
    );

    if (pickedDay == null) return;

    // 2. Pick Time
    if (!mounted) return;
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _therapyTime ?? const TimeOfDay(hour: 18, minute: 0),
    );

    if (pickedTime == null) return;

    // Save
    await widget.databaseService.updateAppSettings((s) {
      s.therapyDayOfWeek = pickedDay;
      s.therapyHour = pickedTime.hour;
      s.therapyMinute = pickedTime.minute;
    });

    setState(() {
      _therapyDay = pickedDay;
      _therapyTime = pickedTime;
    });

    // Request permissions first (UX improvement)
    // Request permissions first (UX improvement)
    await NotificationService().requestPermissions();

    // Check specifically for Exact Alarm permission (crucial for Android 12+ on Xiaomi)
    final hasExactAlarmPermission = await NotificationService()
        .checkExactAlarmPermission();
    if (!hasExactAlarmPermission && mounted) {
      final bool? openSettings = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Permissão Necessária'),
          content: const Text(
            'Para garantir que a notificação funcione no horário exato, é necessário permitir "Alarmes e lembretes" nas configurações.\n\nDispositivos Xiaomi/Samsung frequentemente bloqueiam isso para economizar bateria.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Abrir Configurações'),
            ),
          ],
        ),
      );

      if (openSettings == true) {
        await NotificationService().openAlarmSettings();
      }
    }

    // Schedule
    final scheduledInfo = await NotificationService()
        .scheduleWeeklyTherapyNotification(
          dayOfWeek: pickedDay,
          hour: pickedTime.hour,
          minute: pickedTime.minute,
        );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Agendado para: $scheduledInfo (delay de 30m)')),
      );
    }
  }

  Future<void> _clearTherapySchedule() async {
    await widget.databaseService.updateAppSettings((s) {
      s.therapyDayOfWeek = null;
      s.therapyHour = null;
      s.therapyMinute = null;
    });

    setState(() {
      _therapyDay = null;
      _therapyTime = null;
    });

    await NotificationService().cancelTherapyNotification();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                _buildTherapySection(),
                const Divider(),
                SwitchListTile(
                  title: Text(l10n.darkMode),
                  subtitle: Text(l10n.darkModeSubtitle),
                  value: context.watch<ThemeProvider>().isDarkMode,
                  onChanged: (val) =>
                      context.read<ThemeProvider>().toggleTheme(val),
                  secondary: Icon(
                    context.watch<ThemeProvider>().isDarkMode
                        ? Icons.dark_mode
                        : Icons.light_mode,
                  ),
                ),
                const Divider(),
                SwitchListTile(
                  title: Text(l10n.biometrics),
                  subtitle: Text(l10n.biometricsSubtitle),
                  value: _isBiometricEnabled,
                  onChanged: _toggleBiometrics,
                  secondary: const Icon(Icons.fingerprint),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.download),
                  title: Text(l10n.exportData),
                  subtitle: Text(l10n.exportDataSubtitle),
                  onTap: _exportData,
                ),
                ListTile(
                  leading: const Icon(Icons.restore),
                  title: Text(l10n.restoreData),
                  subtitle: Text(l10n.restoreDataSubtitle),
                  onTap: _restoreData,
                ),
              ],
            ),
    );
  }

  Widget _buildTherapySection() {
    final l10n = AppLocalizations.of(context)!;
    String subtitle = l10n.tapToConfigure;
    if (_therapyDay != null && _therapyTime != null) {
      final days = [
        l10n.monday,
        l10n.tuesday,
        l10n.wednesday,
        l10n.thursday,
        l10n.friday,
        l10n.saturday,
        l10n.sunday,
      ];
      final dayStr = days[_therapyDay! - 1]; // 1-based index
      final timeStr =
          "${_therapyTime!.hour.toString().padLeft(2, '0')}:${_therapyTime!.minute.toString().padLeft(2, '0')}";
      subtitle = '$dayStr - $timeStr';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            l10n.therapySectionTitle,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.self_improvement, color: Colors.teal),
          title: Text(l10n.therapySchedule),
          subtitle: Text(subtitle),
          trailing: _therapyDay != null
              ? IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: _clearTherapySchedule,
                )
              : const Icon(Icons.chevron_right),
          onTap: _updateTherapySchedule,
        ),
        ListTile(
          title: Text(l10n.testNotification),
          subtitle: Text(l10n.testNotificationSubtitle),
          leading: const Icon(Icons.notifications_active),
          onTap: () async {
            await NotificationService().showTestNotification();
            if (mounted) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(l10n.notificationSent)));
            }
          },
        ),
        ListTile(
          title: Text(l10n.checkSchedule),
          subtitle: Text(l10n.checkScheduleSubtitle),
          leading: const Icon(Icons.playlist_add_check),
          onTap: () async {
            // Re-request permissions just in case
            await NotificationService().requestPermissions();

            final pending = await NotificationService()
                .checkPendingNotifications();
            if (mounted) {
              if (pending.isEmpty) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(l10n.noScheduleFound)));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.schedulesFound(pending.length))),
                );
                // Also print to console for debugging if needed, but snackbar sufficient for user count
              }
            }
          },
        ),
      ],
    );
  }
}
