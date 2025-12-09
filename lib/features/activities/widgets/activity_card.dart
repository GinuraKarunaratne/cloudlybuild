import 'package:flutter/material.dart';
import '../../../core/theme/skye_theme.dart';
import '../models/activity_model.dart';
import '../utils/activity_status_evaluator.dart';
import '../widgets/add_activity_dialog.dart';

class ActivityCard extends StatefulWidget {
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
  State<ActivityCard> createState() => _ActivityCardState();
}

class _ActivityCardState extends State<ActivityCard> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final status = ActivityStatusEvaluator.evaluateStatus(
      widget.activity,
      currentTemp: widget.currentTemp,
      currentWind: widget.currentWind,
      currentVisibility: widget.currentVisibility,
      currentUV: widget.currentUV,
    );

    final statusLabel = ActivityStatusEvaluator.getStatusLabel(status);
    final statusIcon = ActivityStatusEvaluator.getStatusIcon(status);
    final conditionSummary = ActivityStatusEvaluator.buildConditionSummary(
      widget.activity,
      currentTemp: widget.currentTemp,
      currentWind: widget.currentWind,
      currentVisibility: widget.currentVisibility,
      currentUV: widget.currentUV,
    );

    // create a small match percentage based on conditions met
    bool tempOk = widget.currentTemp >= widget.activity.minTemp && widget.currentTemp <= widget.activity.maxTemp;
    bool windOk = widget.currentWind <= widget.activity.maxWind;
    bool visibilityOk = widget.currentVisibility >= widget.activity.minVisibility;
    bool uvOk = widget.currentUV <= widget.activity.maxUV;

    int met = 0;
    if (tempOk) met++;
    if (windOk) met++;
    if (visibilityOk) met++;
    if (uvOk) met++;

    final double matchPercent = met / 4.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: SkyeColors.surfaceMid,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: SkyeColors.glassBorder),
      ),
      child: Row(
        children: [
          // Left accent + badge with pulse animation
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: child,
              );
            },
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: ActivityStatusEvaluator.getStatusColor(status).withAlpha(30),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Text(statusIcon, style: const TextStyle(fontSize: 26)),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Main content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.activity.name,
                        style: SkyeTypography.subtitle.copyWith(color: SkyeColors.textPrimary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(statusLabel, style: SkyeTypography.caption.copyWith(color: ActivityStatusEvaluator.getStatusColor(status))),
                  ],
                ),
                const SizedBox(height: 8),
                Text(conditionSummary, style: SkyeTypography.caption.copyWith(color: SkyeColors.textTertiary), maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 8),
                // small progress bar showing how many conditions met
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: matchPercent,
                    minHeight: 8,
                    backgroundColor: SkyeColors.behindContainer,
                    valueColor: AlwaysStoppedAnimation(ActivityStatusEvaluator.getStatusColor(status)),
                  ),
                ),
              ],
            ),
          ),

          // Buttons
          const SizedBox(width: 12),
          Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddActivityDialog(
                        editingActivity: widget.activity,
                        onSave: (updated) {
                          widget.onEdit(updated);
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: Icon(Icons.edit, size: 18, color: SkyeColors.textSecondary),
                ),
              ),
              const SizedBox(height: 6),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: SkyeColors.surfaceMid,
                      title: Text('Delete Activity?', style: SkyeTypography.subtitle),
                      content: Text('Are you sure you want to delete "${widget.activity.name}"?', style: SkyeTypography.body),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel', style: SkyeTypography.label.copyWith(color: SkyeColors.textSecondary))),
                        TextButton(onPressed: () { widget.onDelete(widget.activity.id); Navigator.pop(context); }, child: Text('Delete', style: SkyeTypography.label.copyWith(color: SkyeColors.error))),
                      ],
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: Icon(Icons.delete, size: 18, color: SkyeColors.error),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
