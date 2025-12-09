import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// Consolidated Skye Design System - Pure Monochrome Colors, Typography & Theme
class SkyeColors {
  // Pure monotone background system (OLED black)
  static const Color deepSpace = Color(0xFF050505);
  static const Color surfaceDark = Color(0xFF050505);
  static const Color surfaceMid = Color(0xFF0C0C0C);
  static const Color surfaceSoft = Color(0xFF141414);

  // Removed all saturated colors: NO blue, purple, yellow, teal, cyan
  // All accent colors replaced with grayscale hierarchy

  // Text hierarchy - white with opacity only
  static Color textPrimary = Colors.white.withAlphaFromOpacity(0.96);
  static Color textSecondary = Colors.white.withAlphaFromOpacity(0.84);
  static Color textTertiary = Colors.white.withAlphaFromOpacity(0.64);
  static Color textMuted = Colors.white.withAlphaFromOpacity(0.45);

  // Common utility colors (monotone only)
  static const Color whitePure = Color(0xFFFFFFFF);
  static const Color whiteFA = Color(0xFFFAFAFA);
  static const Color whiteF6 = Color(0xFFF6F6F6);

  static const Color black = Color(0xFF000000);
  static const Color blackDeep = Color(0xFF050505);
  static const Color darkGray1 = Color(0xFF0C0C0C);

  // Renamed from colored card colors to monotone surfaces
  static const Color cardColor = Color(0xFF0C0C0C);
  static const Color behindContainer = Color(0xFF050505);
  static const Color transparent = Colors.transparent;

  // Glass effect hierarchy (all white opacity)
  static Color glassLight = Colors.white.withAlphaFromOpacity(0.10);
  static Color glassMedium = Colors.white.withAlphaFromOpacity(0.15);
  static Color glassHeavy = Colors.white.withAlphaFromOpacity(0.20);
  static Color glassBorder = Colors.white.withAlphaFromOpacity(0.12);
  static Color glassHighlight = Colors.white.withAlphaFromOpacity(0.05);

  // Shadows (pure black opacity)
  static Color shadowSoft = Colors.black.withAlphaFromOpacity(0.1);
  static Color shadowMedium = Colors.black.withAlphaFromOpacity(0.2);
  static Color shadowHard = Colors.black.withAlphaFromOpacity(0.3);
  static Color overlay = Colors.black.withAlphaFromOpacity(0.4);

  // Pure monotone gradients (NO color tint)
  static LinearGradient sunnyGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF050505),
      Color(0xFF0F0F0F),
    ],
  );

  static LinearGradient clearNightGradient = const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF050505),
      Color(0xFF0C0C0C),
    ],
  );

  static LinearGradient cloudyGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF0A0A0A),
      Color(0xFF141414),
    ],
  );

  static LinearGradient rainyGradient = const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF050505),
      Color(0xFF0C0C0C),
    ],
  );

  static LinearGradient snowyGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF0A0A0A),
      Color(0xFF141414),
    ],
  );

  static LinearGradient thunderstormGradient = const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF050505),
      Color(0xFF0C0C0C),
    ],
  );

  static LinearGradient twilightGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF0F0F0F),
      Color(0xFF141414),
    ],
  );

  // Status colors (red only for error/critical; removed warning/info/success colors)
  static const Color error = Color(0xFFEF4444);
  static const Color success = Color(0xFF10B981);

  // BACKWARD COMPATIBILITY ALIASES (for refactoring, all map to monotone equivalents)
  static Color get skyBlue => textSecondary;
  static Color get twilightPurple => surfaceSoft;
  static Color get sunYellow => textTertiary;
  static Color get moonLight => textSecondary;
  static Color get rainBlue => textSecondary;
  static Color get stormPurple => surfaceSoft;
  static Color get snowWhite => whiteF6;
  static Color get cloudGray => textTertiary;
  static Color get warning => textTertiary;
  static Color get info => textSecondary;
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

// Utility extension providing a safe alternative to `withOpacity`.
// We use a distinct name to avoid colliding with existing `withValues` APIs.
extension ColorAlphaFromOpacity on Color {
  Color withAlphaFromOpacity(double opacity) {
    final int alpha = (opacity * 255).round().clamp(0, 255).toInt();
    final int rr = ((this.r * 255.0).round()).clamp(0, 255).toInt();
    final int gg = ((this.g * 255.0).round()).clamp(0, 255).toInt();
    final int bb = ((this.b * 255.0).round()).clamp(0, 255).toInt();
    return Color.fromARGB(alpha, rr, gg, bb);
  }
}

/// Skye Design System - Pure Monotone Theme Configuration
class SkyeTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: SkyeColors.deepSpace,

      colorScheme: ColorScheme.dark(
        primary: SkyeColors.textSecondary,
        secondary: SkyeColors.textTertiary,
        tertiary: SkyeColors.textMuted,
        surface: SkyeColors.surfaceMid,
        error: SkyeColors.error,
        onPrimary: SkyeColors.textPrimary,
        onSecondary: SkyeColors.textPrimary,
        onSurface: SkyeColors.textPrimary,
        onError: SkyeColors.whitePure,
      ),

      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: SkyeColors.surfaceDark,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        iconTheme: IconThemeData(color: SkyeColors.textPrimary),
        titleTextStyle: SkyeTypography.title,
      ),

      cardTheme: CardThemeData(
        elevation: 0,
        color: SkyeColors.surfaceMid,
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
        fillColor: SkyeColors.surfaceMid,
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
          borderSide: BorderSide(color: SkyeColors.textSecondary, width: 2),
        ),
        hintStyle: SkyeTypography.body.copyWith(color: SkyeColors.textMuted),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: SkyeColors.surfaceMid,
          foregroundColor: SkyeColors.textPrimary,
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
