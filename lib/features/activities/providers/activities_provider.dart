import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/activity_model.dart';
import '../services/activity_service.dart';

final activityServiceProvider = Provider((ref) => ActivityService());

final activitiesProvider = StateNotifierProvider<ActivitiesNotifier, List<Activity>>((ref) {
  return ActivitiesNotifier(ref.watch(activityServiceProvider));
});

class ActivitiesNotifier extends StateNotifier<List<Activity>> {
  final ActivityService _service;

  ActivitiesNotifier(this._service) : super([]) {
    _loadActivities();
  }

  Future<void> _loadActivities() async {
    final activities = await _service.getActivities();
    state = activities;
  }

  Future<void> addActivity(Activity activity) async {
    await _service.addActivity(activity);
    await _loadActivities();
  }

  Future<void> updateActivity(Activity activity) async {
    await _service.updateActivity(activity);
    await _loadActivities();
  }

  Future<void> deleteActivity(String id) async {
    await _service.deleteActivity(id);
    await _loadActivities();
  }
}
