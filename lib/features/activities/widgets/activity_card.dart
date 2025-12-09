import 'package:flutter/material.dart';
import '../../../core/theme/skye_theme.dart';
import '../models/activity_model.dart';
import '../utils/activity_status_evaluator.dart';
import '../widgets/add_activity_dialog.dart';

class ActivityCard extends StatelessWidget {
  final Activity activity;
  final double currentTemp;
  final double currentWind;
  final double currentVisibility;
  final double currentUV;
  final Function(Activity) onEdit;
  final Function(String) onDelete;

  const ActivityCard({
    Key? key,
    required this.activity,
    required this.currentTemp,
    required this.currentWind,
    required this.currentVisibility,
    required this.currentUV,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final status = ActivityStatusEvaluator.evaluateStatus(
      activity,
      currentTemp: currentTemp,
      currentWind: currentWind,
      currentVisibility: currentVisibility,
      currentUV: currentUV,
    );

    final statusLabel = ActivityStatusEvaluator.getStatusLabel(status);
    final statusIcon = ActivityStatusEvaluator.getStatusIcon(status);
    final conditionSummary = ActivityStatusEvaluator.buildConditionSummary(
      activity,
      currentTemp: currentTemp,
      currentWind: currentWind,
      currentVisibility: currentVisibility,
      currentUV: currentUV,
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: SkyeColors.surfaceMid,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: SkyeColors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Status badge + Name + Edit/Delete buttons
          Row(
            children: [
              // Status badge
              Text(statusIcon, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 10),

              // Activity name
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activity.name,
                      style: SkyeTypography.subtitle.copyWith(color: SkyeColors.textPrimary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      statusLabel,
                      style: SkyeTypography.caption.copyWith(
                        color: ActivityStatusEvaluator.getStatusColor(status),
                      ),
                    ),
                  ],
                ),
              ),

              // Edit button
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    builder: (context) => AddActivityDialog(
                      editingActivity: activity,
                      onSave: onEdit,
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: Icon(Icons.edit, size: 18, color: SkyeColors.textSecondary),
                ),
              ),

              // Delete button
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: SkyeColors.surfaceMid,
                      title: Text(
                        'Delete Activity?',
                        style: SkyeTypography.subtitle,
                      ),
                      content: Text(
                        'Are you sure you want to delete "${activity.name}"?',
                        style: SkyeTypography.body,
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            'Cancel',
                            style: SkyeTypography.label.copyWith(color: SkyeColors.textSecondary),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            onDelete(activity.id);
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Delete',
                            style: SkyeTypography.label.copyWith(color: SkyeColors.error),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: const Icon(Icons.delete, size: 18, color: SkyeColors.error),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Condition summary
          Text(
            conditionSummary,
            style: SkyeTypography.caption.copyWith(color: SkyeColors.textTertiary),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
