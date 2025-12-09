import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// Consolidated Skye Design System - Colors, Typography & Theme
class SkyeColors {
  static const Color deepSpace = Color(0xFF020617);
  static const Color surfaceDark = Color(0xFF0B1220);
  static const Color surfaceMid = Color(0xFF1E293B);

  static const Color skyBlue = Color(0xFF38BDF8);
  static const Color twilightPurple = Color(0xFFA855F7);
  static const Color sunYellow = Color(0xFFFACC15);

  static const Color moonLight = Color(0xFFC4B5FD);
  static const Color rainBlue = Color(0xFF0EA5E9);
  static const Color stormPurple = Color(0xFF7C3AED);
  static const Color snowWhite = Color(0xFFE0F2FE);
  static const Color cloudGray = Color(0xFF94A3B8);

  static const Color textPrimary = Color(0xFFF9FAFB);
  static const Color textSecondary = Color(0xFFE5E7EB);
  static const Color textTertiary = Color(0xFF9CA3AF);
  static const Color textMuted = Color(0xFF6B7280);

  // Common utility colors used across the app
  static const Color whitePure = Color(0xFFFFFFFF);
  static const Color whiteFA = Color(0xFFFAFAFA);
  static const Color whiteF6 = Color(0xFFF6F6F6);

  static const Color black = Color(0xFF000000);
  static const Color blackDeep = Color(0xFF0A0A0A);
  static const Color darkGray1 = Color(0xFF242424);

  static const Color cardColor = Color(0xFF232125);
  static const Color behindContainer = Color(0xFF1C1A1F);
  static const Color transparent = Colors.transparent;

  static Color glassLight = Colors.white.withOpacity(0.1);
  static Color glassMedium = Colors.white.withOpacity(0.15);
  static Color glassHeavy = Colors.white.withOpacity(0.2);
  static Color glassBorder = Colors.white.withOpacity(0.2);
  static Color glassHighlight = Colors.white.withOpacity(0.05);

  static Color shadowSoft = Colors.black.withOpacity(0.1);
  static Color shadowMedium = Colors.black.withOpacity(0.2);
  static Color shadowHard = Colors.black.withOpacity(0.3);
  static Color overlay = Colors.black.withOpacity(0.4);

  static LinearGradient sunnyGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF38BDF8),
      Color(0xFF0EA5E9),
      Color(0xFF0284C7),
    ],
  );

  static LinearGradient clearNightGradient = const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF020617),
      Color(0xFF0B1220),
      Color(0xFF1E293B),
    ],
  );

  static LinearGradient cloudyGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF475569),
      Color(0xFF334155),
      Color(0xFF1E293B),
    ],
  );

  static LinearGradient rainyGradient = const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF1E293B),
      Color(0xFF0F172A),
      Color(0xFF020617),
    ],
  );

  static LinearGradient snowyGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF64748B),
      Color(0xFF475569),
      Color(0xFF334155),
    ],
  );

  static LinearGradient thunderstormGradient = const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF312E81),
      Color(0xFF1E1B4B),
      Color(0xFF0F172A),
    ],
  );

  static LinearGradient twilightGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFA855F7),
      Color(0xFF9333EA),
      Color(0xFF7C3AED),
    ],
  );

  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);
}

class SkyeTypography {
  static TextStyle display = GoogleFonts.inter(
    fontSize: 120,
    fontWeight: FontWeight.w200,
    color: SkyeColors.textPrimary,
    height: 1.0,
    letterSpacing: -6.0,
  );

  static TextStyle displaySmall = GoogleFonts.inter(
    fontSize: 72,
    fontWeight: FontWeight.w300,
    color: SkyeColors.textPrimary,
    height: 1.0,
    letterSpacing: -3.0,
  );

  static TextStyle headline = GoogleFonts.inter(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    color: SkyeColors.textPrimary,
    height: 1.2,
    letterSpacing: -0.5,
  );

  static TextStyle title = GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: SkyeColors.textPrimary,
    height: 1.3,
    letterSpacing: -0.3,
  );

  static TextStyle subtitle = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: SkyeColors.textSecondary,
    height: 1.4,
    letterSpacing: 0,
  );

  static TextStyle bodyLarge = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: SkyeColors.textSecondary,
    height: 1.5,
    letterSpacing: 0,
  );

  static TextStyle body = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: SkyeColors.textSecondary,
    height: 1.5,
    letterSpacing: 0,
  );

  static TextStyle bodySmall = GoogleFonts.inter(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: SkyeColors.textTertiary,
    height: 1.4,
    letterSpacing: 0,
  );

  static TextStyle label = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: SkyeColors.textTertiary,
    height: 1.3,
    letterSpacing: 0.5,
  );

  static TextStyle caption = GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: SkyeColors.textMuted,
    height: 1.3,
    letterSpacing: 0.3,
  );

  static TextStyle metricValue = GoogleFonts.inter(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    color: SkyeColors.textPrimary,
    height: 1.1,
    letterSpacing: -1.0,
  );

  static TextStyle metricLabel = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: SkyeColors.textTertiary,
    height: 1.3,
    letterSpacing: 0.5,
  );

  static TextStyle condition = GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: SkyeColors.textSecondary,
    height: 1.3,
    letterSpacing: 0.5,
  );

  static TextStyle temperature = GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: SkyeColors.textPrimary,
    height: 1.2,
    letterSpacing: -0.5,
  );
}

/// Skye Design System - Theme Configuration
class SkyeTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: SkyeColors.deepSpace,

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

      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        iconTheme: IconThemeData(color: SkyeColors.textPrimary),
        titleTextStyle: SkyeTypography.title,
      ),

      cardTheme: CardThemeData(
        elevation: 0,
        color: SkyeColors.glassLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),

      iconTheme: IconThemeData(
        color: SkyeColors.textSecondary,
        size: 24,
      ),

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
