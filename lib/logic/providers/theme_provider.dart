import 'package:flutter/material.dart';
import '../../data/services/database_service.dart';

class ThemeProvider extends ChangeNotifier {
  final DatabaseService _databaseService;
  ThemeMode _themeMode = ThemeMode.dark;

  ThemeProvider(this._databaseService) {
    _loadTheme();
  }

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  Future<void> _loadTheme() async {
    final settings = await _databaseService.getAppSettings();
    _themeMode = settings.isDarkMode ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  Future<void> toggleTheme(bool isDark) async {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();

    await _databaseService.updateAppSettings((settings) {
      settings.isDarkMode = isDark;
    });
  }
}
