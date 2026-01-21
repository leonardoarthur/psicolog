import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/services/database_service.dart';
import 'logic/providers/journal_provider.dart';
import 'logic/providers/echoes_provider.dart';
import 'logic/services/text_analysis_service.dart';
import 'ui/app_theme.dart';
import 'ui/screens/home_scaffold.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'ui/screens/lock_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize date formatting
  await initializeDateFormatting('pt_BR', null);

  // Initialize Services (Singletons usually, or via DI)
  final databaseService = DatabaseService();
  final textAnalysisService = TextAnalysisService();

  // Ensure DB is ready before app starts (optional, but good for stability)
  await databaseService.db;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => JournalProvider(databaseService)),
        ChangeNotifierProvider(
          create: (_) => EchoesProvider(databaseService, textAnalysisService),
        ),
      ],
      child: const PsicoLogApp(),
    ),
  );
}

class PsicoLogApp extends StatelessWidget {
  const PsicoLogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'PsicoLog',
      debugShowCheckedModeBanner: false,
      home: _AppLoader(),
    );
  }
}

class _AppLoader extends StatefulWidget {
  const _AppLoader();

  @override
  State<_AppLoader> createState() => _AppLoaderState();
}

class _AppLoaderState extends State<_AppLoader> {
  bool _isLoading = true;
  bool _isLocked = false;

  @override
  void initState() {
    super.initState();
    _checkSecurity();
  }

  Future<void> _checkSecurity() async {
    final journalProvider = context.read<JournalProvider>();
    // final isar = await journalProvider.databaseService.db; // Not needed explicitly here

    // We need to access AppSettings. Since we don't have a dedicated provider for Settings yet,
    // we use DatabaseService directly via JournalProvider or create a new one.
    // Ideally DatabaseService should expose this.

    final settings = await journalProvider.databaseService.getAppSettings();

    if (settings.isBiometricEnabled) {
      setState(() {
        _isLocked = true;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLocked = false;
        _isLoading = false;
      });
    }
  }

  void _onAuthenticated() {
    setState(() {
      _isLocked = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_isLocked) {
      return LockScreen(onAuthenticated: _onAuthenticated);
    }

    return MaterialApp(
      title: 'PsicoLog',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const MainScaffold(),
    );
  }
}
