import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'skye_colors.dart';

/// Skye Design System - Typography Scale
/// Refined, modern typography with proper tracking and hierarchy
class SkyeTypography {
  // Display - Hero Temperature
  static TextStyle display = GoogleFonts.inter(
    fontSize: 120,
    fontWeight: FontWeight.w200,
    color: SkyeColors.textPrimary,
    height: 1.0,
    letterSpacing: -6.0,
  );

  // Display Small - Large Numbers
  static TextStyle displaySmall = GoogleFonts.inter(
    fontSize: 72,
    fontWeight: FontWeight.w300,
    color: SkyeColors.textPrimary,
    height: 1.0,
    letterSpacing: -3.0,
  );

  // Headline - Location, Titles
  static TextStyle headline = GoogleFonts.inter(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    color: SkyeColors.textPrimary,
    height: 1.2,
    letterSpacing: -0.5,
  );

  // Title - Section Headers
  static TextStyle title = GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: SkyeColors.textPrimary,
    height: 1.3,
    letterSpacing: -0.3,
  );

  // Subtitle - Supporting Headers
  static TextStyle subtitle = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: SkyeColors.textSecondary,
    height: 1.4,
    letterSpacing: 0,
  );

  // Body Large - Primary Content
  static TextStyle bodyLarge = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: SkyeColors.textSecondary,
    height: 1.5,
    letterSpacing: 0,
  );

  // Body - Regular Content
  static TextStyle body = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: SkyeColors.textSecondary,
    height: 1.5,
    letterSpacing: 0,
  );

  // Body Small - Compact Content
  static TextStyle bodySmall = GoogleFonts.inter(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: SkyeColors.textTertiary,
    height: 1.4,
    letterSpacing: 0,
  );

  // Label - UI Labels, Tags
  static TextStyle label = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: SkyeColors.textTertiary,
    height: 1.3,
    letterSpacing: 0.5,
  );

  // Caption - Smallest Text
  static TextStyle caption = GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: SkyeColors.textMuted,
    height: 1.3,
    letterSpacing: 0.3,
  );

  // Metric Value - Large Data Points
  static TextStyle metricValue = GoogleFonts.inter(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    color: SkyeColors.textPrimary,
    height: 1.1,
    letterSpacing: -1.0,
  );

  // Metric Label - Data Labels
  static TextStyle metricLabel = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: SkyeColors.textTertiary,
    height: 1.3,
    letterSpacing: 0.5,
  );

  // Condition - Weather Description
  static TextStyle condition = GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: SkyeColors.textSecondary,
    height: 1.3,
    letterSpacing: 0.5,
  );

  // Temperature - Medium Temps
  static TextStyle temperature = GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: SkyeColors.textPrimary,
    height: 1.2,
    letterSpacing: -0.5,
  );
}
