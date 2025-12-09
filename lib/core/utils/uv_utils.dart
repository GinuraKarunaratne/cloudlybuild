import 'package:flutter/material.dart';
import '../theme/skye_theme.dart';
import '../../data/models/uv_data_model.dart';

class UVUtils {
  /// Get UV safety level name
  static String getSafetyLevelName(UVSafetyLevel level) {
    switch (level) {
      case UVSafetyLevel.low:
        return 'Low';
      case UVSafetyLevel.moderate:
        return 'Moderate';
      case UVSafetyLevel.high:
        return 'High';
      case UVSafetyLevel.veryHigh:
        return 'Very High';
      case UVSafetyLevel.extreme:
        return 'Extreme';
    }
  }

  /// Get UV safety level color
  static Color getSafetyLevelColor(UVSafetyLevel level) {
    switch (level) {
      case UVSafetyLevel.low:
        return const Color(0xFF4ADE80); // Green
      case UVSafetyLevel.moderate:
        return SkyeColors.sunYellow; // Yellow
      case UVSafetyLevel.high:
        return const Color(0xFFFB923C); // Orange
      case UVSafetyLevel.veryHigh:
        return const Color(0xFFF87171); // Red
      case UVSafetyLevel.extreme:
        return const Color(0xFFDC2626); // Deep Red
    }
  }

  /// Get UV safety level gradient
  static LinearGradient getSafetyLevelGradient(UVSafetyLevel level) {
    switch (level) {
      case UVSafetyLevel.low:
        return const LinearGradient(
          colors: [Color(0xFF4ADE80), Color(0xFF22C55E)],
        );
      case UVSafetyLevel.moderate:
        return LinearGradient(
          colors: [SkyeColors.sunYellow, const Color(0xFFFBBF24)],
        );
      case UVSafetyLevel.high:
        return const LinearGradient(
          colors: [Color(0xFFFB923C), Color(0xFFF97316)],
        );
      case UVSafetyLevel.veryHigh:
        return const LinearGradient(
          colors: [Color(0xFFF87171), Color(0xFFEF4444)],
        );
      case UVSafetyLevel.extreme:
        return const LinearGradient(
          colors: [Color(0xFFDC2626), Color(0xFFB91C1C)],
        );
    }
  }

  /// Get protection recommendation
  static String getProtectionRecommendation(UVSafetyLevel level) {
    switch (level) {
      case UVSafetyLevel.low:
        return 'No protection needed';
      case UVSafetyLevel.moderate:
        return 'Sunscreen recommended';
      case UVSafetyLevel.high:
        return 'Sunscreen & hat advised';
      case UVSafetyLevel.veryHigh:
        return 'Full sun protection required';
      case UVSafetyLevel.extreme:
        return 'Avoid sun exposure';
    }
  }

  /// Get detailed safety message
  static String getDetailedSafetyMessage(UVSafetyLevel level, bool isPeakHours) {
    final String peakWarning =
        isPeakHours ? ' Peak sun hours - extra caution needed.' : '';

    switch (level) {
      case UVSafetyLevel.low:
        return 'Minimal sun protection required. Safe for outdoor activities.$peakWarning';
      case UVSafetyLevel.moderate:
        return 'Wear sunscreen SPF 30+. Seek shade during midday hours.$peakWarning';
      case UVSafetyLevel.high:
        return 'Sunscreen SPF 30+, hat, and sunglasses essential. Seek shade frequently.$peakWarning';
      case UVSafetyLevel.veryHigh:
        return 'Avoid sun 10 AM-4 PM. Wear protective clothing, sunscreen SPF 50+.$peakWarning';
      case UVSafetyLevel.extreme:
        return 'Minimize outdoor exposure. Full protection mandatory if outside.$peakWarning';
    }
  }

  /// Get icon for UV level
  static IconData getUVIcon(UVSafetyLevel level) {
    switch (level) {
      case UVSafetyLevel.low:
        return Icons.wb_sunny_outlined;
      case UVSafetyLevel.moderate:
        return Icons.wb_sunny_rounded;
      case UVSafetyLevel.high:
      case UVSafetyLevel.veryHigh:
        return Icons.wb_sunny;
      case UVSafetyLevel.extreme:
        return Icons.warning_amber_rounded;
    }
  }

  /// Calculate UV risk progress (0.0 to 1.0)
  static double getUVRiskProgress(double uvIndex) {
    // Max UV index typically 11-12, we'll use 12 as max
    return (uvIndex / 12).clamp(0.0, 1.0);
  }

  /// Get UV index range text
  static String getUVIndexRangeText(UVSafetyLevel level) {
    switch (level) {
      case UVSafetyLevel.low:
        return '0-2';
      case UVSafetyLevel.moderate:
        return '3-5';
      case UVSafetyLevel.high:
        return '6-7';
      case UVSafetyLevel.veryHigh:
        return '8-10';
      case UVSafetyLevel.extreme:
        return '11+';
    }
  }
}
