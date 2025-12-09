class ApiConstants {
  static const String apiKey = 'fbc216c32c587af84890e6f8a5beb1d5';
  static const String baseUrl = 'https://api.openweathermap.org';

  // API Endpoints
  static const String currentWeather = '/data/2.5/weather';
  static const String forecast = '/data/2.5/forecast';
  static const String oneCall = '/data/3.0/onecall';
  static const String geocoding = '/geo/1.0/direct';

  // Request timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Cache durations
  static const Duration weatherCacheDuration = Duration(minutes: 10);
  static const Duration forecastCacheDuration = Duration(hours: 1);
}

