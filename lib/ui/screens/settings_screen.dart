import 'package:flutter/material.dart';
import '../../data/services/database_service.dart';
import '../../logic/services/auth_service.dart';
import '../../logic/services/backup_service.dart';
import '../../services/notification_service.dart';

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
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Biometria não disponível neste dispositivo.'),
            ),
          );
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Backup gerado com sucesso!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro ao exportar: $e')));
      }
    }
  }

  Future<void> _restoreData() async {
    try {
      final success = await _backupService.restoreData();
      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Dados restaurados com sucesso! Reinicie o app.'),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Restauração cancelada ou falha.')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro ao restaurar: $e')));
      }
    }
  }

  Future<void> _updateTherapySchedule() async {
    // 1. Pick Day
    final int? pickedDay = await showDialog<int>(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Dia da Terapia'),
          children: [
            SimpleDialogOption(
              child: const Text('Segunda-feira'),
              onPressed: () => Navigator.pop(context, 1),
            ),
            SimpleDialogOption(
              child: const Text('Terça-feira'),
              onPressed: () => Navigator.pop(context, 2),
            ),
            SimpleDialogOption(
              child: const Text('Quarta-feira'),
              onPressed: () => Navigator.pop(context, 3),
            ),
            SimpleDialogOption(
              child: const Text('Quinta-feira'),
              onPressed: () => Navigator.pop(context, 4),
            ),
            SimpleDialogOption(
              child: const Text('Sexta-feira'),
              onPressed: () => Navigator.pop(context, 5),
            ),
            SimpleDialogOption(
              child: const Text('Sábado'),
              onPressed: () => Navigator.pop(context, 6),
            ),
            SimpleDialogOption(
              child: const Text('Domingo'),
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

    // Schedule
    await NotificationService().scheduleWeeklyTherapyNotification(
      dayOfWeek: pickedDay,
      hour: pickedTime.hour,
      minute: pickedTime.minute,
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lembrete de terapia configurado!')),
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
    return Scaffold(
      appBar: AppBar(title: const Text('Configurações')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                _buildTherapySection(),
                const Divider(),
                SwitchListTile(
                  title: const Text('Bloqueio Biométrico'),
                  subtitle: const Text('Exigir autenticação ao abrir o app'),
                  value: _isBiometricEnabled,
                  onChanged: _toggleBiometrics,
                  secondary: const Icon(Icons.fingerprint),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.download),
                  title: const Text('Exportar Dados'),
                  subtitle: const Text('Salvar backup em arquivo JSON'),
                  onTap: _exportData,
                ),
                ListTile(
                  leading: const Icon(Icons.restore),
                  title: const Text('Restaurar Dados'),
                  subtitle: const Text('Importar de arquivo JSON'),
                  onTap: _restoreData,
                ),
              ],
            ),
    );
  }

  Widget _buildTherapySection() {
    String subtitle = 'Toque para configurar';
    if (_therapyDay != null && _therapyTime != null) {
      final days = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom'];
      final dayStr = days[_therapyDay! - 1]; // 1-based index
      final timeStr =
          "${_therapyTime!.hour.toString().padLeft(2, '0')}:${_therapyTime!.minute.toString().padLeft(2, '0')}";
      subtitle = '$dayStr às $timeStr';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            'Terapia e Bem-Estar',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.self_improvement, color: Colors.teal),
          title: const Text('Horário da Terapia'),
          subtitle: Text(subtitle),
          trailing: _therapyDay != null
              ? IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: _clearTherapySchedule,
                )
              : const Icon(Icons.chevron_right),
          onTap: _updateTherapySchedule,
        ),
      ],
    );
  }
}
