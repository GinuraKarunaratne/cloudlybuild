import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/user_alert_model.dart';
import '../../../data/repositories/user_alert_repository.dart';
import '../../../core/providers/providers.dart';
import 'user_alerts_state.dart';

final userAlertsProvider = StateNotifierProvider<UserAlertsNotifier, UserAlertsState>((ref) {
  final repository = ref.read(userAlertRepositoryProvider);
  return UserAlertsNotifier(repository);
});

class UserAlertsNotifier extends StateNotifier<UserAlertsState> {
  final UserAlertRepository _repository;

  UserAlertsNotifier(this._repository) : super(UserAlertsState()) {
    loadAlerts();
  }

  Future<void> loadAlerts() async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      final alerts = await _repository.getAllAlerts();
      state = state.copyWith(
        isLoading: false,
        alerts: alerts,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> createAlert(UserAlertModel alert) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      await _repository.createAlert(alert);
      await loadAlerts();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> updateAlert(String alertId, UserAlertModel updatedAlert) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      await _repository.updateAlert(alertId, updatedAlert);
      await loadAlerts();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> deleteAlert(String alertId) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      await _repository.deleteAlert(alertId);
      await loadAlerts();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> toggleAlertEnabled(String alertId, bool isEnabled) async {
    try {
      await _repository.toggleAlertEnabled(alertId, isEnabled);
      await loadAlerts();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}
