import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/services/database_service.dart';
import 'logic/providers/journal_provider.dart';
import 'logic/providers/echoes_provider.dart';
import 'logic/services/text_analysis_service.dart';
import 'ui/app_theme.dart';
import 'ui/screens/home_scaffold.dart';
import 'package:intl/date_symbol_data_local.dart';

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
