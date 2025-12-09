/// UV Index data model with sun safety information
class UVDataModel {
  final double uvIndex;
  final int sunrise;
  final int sunset;

  UVDataModel({
    required this.uvIndex,
    required this.sunrise,
    required this.sunset,
  });

  factory UVDataModel.fromJson(Map<String, dynamic> json) {
    return UVDataModel(
      uvIndex: (json['uvi'] as num?)?.toDouble() ?? 0.0,
      sunrise: json['sunrise'] as int? ?? 0,
      sunset: json['sunset'] as int? ?? 0,
    );
  }

  /// Get UV safety level
  UVSafetyLevel getSafetyLevel() {
    if (uvIndex <= 2) {
      return UVSafetyLevel.low;
    } else if (uvIndex <= 5) {
      return UVSafetyLevel.moderate;
    } else if (uvIndex <= 7) {
      return UVSafetyLevel.high;
    } else if (uvIndex <= 10) {
      return UVSafetyLevel.veryHigh;
    } else {
      return UVSafetyLevel.extreme;
    }
  }

  /// Check if currently in golden hour (1 hour after sunrise or before sunset)
  bool isGoldenHour() {
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final goldenHourMorningEnd = sunrise + 3600; // 1 hour after sunrise
    final goldenHourEveningStart = sunset - 3600; // 1 hour before sunset

    return (now >= sunrise && now <= goldenHourMorningEnd) ||
        (now >= goldenHourEveningStart && now <= sunset);
  }

  /// Check if in peak sun hours (10 AM - 4 PM typically)
  bool isPeakSunHours() {
    final now = DateTime.now();
    final hour = now.hour;
    return hour >= 10 && hour < 16;
  }

  /// Get formatted sunrise time
  String getSunriseFormatted() {
    final time = DateTime.fromMillisecondsSinceEpoch(sunrise * 1000);
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  /// Get formatted sunset time
  String getSunsetFormatted() {
    final time = DateTime.fromMillisecondsSinceEpoch(sunset * 1000);
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  /// Get hours of daylight
  int getDaylightHours() {
    final daylightSeconds = sunset - sunrise;
    return daylightSeconds ~/ 3600;
  }

  /// Get minutes of remaining daylight
  int getDaylightMinutes() {
    final daylightSeconds = sunset - sunrise;
    final hours = daylightSeconds ~/ 3600;
    final minutes = (daylightSeconds % 3600) ~/ 60;
    return hours * 60 + minutes;
  }
}

/// UV Safety levels based on WHO standards
enum UVSafetyLevel {
  low,
  moderate,
  high,
  veryHigh,
  extreme,
}

