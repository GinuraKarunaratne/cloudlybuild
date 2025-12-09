import '../models/user_alert_model.dart';
import '../models/weather_model.dart';
import '../services/storage_service.dart';

class UserAlertRepository {
  final StorageService _storageService;

  UserAlertRepository(this._storageService);

  Future<List<UserAlertModel>> getAllAlerts() async {
    return await _storageService.getUserAlerts();
  }

  Future<List<UserAlertModel>> getEnabledAlerts() async {
    final alerts = await _storageService.getUserAlerts();
    return alerts.where((alert) => alert.isEnabled).toList();
  }

  Future<void> createAlert(UserAlertModel alert) async {
    await _storageService.addUserAlert(alert);
  }

  Future<void> updateAlert(String alertId, UserAlertModel updatedAlert) async {
    await _storageService.updateUserAlert(alertId, updatedAlert);
  }

  Future<void> deleteAlert(String alertId) async {
    await _storageService.removeUserAlert(alertId);
  }

  Future<void> toggleAlertEnabled(String alertId, bool isEnabled) async {
    final alerts = await _storageService.getUserAlerts();
    final alert = alerts.firstWhere((a) => a.id == alertId);
    final updatedAlert = alert.copyWith(isEnabled: isEnabled);
    await _storageService.updateUserAlert(alertId, updatedAlert);
  }

  Future<List<UserAlertModel>> checkAlerts(WeatherModel weather) async {
    final enabledAlerts = await getEnabledAlerts();
    final triggeredAlerts = <UserAlertModel>[];

    print('🔔 Checking ${enabledAlerts.length} enabled alerts');

    for (final alert in enabledAlerts) {
      double value;

      switch (alert.conditionType) {
        case AlertConditionType.temperature:
          value = weather.temperature;
          break;
        case AlertConditionType.feelsLike:
          value = weather.feelsLike;
          break;
        case AlertConditionType.humidity:
          value = weather.humidity.toDouble();
          break;
        case AlertConditionType.windSpeed:
          value = weather.windSpeed;
          break;
        case AlertConditionType.precipitation:
          value = 0.0;
          break;
      }

      print('🔔 Alert: ${alert.name}');
      print('   Checking: ${alert.conditionDescription}');
      print('   Current value: $value');
      print('   Triggered: ${alert.checkCondition(value)}');

      if (alert.checkCondition(value)) {
        triggeredAlerts.add(alert);
        final now = DateTime.now();
        final lastTriggered = alert.lastTriggered;

        if (lastTriggered == null ||
            now.difference(lastTriggered).inMinutes > 30) {
          final updatedAlert = alert.copyWith(lastTriggered: now);
          await updateAlert(alert.id, updatedAlert);
          print('   ✅ Alert triggered and updated!');
        } else {
          print('   ⏰ Alert triggered but in cooldown period');
        }
      }
    }

    print('🔔 Total triggered alerts: ${triggeredAlerts.length}');
    return triggeredAlerts;
  }
}

