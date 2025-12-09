import '../../data/models/forecast_model.dart';
import '../../data/models/weather_alert_model.dart';

class SmartAlertGenerator {
  /// Generate smart weather alerts from forecast data
  static List<WeatherAlertModel> generateSmartAlerts(
    ForecastModel forecast,
    String cityName,
  ) {
    final alerts = <WeatherAlertModel>[];
    final now = DateTime.now();

    // Analyze hourly forecasts for upcoming conditions
    final next24Hours =
        forecast.hourlyForecasts.where((h) => h.dt > now.millisecondsSinceEpoch ~/ 1000).take(8).toList();

    if (next24Hours.isEmpty) return alerts;

    // 1. Check for incoming rain
    final rainAlert = _checkIncomingRain(next24Hours, now);
    if (rainAlert != null) alerts.add(rainAlert);

    // 2. Check for heavy rain
    final heavyRainAlert = _checkHeavyRain(next24Hours, now);
    if (heavyRainAlert != null) alerts.add(heavyRainAlert);

    // 3. Check for thunderstorms
    final thunderstormAlert = _checkThunderstorm(next24Hours, now);
    if (thunderstormAlert != null) alerts.add(thunderstormAlert);

    // 4. Check for snow
    final snowAlert = _checkSnow(next24Hours, now);
    if (snowAlert != null) alerts.add(snowAlert);

    // 5. Check for freezing temperatures
    final freezeAlert = _checkFreezingTemperature(next24Hours, now);
    if (freezeAlert != null) alerts.add(freezeAlert);

    // 6. Check for high winds
    final windAlert = _checkHighWinds(next24Hours, now);
    if (windAlert != null) alerts.add(windAlert);

    // 7. Check for temperature drops
    final tempDropAlert = _checkTemperatureDrop(next24Hours, now);
    if (tempDropAlert != null) alerts.add(tempDropAlert);

    // 8. Check for extreme heat
    final heatAlert = _checkExtremeHeat(next24Hours, now);
    if (heatAlert != null) alerts.add(heatAlert);

    return alerts;
  }

  static WeatherAlertModel? _checkIncomingRain(
    List<HourlyForecast> forecasts,
    DateTime now,
  ) {
    // Check for rain in next 3-6 hours with >60% probability
    final next6Hours = forecasts.take(2).toList();

    for (var forecast in next6Hours) {
      if (forecast.pop >= 0.6 && !forecast.condition.toLowerCase().contains('clear')) {
        final startTime = forecast.dt;
        final hoursUntil = ((startTime - now.millisecondsSinceEpoch ~/ 1000) / 3600).round();

        return WeatherAlertModel(
          event: 'Rain Expected',
          description:
              'Rain is expected in approximately $hoursUntil hour${hoursUntil != 1 ? 's' : ''}. '
              'Probability of precipitation: ${(forecast.pop * 100).round()}%. '
              'Bring an umbrella if heading out!',
          startTime: startTime,
          endTime: startTime + 10800, // 3 hours duration
          senderName: '',
          tags: ['rain', 'precipitation'],
        );
      }
    }
    return null;
  }

  static WeatherAlertModel? _checkHeavyRain(
    List<HourlyForecast> forecasts,
    DateTime now,
  ) {
    // Check for heavy rain (>80% pop and Rain condition)
    for (var forecast in forecasts) {
      final condition = forecast.condition.toLowerCase();
      if (forecast.pop >= 0.8 && condition.contains('rain')) {
        final startTime = forecast.dt;
        final hoursUntil = ((startTime - now.millisecondsSinceEpoch ~/ 1000) / 3600).round();

        return WeatherAlertModel(
          event: 'Heavy Rain Warning',
          description:
              'Heavy rainfall expected in approximately $hoursUntil hour${hoursUntil != 1 ? 's' : ''}. '
              'Probability: ${(forecast.pop * 100).round()}%. '
              'Exercise caution when travelling. Flooding possible in low-lying areas.',
          startTime: startTime,
          endTime: startTime + 14400, // 4 hours duration
          senderName: '',
          tags: ['heavy rain', 'severe', 'amber'],
        );
      }
    }
    return null;
  }

  static WeatherAlertModel? _checkThunderstorm(
    List<HourlyForecast> forecasts,
    DateTime now,
  ) {
    // Check for thunderstorms
    for (var forecast in forecasts) {
      if (forecast.condition.toLowerCase().contains('thunderstorm')) {
        final startTime = forecast.dt;
        final hoursUntil = ((startTime - now.millisecondsSinceEpoch ~/ 1000) / 3600).round();

        return WeatherAlertModel(
          event: 'Thunderstorm Warning',
          description:
              'Thunderstorms expected in approximately $hoursUntil hour${hoursUntil != 1 ? 's' : ''}. '
              'Probability: ${(forecast.pop * 100).round()}%. '
              'Seek shelter indoors. Avoid outdoor activities. Lightning and heavy rain possible.',
          startTime: startTime,
          endTime: startTime + 10800, // 3 hours duration
          senderName: '',
          tags: ['thunderstorm', 'severe', 'orange'],
        );
      }
    }
    return null;
  }

  static WeatherAlertModel? _checkSnow(
    List<HourlyForecast> forecasts,
    DateTime now,
  ) {
    // Check for snow
    for (var forecast in forecasts) {
      if (forecast.condition.toLowerCase().contains('snow')) {
        final startTime = forecast.dt;
        final hoursUntil = ((startTime - now.millisecondsSinceEpoch ~/ 1000) / 3600).round();

        return WeatherAlertModel(
          event: 'Snow Expected',
          description:
              'Snowfall expected in approximately $hoursUntil hour${hoursUntil != 1 ? 's' : ''}. '
              'Probability: ${(forecast.pop * 100).round()}%. '
              'Prepare for possible travel disruptions. Drive carefully and allow extra time for journeys.',
          startTime: startTime,
          endTime: startTime + 21600, // 6 hours duration
          senderName: '',
          tags: ['snow', 'winter', 'amber'],
        );
      }
    }
    return null;
  }

  static WeatherAlertModel? _checkFreezingTemperature(
    List<HourlyForecast> forecasts,
    DateTime now,
  ) {
    // Check for temperatures below 0°C
    for (var forecast in forecasts) {
      if (forecast.temperature <= 0) {
        final startTime = forecast.dt;
        final hoursUntil = ((startTime - now.millisecondsSinceEpoch ~/ 1000) / 3600).round();

        return WeatherAlertModel(
          event: 'Freezing Temperature Warning',
          description:
              'Temperatures will drop to ${forecast.temperature.round()}°C in approximately $hoursUntil hour${hoursUntil != 1 ? 's' : ''}. '
              'Frost and ice likely. Protect sensitive plants. Watch for icy roads and pavements.',
          startTime: startTime,
          endTime: startTime + 28800, // 8 hours duration
          senderName: '',
          tags: ['frost', 'freeze', 'yellow'],
        );
      }
    }
    return null;
  }

  static WeatherAlertModel? _checkHighWinds(
    List<HourlyForecast> forecasts,
    DateTime now,
  ) {
    // Check for high winds (>13 m/s or ~30 mph)
    for (var forecast in forecasts) {
      if (forecast.windSpeed >= 13) {
        final startTime = forecast.dt;
        final hoursUntil = ((startTime - now.millisecondsSinceEpoch ~/ 1000) / 3600).round();

        return WeatherAlertModel(
          event: 'High Wind Warning',
          description:
              'Strong winds of ${forecast.windSpeed.toStringAsFixed(1)} m/s expected in approximately $hoursUntil hour${hoursUntil != 1 ? 's' : ''}. '
              'Secure loose items outdoors. Driving may be hazardous, especially for high-sided vehicles.',
          startTime: startTime,
          endTime: startTime + 14400, // 4 hours duration
          senderName: '',
          tags: ['wind', 'amber'],
        );
      }
    }
    return null;
  }

  static WeatherAlertModel? _checkTemperatureDrop(
    List<HourlyForecast> forecasts,
    DateTime now,
  ) {
    // Check for significant temperature drops (>10°C in 6 hours)
    if (forecasts.length < 2) return null;

    final current = forecasts.first;
    final later = forecasts.length > 2 ? forecasts[2] : forecasts.last;

    final tempDrop = current.temperature - later.temperature;

    if (tempDrop >= 10) {
      final startTime = current.dt;
      final endTime = later.dt;

      return WeatherAlertModel(
        event: 'Significant Temperature Drop',
        description:
            'Temperature will drop from ${current.temperature.round()}°C to ${later.temperature.round()}°C '
            'over the next few hours. Dress warmly and prepare for colder conditions.',
        startTime: startTime,
        endTime: endTime,
        senderName: '',
        tags: ['temperature', 'cold'],
      );
    }
    return null;
  }

  static WeatherAlertModel? _checkExtremeHeat(
    List<HourlyForecast> forecasts,
    DateTime now,
  ) {
    // Check for extreme heat (>30°C)
    for (var forecast in forecasts) {
      if (forecast.temperature >= 30) {
        final startTime = forecast.dt;
        final hoursUntil = ((startTime - now.millisecondsSinceEpoch ~/ 1000) / 3600).round();

        return WeatherAlertModel(
          event: 'High Temperature Advisory',
          description:
              'Temperature will reach ${forecast.temperature.round()}°C in approximately $hoursUntil hour${hoursUntil != 1 ? 's' : ''}. '
              'Stay hydrated, seek shade, and avoid strenuous outdoor activities during peak heat.',
          startTime: startTime,
          endTime: startTime + 21600, // 6 hours duration
          senderName: '',
          tags: ['heat', 'yellow'],
        );
      }
    }
    return null;
  }
}

