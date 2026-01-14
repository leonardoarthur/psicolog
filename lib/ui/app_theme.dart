import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF4A6572), // Sober Blue-Grey
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: const Color(0xFFF5F5F5),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
      scrolledUnderElevation: 0,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF311B92), // Deep Purple 900
      brightness: Brightness.dark,
      primary: const Color(
        0xFFB39DDB,
      ), // Deep Purple 200 (Lighter for dark mode)
      onPrimary: const Color(0xFF311B92),
      secondary: const Color(0xFFFFD54F), // Amber 300 (Stars/Insights)
      onSecondary: const Color(0xFF3E2723),
      surface: const Color(0xFF121212), // Very dark grey, almost black
      onSurface: const Color(0xFFE0E0E0),
      surfaceContainerHighest: const Color(0xFF262626),
    ),
    scaffoldBackgroundColor: const Color(0xFF0F0F15), // Deep dark indigo/black
    textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.transparent, // Translucent header
      foregroundColor: Color(0xFFE0E0E0),
    ),
    cardTheme: const CardThemeData(
      color: Color(0xFF1E1E28), // Dark indigo card
      elevation: 0,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: const Color(0xFF16161D),
      indicatorColor: const Color(0xFF311B92).withValues(alpha: 0.5),
      iconTheme: WidgetStateProperty.all(
        const IconThemeData(color: Color(0xFFB39DDB)),
      ),
      labelTextStyle: WidgetStateProperty.all(
        const TextStyle(color: Color(0xFFB39DDB), fontSize: 12),
      ),
    ),
  );
}
