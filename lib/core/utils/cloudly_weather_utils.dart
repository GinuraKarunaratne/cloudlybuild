import 'package:flutter/material.dart';
import '../theme/cloudly_theme.dart';
import '../../data/models/weather_model.dart';

/// Weather utilities for Skye design system
class SkyeWeatherUtils {
  /// Get weather gradient based on condition
  static LinearGradient getWeatherGradient(WeatherCondition condition) {
    switch (condition) {
      case WeatherCondition.sunny:
        return SkyeColors.sunnyGradient;
      case WeatherCondition.clearNight:
        return SkyeColors.clearNightGradient;
      case WeatherCondition.cloudy:
        return SkyeColors.cloudyGradient;
      case WeatherCondition.rainy:
        return SkyeColors.rainyGradient;
      case WeatherCondition.snowy:
        return SkyeColors.snowyGradient;
      case WeatherCondition.thunderstorm:
        return SkyeColors.thunderstormGradient;
    }
  }

  /// Get weather icon based on condition
  static IconData getWeatherIcon(WeatherCondition condition) {
    switch (condition) {
      case WeatherCondition.sunny:
        return Icons.wb_sunny_rounded;
      case WeatherCondition.clearNight:
        return Icons.nightlight_round;
      case WeatherCondition.cloudy:
        return Icons.cloud_rounded;
      case WeatherCondition.rainy:
        return Icons.water_drop_rounded;
      case WeatherCondition.snowy:
        return Icons.ac_unit_rounded;
      case WeatherCondition.thunderstorm:
        return Icons.thunderstorm_rounded;
    }
  }

  /// Format temperature with degree symbol
  static String formatTemperature(double temp, {bool showUnit = true}) {
    return '${temp.round()}${showUnit ? '°' : ''}';
  }

  /// Format wind speed
  static String formatWindSpeed(double speed) {
    return '${speed.toStringAsFixed(1)} m/s';
  }

  /// Format humidity
  static String formatHumidity(int humidity) {
    return '$humidity%';
  }

  /// Format pressure
  static String formatPressure(int pressure) {
    return '$pressure hPa';
  }

  /// Format visibility in km
  static String formatVisibility(int visibility) {
    return '${(visibility / 1000).toStringAsFixed(1)} km';
  }

  /// Get condition text with proper casing
  static String getConditionText(String condition) {
    return condition.isNotEmpty
        ? condition[0].toUpperCase() + condition.substring(1).toLowerCase()
        : '';
  }

  /// Get weather icon from condition string
  static IconData getIconFromCondition(String condition, {String? iconCode}) {
    // OpenWeatherMap icon codes: https://openweathermap.org/weather-conditions
    // 01d = clear day, 01n = clear night, 02d = few clouds, 03d = scattered clouds
    // 04d = broken clouds, 09d = shower rain, 10d = rain, 11d = thunderstorm
    // 13d = snow, 50d = mist

    if (iconCode != null) {
      if (iconCode.startsWith('01d')) return Icons.wb_sunny_rounded;
      if (iconCode.startsWith('01n')) return Icons.nightlight_round;
      if (iconCode.startsWith('02')) return Icons.wb_cloudy_rounded;
      if (iconCode.startsWith('03') || iconCode.startsWith('04')) {
        return Icons.cloud_rounded;
      }
      if (iconCode.startsWith('09') || iconCode.startsWith('10')) {
        return Icons.water_drop_rounded;
      }
      if (iconCode.startsWith('11')) return Icons.thunderstorm_rounded;
      if (iconCode.startsWith('13')) return Icons.ac_unit_rounded;
      if (iconCode.startsWith('50')) return Icons.foggy;
    }

    // Fallback to condition string
    final conditionLower = condition.toLowerCase();
    if (conditionLower.contains('clear')) {
      return Icons.wb_sunny_rounded;
    } else if (conditionLower.contains('cloud')) {
      return Icons.cloud_rounded;
    } else if (conditionLower.contains('rain') || conditionLower.contains('drizzle')) {
      return Icons.water_drop_rounded;
    } else if (conditionLower.contains('thunder')) {
      return Icons.thunderstorm_rounded;
    } else if (conditionLower.contains('snow')) {
      return Icons.ac_unit_rounded;
    } else if (conditionLower.contains('mist') || conditionLower.contains('fog')) {
      return Icons.foggy;
    }

    return Icons.wb_cloudy_rounded;
  }

  /// Get weather icon color from condition
  static Color getIconColor(String condition, {String? iconCode}) {
    if (iconCode != null) {
      if (iconCode.startsWith('01d')) return SkyeColors.sunYellow;
      if (iconCode.startsWith('01n')) return SkyeColors.moonLight;
      if (iconCode.startsWith('09') || iconCode.startsWith('10')) {
        return SkyeColors.rainBlue;
      }
      if (iconCode.startsWith('11')) return SkyeColors.stormPurple;
      if (iconCode.startsWith('13')) return SkyeColors.snowWhite;
    }

    final conditionLower = condition.toLowerCase();
    if (conditionLower.contains('clear')) {
      return SkyeColors.sunYellow;
    } else if (conditionLower.contains('rain') || conditionLower.contains('drizzle')) {
      return SkyeColors.rainBlue;
    } else if (conditionLower.contains('thunder')) {
      return SkyeColors.stormPurple;
    } else if (conditionLower.contains('snow')) {
      return SkyeColors.snowWhite;
    }

    return SkyeColors.cloudGray;
  }
}

