import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'skye_colors.dart';
import 'skye_typography.dart';

/// Skye Design System - Theme Configuration
class SkyeTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: SkyeColors.deepSpace,

      // Color Scheme
      colorScheme: ColorScheme.dark(
        primary: SkyeColors.skyBlue,
        secondary: SkyeColors.twilightPurple,
        tertiary: SkyeColors.sunYellow,
        surface: SkyeColors.surfaceDark,
        error: SkyeColors.error,
        onPrimary: SkyeColors.deepSpace,
        onSecondary: SkyeColors.deepSpace,
        onSurface: SkyeColors.textPrimary,
        onError: SkyeColors.textPrimary,
      ),

      // App Bar
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        iconTheme: IconThemeData(color: SkyeColors.textPrimary),
        titleTextStyle: SkyeTypography.title,
      ),

      // Card Theme
      cardTheme: CardThemeData(
        elevation: 0,
        color: SkyeColors.glassLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),

      // Icon Theme
      iconTheme: IconThemeData(
        color: SkyeColors.textSecondary,
        size: 24,
      ),

      // Text Theme
      textTheme: TextTheme(
        displayLarge: SkyeTypography.display,
        displayMedium: SkyeTypography.displaySmall,
        headlineLarge: SkyeTypography.headline,
        titleLarge: SkyeTypography.title,
        titleMedium: SkyeTypography.subtitle,
        bodyLarge: SkyeTypography.bodyLarge,
        bodyMedium: SkyeTypography.body,
        bodySmall: SkyeTypography.bodySmall,
        labelLarge: SkyeTypography.label,
        labelMedium: SkyeTypography.caption,
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: SkyeColors.glassLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: SkyeColors.glassBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: SkyeColors.glassBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: SkyeColors.skyBlue, width: 2),
        ),
        hintStyle: SkyeTypography.body.copyWith(color: SkyeColors.textMuted),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),

      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: SkyeColors.skyBlue,
          foregroundColor: SkyeColors.deepSpace,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: SkyeTypography.subtitle,
        ),
      ),
    );
  }
}
