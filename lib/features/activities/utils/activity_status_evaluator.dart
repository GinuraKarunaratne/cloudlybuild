import 'package:flutter/material.dart';
import '../../../core/theme/skye_theme.dart';
import '../models/activity_model.dart';

class ActivityStatusEvaluator {
  static ActivityStatus evaluateStatus(
    Activity activity, {
    required double currentTemp,
    required double currentWind,
    required double currentVisibility,
    required double currentUV,
  }) {
    bool tempOk = currentTemp >= activity.minTemp && currentTemp <= activity.maxTemp;
    bool windOk = currentWind <= activity.maxWind;
    bool visibilityOk = currentVisibility >= activity.minVisibility;
    bool uvOk = currentUV <= activity.maxUV;

    int conditionsMet = 0;
    if (tempOk) conditionsMet++;
    if (windOk) conditionsMet++;
    if (visibilityOk) conditionsMet++;
    if (uvOk) conditionsMet++;

    if (conditionsMet == 4) return ActivityStatus.perfect;
    if (conditionsMet >= 2) return ActivityStatus.caution;
    return ActivityStatus.notRecommended;
  }

  static String getStatusLabel(ActivityStatus status) {
    switch (status) {
      case ActivityStatus.perfect:
        return 'Perfect Today!';
      case ActivityStatus.caution:
        return 'Possible, but caution';
      case ActivityStatus.notRecommended:
        return 'Not Recommended Today';
    }
  }

  static Color getStatusColor(ActivityStatus status) {
    switch (status) {
      case ActivityStatus.perfect:
        return SkyeColors.success;
      case ActivityStatus.caution:
        return SkyeColors.warning;
      case ActivityStatus.notRecommended:
        return SkyeColors.error;
    }
  }

  static String getStatusIcon(ActivityStatus status) {
    switch (status) {
      case ActivityStatus.perfect:
        return '🟢';
      case ActivityStatus.caution:
        return '🟡';
      case ActivityStatus.notRecommended:
        return '🔴';
    }
  }

  static String buildConditionSummary(
    Activity activity, {
    required double currentTemp,
    required double currentWind,
    required double currentVisibility,
    required double currentUV,
  }) {
    final conditions = <String>[];

    // Temperature
    if (currentTemp >= activity.minTemp && currentTemp <= activity.maxTemp) {
      conditions.add('Temp: ${currentTemp.toStringAsFixed(1)}°C ✓');
    } else {
      conditions.add('Temp: ${currentTemp.toStringAsFixed(1)}°C ✗');
    }

    // Wind
    if (currentWind <= activity.maxWind) {
      conditions.add('Wind: ${currentWind.toStringAsFixed(1)} m/s ✓');
    } else {
      conditions.add('Wind: ${currentWind.toStringAsFixed(1)} m/s ✗');
    }

    // Visibility
    if (currentVisibility >= activity.minVisibility) {
      conditions.add('Visibility: ${currentVisibility.toStringAsFixed(0)} km ✓');
    } else {
      conditions.add('Visibility: ${currentVisibility.toStringAsFixed(0)} km ✗');
    }

    // UV
    if (currentUV <= activity.maxUV) {
      conditions.add('UV: ${currentUV.toStringAsFixed(1)} ✓');
    } else {
      conditions.add('UV: ${currentUV.toStringAsFixed(1)} ✗');
    }

    return conditions.join(' | ');
  }
}
