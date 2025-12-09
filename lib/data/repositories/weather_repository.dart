import '../models/weather_model.dart';
import '../models/forecast_model.dart';
import '../services/api_service.dart';

class WeatherRepository {
  final ApiService _apiService;

  WeatherRepository(this._apiService);

  Future<WeatherModel> getCurrentWeather(double lat, double lon) async {
    try {
      return await _apiService.getCurrentWeather(lat, lon);
    } catch (e) {
      rethrow;
    }
  }

  Future<ForecastModel> getForecast(double lat, double lon) async {
    try {
      return await _apiService.getForecast(lat, lon);
    } catch (e) {
      rethrow;
    }
  }
}

