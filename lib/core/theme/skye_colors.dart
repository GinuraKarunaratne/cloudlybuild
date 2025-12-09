import 'package:flutter/material.dart';

/// Skye Design System - Aurora Glass Palette
/// A premium glassmorphism color system for immersive weather experiences
class SkyeColors {
  // Base Backgrounds
  static const Color deepSpace = Color(0xFF020617);
  static const Color surfaceDark = Color(0xFF0B1220);
  static const Color surfaceMid = Color(0xFF1E293B);

  // Primary Accents
  static const Color skyBlue = Color(0xFF38BDF8);
  static const Color twilightPurple = Color(0xFFA855F7);
  static const Color sunYellow = Color(0xFFFACC15);

  // Weather Condition Colors
  static const Color moonLight = Color(0xFFC4B5FD);
  static const Color rainBlue = Color(0xFF0EA5E9);
  static const Color stormPurple = Color(0xFF7C3AED);
  static const Color snowWhite = Color(0xFFE0F2FE);
  static const Color cloudGray = Color(0xFF94A3B8);

  // Text Colors
  static const Color textPrimary = Color(0xFFF9FAFB);
  static const Color textSecondary = Color(0xFFE5E7EB);
  static const Color textTertiary = Color(0xFF9CA3AF);
  static const Color textMuted = Color(0xFF6B7280);

  // Glass Effects
  static Color glassLight = Colors.white.withOpacity(0.1);
  static Color glassMedium = Colors.white.withOpacity(0.15);
  static Color glassHeavy = Colors.white.withOpacity(0.2);
  static Color glassBorder = Colors.white.withOpacity(0.2);
  static Color glassHighlight = Colors.white.withOpacity(0.05);

  // Shadows & Overlays
  static Color shadowSoft = Colors.black.withOpacity(0.1);
  static Color shadowMedium = Colors.black.withOpacity(0.2);
  static Color shadowHard = Colors.black.withOpacity(0.3);
  static Color overlay = Colors.black.withOpacity(0.4);

  // Weather-Adaptive Gradients
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

  // State Colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);
}
