/// App theme configuration.
library;

///
/// Brand light theme (default) + emergency dark constants for countdown/alert screens.

import 'package:flutter/material.dart';

class AppTheme {
  // ── Brand Palette (MyPanic Brand Guidelines) ────────────────────────────────
  static const Color brandPink      = Color(0xFFE58090); // Primary brand pink
  static const Color brandPinkLight = Color(0xFFEFB2BA); // Light pink
  static const Color brandBlush     = Color(0xFFFEEEEE); // Background blush
  static const Color brandCharcoal  = Color(0xFF605757); // Primary text
  static const Color brandWarmGrey  = Color(0xFFA69D9C); // Secondary text

  // ── Brand Surface Colors (light theme) ──────────────────────────────────────
  static const Color backgroundBrand     = brandBlush;
  static const Color surfaceBrand        = Color(0xFFFFFFFF);
  static const Color cardBrand           = Color(0xFFFFFFFF);
  static const Color textBrandPrimary    = brandCharcoal;
  static const Color textBrandSecondary  = brandWarmGrey;
  static const Color textBrandMuted      = Color(0xFFBFB8B8);
  static const Color dividerBrand        = brandPinkLight;

  // ── Primary alias (= brand pink) ────────────────────────────────────────────
  static const Color primaryRed = brandPink;
  static const Color darkRed    = Color(0xFFC45C70); // Darkened brand pink

  // ── Emergency colors — use ONLY in panic_button, countdown, alert_active ────
  static const Color emergencyRed     = Color(0xFFE53935);
  static const Color emergencyDarkRed = Color(0xFFB71C1C);

  // ── Dark constants — kept for emergency screens ──────────────────────────────
  static const Color backgroundDark      = Color(0xFF0D0D0D);
  static const Color surfaceDark         = Color(0xFF1A1A1A);
  static const Color cardDark            = Color(0xFF252525);
  static const Color countdownBackground = Color(0xFF1A0A0A);
  static const Color textPrimary         = Color(0xFFFFFFFF); // white — emergency screens
  static const Color textSecondary       = Color(0xFFB0B0B0); // grey  — emergency screens
  static const Color textMuted           = Color(0xFF757575); // muted — emergency screens
  static const Color dividerColor        = Color(0x3DFFFFFF); // emergency screen dividers

  // ── Status / Semantic ────────────────────────────────────────────────────────
  static const Color successGreen  = Color(0xFF4CAF50);
  static const Color warningYellow = Color(0xFFFFC107);
  static const Color errorRed      = Color(0xFFF44336);
  static const Color infoBlue      = Color(0xFF2196F3);

  // ── Brand Theme (app default) ────────────────────────────────────────────────
  static ThemeData get brandTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: brandPink,
      scaffoldBackgroundColor: backgroundBrand,
      colorScheme: ColorScheme.light(
        primary: brandPink,
        secondary: brandPinkLight,
        surface: surfaceBrand,
        error: errorRed,
        onPrimary: Colors.white,
        onSecondary: brandCharcoal,
        onSurface: brandCharcoal,
        onError: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: backgroundBrand,
        foregroundColor: brandCharcoal,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: brandCharcoal,
        ),
        iconTheme: const IconThemeData(color: brandCharcoal),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: brandPink,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: brandPink,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
      cardTheme: CardThemeData(
        color: cardBrand,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: brandPinkLight, width: 1),
        ),
      ),
      textTheme: const TextTheme(
        displayLarge:  TextStyle(fontSize: 72, fontWeight: FontWeight.bold,  color: brandCharcoal),
        displayMedium: TextStyle(fontSize: 48, fontWeight: FontWeight.bold,  color: brandCharcoal),
        displaySmall:  TextStyle(fontSize: 36, fontWeight: FontWeight.bold,  color: brandCharcoal),
        headlineLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.w600, color: brandCharcoal),
        headlineMedium:TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: brandCharcoal),
        headlineSmall: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: brandCharcoal),
        bodyLarge:     TextStyle(fontSize: 18, color: brandCharcoal),
        bodyMedium:    TextStyle(fontSize: 16, color: brandWarmGrey),
        bodySmall:     TextStyle(fontSize: 14, color: brandWarmGrey),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: surfaceBrand,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: brandPinkLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: brandPinkLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: brandPink, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: errorRed),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: errorRed, width: 2),
        ),
        labelStyle: TextStyle(color: brandWarmGrey),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      dividerTheme: const DividerThemeData(color: brandPinkLight),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: brandPink,
        foregroundColor: Colors.white,
      ),
      listTileTheme: const ListTileThemeData(
        iconColor: brandCharcoal,
        textColor: brandCharcoal,
      ),
      dropdownMenuTheme: DropdownMenuThemeData(
        menuStyle: MenuStyle(
          backgroundColor: WidgetStateProperty.all(surfaceBrand),
        ),
      ),
    );
  }

  /// Kept for reference — emergency screens override scaffold bg explicitly with dark colors.
  static ThemeData get darkTheme => brandTheme;
}
