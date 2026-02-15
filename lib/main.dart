import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'data/services/database_service.dart';
import 'logic/providers/journal_provider.dart';
import 'logic/providers/echoes_provider.dart';
import 'logic/providers/theme_provider.dart';
import 'logic/services/text_analysis_service.dart';
import 'services/notification_service.dart';
import 'ui/app_theme.dart';
import 'ui/screens/home_scaffold.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:psicolog/l10n/app_localizations.dart';
import 'ui/screens/lock_screen.dart';
import 'ui/screens/onboarding/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // Initialize Services
    final databaseService = DatabaseService();
    final textAnalysisService = TextAnalysisService();

    // Initialize Notifications with error handling
    try {
      await NotificationService().init();
    } catch (e) {
      debugPrint('Notification init failed: $e');
      // Continue app execution even if notifications fail
    }

    // Ensure DB is ready
    await databaseService.db;

    runApp(
      MultiProvider(
        providers: [
          Provider<DatabaseService>.value(value: databaseService),
          ChangeNotifierProvider(
            create: (_) => JournalProvider(databaseService),
          ),
          ChangeNotifierProvider(
            create: (_) => EchoesProvider(databaseService, textAnalysisService),
          ),
          ChangeNotifierProvider(create: (_) => ThemeProvider(databaseService)),
        ],
        child: const PsicoLogApp(),
      ),
    );
  } catch (e, stackTrace) {
    debugPrint('Fatal initialization error: $e');
    runApp(InitializationErrorApp(error: e.toString(), stackTrace: stackTrace));
  }
}

class InitializationErrorApp extends StatelessWidget {
  final String error;
  final StackTrace? stackTrace;

  const InitializationErrorApp({
    super.key,
    required this.error,
    this.stackTrace,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  const Text(
                    'Erro ao iniciar o aplicativo',
                    // Keeping hardcoded for fatal error as context might not be ready or locale not loaded
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    error,
                    style: const TextStyle(color: Colors.black54),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PsicoLogApp extends StatelessWidget {
  const PsicoLogApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeMode = context.select<ThemeProvider, ThemeMode>(
      (p) => p.themeMode,
    );

    return MaterialApp(
      title:
          'PsicoLog', // This is static title, usually defined in Info.plist/Manifest too
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
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
