class WeatherModel {
  final String cityName;
  final double temperature;
  final double feelsLike;
  final String condition;
  final String description;
  final int humidity;
  final double windSpeed;
  final int pressure;
  final int visibility;
  final double lat;
  final double lon;
  final int sunrise;
  final int sunset;
  final String icon;
  final DateTime timestamp;

  WeatherModel({
    required this.cityName,
    required this.temperature,
    required this.feelsLike,
    required this.condition,
    required this.description,
    required this.humidity,
    required this.windSpeed,
    required this.pressure,
    required this.visibility,
    required this.lat,
    required this.lon,
    required this.sunrise,
    required this.sunset,
    required this.icon,
    required this.timestamp,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json['name'] ?? '',
      temperature: (json['main']['temp'] as num).toDouble(),
      feelsLike: (json['main']['feels_like'] as num).toDouble(),
      condition: json['weather'][0]['main'] ?? '',
      description: json['weather'][0]['description'] ?? '',
      humidity: json['main']['humidity'] ?? 0,
      windSpeed: (json['wind']['speed'] as num).toDouble(),
      pressure: json['main']['pressure'] ?? 0,
      visibility: json['visibility'] ?? 0,
      lat: (json['coord']['lat'] as num).toDouble(),
      lon: (json['coord']['lon'] as num).toDouble(),
      sunrise: json['sys']['sunrise'] ?? 0,
      sunset: json['sys']['sunset'] ?? 0,
      icon: json['weather'][0]['icon'] ?? '',
      timestamp: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': cityName,
      'main': {
        'temp': temperature,
        'feels_like': feelsLike,
        'humidity': humidity,
        'pressure': pressure,
      },
      'weather': [
        {
          'main': condition,
          'description': description,
          'icon': icon,
        }
      ],
      'wind': {
        'speed': windSpeed,
      },
      'visibility': visibility,
      'coord': {
        'lat': lat,
        'lon': lon,
      },
      'sys': {
        'sunrise': sunrise,
        'sunset': sunset,
      },
      'timestamp': timestamp.toIso8601String(),
    };
  }

  bool isDay() {
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    return now >= sunrise && now <= sunset;
  }

  WeatherCondition getWeatherCondition() {
    switch (condition.toLowerCase()) {
      case 'clear':
        return isDay() ? WeatherCondition.sunny : WeatherCondition.clearNight;
      case 'clouds':
        return WeatherCondition.cloudy;
      case 'rain':
      case 'drizzle':
        return WeatherCondition.rainy;
      case 'snow':
        return WeatherCondition.snowy;
      case 'thunderstorm':
        return WeatherCondition.thunderstorm;
      default:
        return WeatherCondition.cloudy;
    }
  }
}

enum WeatherCondition {
  sunny,
  clearNight,
  cloudy,
  rainy,
  snowy,
  thunderstorm,
}
