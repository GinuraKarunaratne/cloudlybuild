import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/skye_theme.dart';
import '../../../data/models/weather_model.dart';
import '../../../data/models/uv_data_model.dart';

import '../providers/activities_provider.dart';
import '../widgets/activity_card.dart';
import '../widgets/add_activity_dialog.dart';

class ActivitiesListScreen extends ConsumerWidget {
  final WeatherModel? weather;
  final UVDataModel? uvData;

  const ActivitiesListScreen({
    Key? key,
    this.weather,
    this.uvData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activities = ref.watch(activitiesProvider);

    if (weather == null) {
      return Scaffold(
        backgroundColor: SkyeColors.deepSpace,
        appBar: AppBar(
          backgroundColor: SkyeColors.surfaceDark,
          elevation: 0,
          title: Text('My Activities', style: SkyeTypography.title),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: SkyeColors.textPrimary),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(
          child: Text(
            'Weather data not available',
            style: TextStyle(
              fontSize: SkyeTypography.body.fontSize,
              fontWeight: SkyeTypography.body.fontWeight,
              color: SkyeColors.textMuted,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: SkyeColors.deepSpace,
      appBar: AppBar(
        backgroundColor: SkyeColors.surfaceDark,
        elevation: 0,
        title: Text('My Activities', style: SkyeTypography.title),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: SkyeColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: activities.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.calendar_today, size: 64, color: SkyeColors.textMuted),
                  const SizedBox(height: 16),
                  Text(
                    'No activities yet',
                    style: TextStyle(
                      fontSize: SkyeTypography.title.fontSize,
                      fontWeight: SkyeTypography.title.fontWeight,
                      color: SkyeColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add your first activity to get started',
                    style: TextStyle(
                      fontSize: SkyeTypography.body.fontSize,
                      fontWeight: SkyeTypography.body.fontWeight,
                      color: SkyeColors.textMuted,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: activities.length,
              itemBuilder: (context, index) {
                final activity = activities[index];
                return ActivityCard(
                  activity: activity,
                  currentTemp: weather!.feelsLike,
                  currentWind: weather!.windSpeed,
                  currentVisibility: weather!.visibility / 1000.0, // Convert to km
                  currentUV: uvData?.uvIndex ?? 0.0,
                  onEdit: (updatedActivity) {
                    ref.read(activitiesProvider.notifier).updateActivity(updatedActivity);
                  },
                  onDelete: (id) {
                    ref.read(activitiesProvider.notifier).deleteActivity(id);
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: SkyeColors.textSecondary,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            builder: (context) => AddActivityDialog(
              onSave: (activity) {
                ref.read(activitiesProvider.notifier).addActivity(activity);
              },
            ),
          );
        },
        child: const Icon(Icons.add, color: SkyeColors.deepSpace),
      ),
    );
  }
}
