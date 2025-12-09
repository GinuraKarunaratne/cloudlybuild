import '../../../data/models/user_alert_model.dart';

class UserAlertsState {
  final bool isLoading;
  final List<UserAlertModel> alerts;
  final String? error;

  UserAlertsState({
    this.isLoading = false,
    this.alerts = const [],
    this.error,
  });

  UserAlertsState copyWith({
    bool? isLoading,
    List<UserAlertModel>? alerts,
    String? error,
  }) {
    return UserAlertsState(
      isLoading: isLoading ?? this.isLoading,
      alerts: alerts ?? this.alerts,
      error: error,
    );
  }

  int get alertCount => alerts.length;
  int get enabledAlertsCount => alerts.where((a) => a.isEnabled).length;
  List<UserAlertModel> get enabledAlerts => alerts.where((a) => a.isEnabled).toList();
}
