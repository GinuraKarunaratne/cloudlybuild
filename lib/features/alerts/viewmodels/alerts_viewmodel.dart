import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/weather_alert_model.dart';
import '../../../data/models/user_alert_model.dart';
import '../../../core/providers/providers.dart';
import '../../home/viewmodels/home_viewmodel.dart';

class AlertsState {
  final bool isLoading;
  final List<WeatherAlertModel> alerts;
  final List<UserAlertModel> userAlerts;
  final String? error;

  AlertsState({
    this.isLoading = false,
    this.alerts = const [],
    this.userAlerts = const [],
    this.error,
  });

  AlertsState copyWith({
    bool? isLoading,
    List<WeatherAlertModel>? alerts,
    List<UserAlertModel>? userAlerts,
    String? error,
  }) {
    return AlertsState(
      isLoading: isLoading ?? this.isLoading,
      alerts: alerts ?? this.alerts,
      userAlerts: userAlerts ?? this.userAlerts,
      error: error,
    );
  }

  /// Get count of active alerts (weather + triggered user alerts)
  int get activeAlertsCount {
    return alerts.where((alert) => alert.isActive()).length + userAlerts.length;
  }

  /// Check if there are any active alerts
  bool get hasActiveAlerts {
    return activeAlertsCount > 0;
  }

  /// Get alerts sorted by severity (extreme first)
  List<WeatherAlertModel> get sortedAlerts {
    final sorted = List<WeatherAlertModel>.from(alerts);
    sorted.sort((a, b) {
      final aSeverity = a.getSeverity().index;
      final bSeverity = b.getSeverity().index;
      return bSeverity.compareTo(aSeverity);
    });
    return sorted;
  }
}

class AlertsNotifier extends StateNotifier<AlertsState> {
  final Ref ref;

  AlertsNotifier(this.ref) : super(AlertsState());

  Future<void> loadWeatherAlerts(double lat, double lon) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final alertsRepo = ref.read(weatherAlertsRepositoryProvider);
      final userAlertRepo = ref.read(userAlertRepositoryProvider);

      // Get forecast data from home state for smart alerts
      final homeState = ref.read(homeProvider);
      final forecast = homeState.forecast;
      final weather = homeState.weather;

      final alerts = await alertsRepo.getWeatherAlerts(lat, lon, forecast);

      // Check user alerts and get triggered ones
      List<UserAlertModel> triggeredUserAlerts = [];
      if (weather != null) {
        triggeredUserAlerts = await userAlertRepo.checkAlerts(weather);
      }

      state = state.copyWith(
        isLoading: false,
        alerts: alerts,
        userAlerts: triggeredUserAlerts,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> refreshAlerts(double lat, double lon) async {
    await loadWeatherAlerts(lat, lon);
  }
}

final alertsProvider = StateNotifierProvider<AlertsNotifier, AlertsState>((ref) {
  return AlertsNotifier(ref);
});
