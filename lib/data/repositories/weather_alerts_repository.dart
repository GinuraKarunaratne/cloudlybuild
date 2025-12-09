import '../models/weather_alert_model.dart';
import '../models/forecast_model.dart';
import '../services/api_service.dart';
import '../../core/utils/smart_alert_generator.dart';

class WeatherAlertsRepository {
  final ApiService _apiService;

  WeatherAlertsRepository(this._apiService);

  Future<List<WeatherAlertModel>> getWeatherAlerts(
    double lat,
    double lon,
    ForecastModel? forecast,
  ) async {
    final List<WeatherAlertModel> allAlerts = [];

    // Try to get official government alerts from API
    try {
      final apiAlerts = await _apiService.getWeatherAlerts(lat, lon);
      allAlerts.addAll(apiAlerts);
    } catch (e) {
      print('Could not fetch official alerts: $e');
    }

    // Generate smart alerts from forecast data
    if (forecast != null) {
      final smartAlerts =
          SmartAlertGenerator.generateSmartAlerts(forecast, forecast.cityName);
      allAlerts.addAll(smartAlerts);
    }

    // Remove duplicates based on event name
    final uniqueAlerts = <String, WeatherAlertModel>{};
    for (var alert in allAlerts) {
      if (!uniqueAlerts.containsKey(alert.event)) {
        uniqueAlerts[alert.event] = alert;
      }
    }

    return uniqueAlerts.values.toList();
  }
}

