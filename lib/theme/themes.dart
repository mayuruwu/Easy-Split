import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppThemeData {
  final Color primary;
  final Color accent;
  final Color background;

  AppThemeData({
    required this.primary,
    required this.accent,
    required this.background,
  });
}

class AppThemes {
  static final defaultTheme = AppThemeData(
        primary: Color(0xFF4A90E2), // blue
        accent: Color(0xFF50E3C2), // mint
        background: Color(0xFFF5F7FA), // soft grey
      ),
      softDark = AppThemeData(
        primary: Color(0xFF1F1F1F),
        accent: Color(0xFF3DDC97),
        background: Color(0xFF121212),
      ),
      vibrantOrange = AppThemeData(
        primary: Color(0xFFFF5722), // vibrant orange
        accent: Color(0xFFFFC107), // vibrant yellow
        background: Color(0xFF212121), // dark grey
      ),
      minimal = AppThemeData(
        primary: Color(0xFF1F1F1F),
        accent: Color(0xFF3DDC97),
        background: Color(0xFF121212),
      ),
      pastel = AppThemeData(
        primary: Color(0xFFFFB3BA), // pastel pink
        accent: Color(0xFFB3E5FC), // pastel blue
        background: Color(0xFFFFF9C4), // pastel yellow
      ),
      neon = AppThemeData(
        primary: Color(0xFF39FF14), // neon green
        accent: Color(0xFFFF00FF), // neon magenta
        background: Color(0xFF000000), // black
      );

  static ThemeData toThemeData(AppThemeData data) {
    final isDark = _isDark(data.background);

    final colorScheme = isDark
        ? ColorScheme.dark(
            primary: data.primary,
            secondary: data.accent,
            surface: data.background,
            onPrimary: Colors.white,
            onSecondary: Colors.black,
            onSurface: Colors.white,
            error: Colors.redAccent,
          )
        : ColorScheme.light(
            primary: data.primary,
            secondary: data.accent,
            surface: data.background,
            onPrimary: Colors.white,
            onSecondary: Colors.black,
            onSurface: Colors.black,
            error: Colors.red,
          );

    return ThemeData(
      colorScheme: colorScheme,

      // Scaffold background
      scaffoldBackgroundColor: colorScheme.surface,
      // AppBar theme
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 0,
      ),

      // Buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
        ),
      ),

      // Text theme
      textTheme: GoogleFonts.interTextTheme(
        TextTheme(
          bodyMedium: TextStyle(color: colorScheme.onSurface),
          titleLarge: TextStyle(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // Card theme
      cardColor: colorScheme.surface,

      // Divider
      dividerColor: colorScheme.onSurface.withValues(
        alpha: 0.2,
      ), // correct version
      //
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: data.background,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: data.accent, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red, width: 2),
        ),
      ),
    );
  }

  // 🔥 helper to detect dark/light automatically
  static bool _isDark(Color color) {
    return color.computeLuminance() < 0.5;
  }
}
