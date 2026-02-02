import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'data/services/database_service.dart';
import 'logic/providers/journal_provider.dart';
import 'logic/providers/echoes_provider.dart';
import 'logic/services/text_analysis_service.dart';
import 'services/notification_service.dart';
import 'ui/app_theme.dart';
import 'ui/screens/home_scaffold.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'ui/screens/lock_screen.dart';
import 'ui/screens/onboarding/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize date formatting
  await initializeDateFormatting('pt_BR', null);

  // Initialize Services (Singletons usually, or via DI)
  final databaseService = DatabaseService();
  final textAnalysisService = TextAnalysisService();
  await NotificationService().init();

  // Ensure DB is ready before app starts (optional, but good for stability)
  await databaseService.db;

  runApp(
    MultiProvider(
      providers: [
        Provider<DatabaseService>.value(value: databaseService),
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
    return MaterialApp(
      title: 'PsicoLog',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const _AppLoader(),
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
  bool _isOnboardingCompleted = false;

  @override
  void initState() {
    super.initState();
    _checkSecurity();
  }

  Future<void> _checkSecurity() async {
    final journalProvider = context.read<JournalProvider>();
    final settings = await journalProvider.databaseService.getAppSettings();

    setState(() {
      _isOnboardingCompleted = settings.isOnboardingCompleted;
      _isLocked = settings.isBiometricEnabled;
      _isLoading = false;
    });
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

    if (!_isOnboardingCompleted) {
      return const OnboardingScreen();
    }

    if (_isLocked) {
      return LockScreen(onAuthenticated: _onAuthenticated);
    }

    return const MainScaffold();
  }
}
