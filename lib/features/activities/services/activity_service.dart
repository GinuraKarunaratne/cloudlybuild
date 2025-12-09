import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/activity_model.dart';

class ActivityService {
  static const String _storageKey = 'activities';

  Future<List<Activity>> getActivities() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_storageKey);

    if (json == null) return [];

    try {
      final List<dynamic> decoded = jsonDecode(json);
      return decoded.map((item) => Activity.fromJson(item as Map<String, dynamic>)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> addActivity(Activity activity) async {
    final prefs = await SharedPreferences.getInstance();
    final activities = await getActivities();
    activities.add(activity);
    await _saveActivities(activities, prefs);
  }

  Future<void> updateActivity(Activity activity) async {
    final prefs = await SharedPreferences.getInstance();
    final activities = await getActivities();
    final index = activities.indexWhere((a) => a.id == activity.id);
    if (index >= 0) {
      activities[index] = activity;
      await _saveActivities(activities, prefs);
    }
  }

  Future<void> deleteActivity(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final activities = await getActivities();
    activities.removeWhere((a) => a.id == id);
    await _saveActivities(activities, prefs);
  }

  Future<void> _saveActivities(List<Activity> activities, SharedPreferences prefs) async {
    final json = jsonEncode(activities.map((a) => a.toJson()).toList());
    await prefs.setString(_storageKey, json);
  }
}
