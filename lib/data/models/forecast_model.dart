class ForecastModel {
  final String cityName;
  final List<HourlyForecast> hourlyForecasts;
  final List<DailyForecast> dailyForecasts;

  ForecastModel({
    required this.cityName,
    required this.hourlyForecasts,
    required this.dailyForecasts,
  });

  factory ForecastModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> list = json['list'] ?? [];

    // Parse hourly forecasts (next 24-48 hours)
    final hourlyForecasts = list
        .take(16)
        .map((item) => HourlyForecast.fromJson(item))
        .toList();

    // Parse daily forecasts by grouping by date
    final Map<String, List<HourlyForecast>> groupedByDate = {};
    for (var item in list) {
      final forecast = HourlyForecast.fromJson(item);
      final dateKey = DateTime.fromMillisecondsSinceEpoch(forecast.dt * 1000)
          .toIso8601String()
          .split('T')[0];

      if (!groupedByDate.containsKey(dateKey)) {
        groupedByDate[dateKey] = [];
      }
      groupedByDate[dateKey]!.add(forecast);
    }

    // Create daily forecasts from grouped data
    final dailyForecasts = groupedByDate.entries.map((entry) {
      final forecasts = entry.value;
      final temps = forecasts.map((f) => f.temperature).toList();
      final minTemp = temps.reduce((a, b) => a < b ? a : b);
      final maxTemp = temps.reduce((a, b) => a > b ? a : b);

      // Use the forecast at noon or closest to noon
      final noonForecast = forecasts.firstWhere(
        (f) {
          final hour = DateTime.fromMillisecondsSinceEpoch(f.dt * 1000).hour;
          return hour == 12;
        },
        orElse: () => forecasts[forecasts.length ~/ 2],
      );

      return DailyForecast(
        dt: noonForecast.dt,
        minTemp: minTemp,
        maxTemp: maxTemp,
        condition: noonForecast.condition,
        description: noonForecast.description,
        icon: noonForecast.icon,
        humidity: noonForecast.humidity,
        windSpeed: noonForecast.windSpeed,
        pop: noonForecast.pop,
      );
    }).toList();

    return ForecastModel(
      cityName: json['city']['name'] ?? '',
      hourlyForecasts: hourlyForecasts,
      dailyForecasts: dailyForecasts.take(7).toList(),
    );
  }
}

class HourlyForecast {
  final int dt;
  final double temperature;
  final double feelsLike;
  final String condition;
  final String description;
  final String icon;
  final int humidity;
  final double windSpeed;
  final double pop;

  HourlyForecast({
    required this.dt,
    required this.temperature,
    required this.feelsLike,
    required this.condition,
    required this.description,
    required this.icon,
    required this.humidity,
    required this.windSpeed,
    required this.pop,
  });

  factory HourlyForecast.fromJson(Map<String, dynamic> json) {
    return HourlyForecast(
      dt: json['dt'] ?? 0,
      temperature: (json['main']['temp'] as num).toDouble(),
      feelsLike: (json['main']['feels_like'] as num).toDouble(),
      condition: json['weather'][0]['main'] ?? '',
      description: json['weather'][0]['description'] ?? '',
      icon: json['weather'][0]['icon'] ?? '',
      humidity: json['main']['humidity'] ?? 0,
      windSpeed: (json['wind']['speed'] as num).toDouble(),
      pop: ((json['pop'] ?? 0) as num).toDouble(),
    );
  }
}

class DailyForecast {
  final int dt;
  final double minTemp;
  final double maxTemp;
  final String condition;
  final String description;
  final String icon;
  final int humidity;
  final double windSpeed;
  final double pop;

  DailyForecast({
    required this.dt,
    required this.minTemp,
    required this.maxTemp,
    required this.condition,
    required this.description,
    required this.icon,
    required this.humidity,
    required this.windSpeed,
    required this.pop,
  });

  String getDayName() {
    final date = DateTime.fromMillisecondsSinceEpoch(dt * 1000);
    final now = DateTime.now();

    if (date.day == now.day &&
        date.month == now.month &&
        date.year == now.year) {
      return 'Today';
    }

    final tomorrow = now.add(const Duration(days: 1));
    if (date.day == tomorrow.day &&
        date.month == tomorrow.month &&
        date.year == tomorrow.year) {
      return 'Tomorrow';
    }

    final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return weekdays[date.weekday - 1];
  }
}

