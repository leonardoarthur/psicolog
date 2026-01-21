import 'package:flutter/material.dart';
import '../../data/services/database_service.dart';
import '../../logic/services/auth_service.dart';
import '../../logic/services/backup_service.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configurações')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                SwitchListTile(
                  title: const Text('Bloqueio Biométrico'),
                  subtitle: const Text('Exigir autenticação ao abrir o app'),
                  value: _isBiometricEnabled,
                  onChanged: _toggleBiometrics,
                  secondary: const Icon(Icons.fingerprint),
                ),
                const Divider(),
                // Placeholder for Backup/Restore (Phase 3)
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
}
