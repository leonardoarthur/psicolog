import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF5E35B1), // Deep Purple
      brightness: Brightness.light,
      primary: const Color(0xFF5E35B1),
      secondary: const Color(0xFF00ACC1), // Cyan/Teal
      surface: const Color(0xFFF3F4F6),
      onSurface: const Color(0xFF1F2937),
    ),
    scaffoldBackgroundColor: const Color(0xFFF8FAFC),
    textTheme: GoogleFonts.outfitTextTheme(ThemeData.light().textTheme),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.transparent,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFFD1C4E9), // Soft Violet (High contrast on dark)
      onPrimary: Color(0xFF311B92),
      secondary: Color(0xFF80DEEA), // Soft Teal (Healing/Calm)
      onSecondary: Color(0xFF006064),
      tertiary: Color(0xFFFFCC80), // Glowing Amber (Warmth/Insight)
      onTertiary: Color(0xFF3E2723),
      error: Color(0xFFEF9A9A),
      onError: Color(0xFFB71C1C),
      surface: Color(0xFF1E1E2C), // Dark Gunmetal/Navy
      onSurface: Color(0xFFE2E8F0),
      surfaceContainerHighest: Color(0xFF2D2D44), // Slightly lighter for cards
    ),
    scaffoldBackgroundColor: const Color(0xFF0F0F1A), // Deepest Void
    textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: Color(0xFFE2E8F0),
    ),
    cardTheme: const CardThemeData(
      color: Color(0xFF1E1E2C),
      elevation: 4, // Subtle shadow for physicality
      shadowColor: Colors
          .black, // Omitted withOpacity(0.5) to keep it simple const for now or handled dynamically
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(24)),
        side: BorderSide(
          color: Color(0xFF2D2D44),
          width: 1, // Subtle border definition
        ),
      ),
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    ),
    iconTheme: const IconThemeData(color: Color(0xFFD1C4E9)),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: const Color(0xFF161622),
      indicatorColor: const Color(0xFF311B92).withValues(alpha: 0.5),
      iconTheme: WidgetStateProperty.all(
        const IconThemeData(color: Color(0xFFD1C4E9)),
      ),
      labelTextStyle: WidgetStateProperty.all(
        const TextStyle(color: Color(0xFFD1C4E9), fontSize: 12),
      ),
    ),
  );
}
