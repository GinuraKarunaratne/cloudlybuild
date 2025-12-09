import 'package:flutter/material.dart';
import '../../../data/models/user_alert_model.dart';
import '../../../core/theme/skye_theme.dart';
import '../../../core/widgets/glass_card.dart';

class UserAlertCard extends StatelessWidget {
  final UserAlertModel alert;
  final Function(bool) onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const UserAlertCard({
    super.key,
    required this.alert,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  IconData _getConditionIcon() {
    switch (alert.conditionType) {
      case AlertConditionType.temperature:
      case AlertConditionType.feelsLike:
        return Icons.thermostat_rounded;
      case AlertConditionType.humidity:
        return Icons.water_drop_rounded;
      case AlertConditionType.windSpeed:
        return Icons.air_rounded;
      case AlertConditionType.precipitation:
        return Icons.umbrella_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      borderRadius: 24,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      alert.name,
                      style: SkyeTypography.title.copyWith(
                        color: SkyeColors.textPrimary,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          _getConditionIcon(),
                          size: 16,
                          color: SkyeColors.textSecondary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          alert.conditionDescription,
                          style: SkyeTypography.body.copyWith(
                            color: SkyeColors.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Switch(
                value: alert.isEnabled,
                onChanged: onToggle,
                activeTrackColor: SkyeColors.skyBlue,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Flexible(
                child: Row(
                  children: [
                    _buildInfoChip(
                      icon: Icons.access_time_rounded,
                      label: _formatDate(alert.createdAt),
                    ),
                    if (alert.lastTriggered != null) ...[
                      const SizedBox(width: 6),
                      Flexible(
                        child: _buildInfoChip(
                          icon: Icons.check_circle_rounded,
                          label: 'Last: ${_formatDate(alert.lastTriggered!)}',
                          color: SkyeColors.skyBlue,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: Icon(
                  Icons.edit_rounded,
                  size: 20,
                  color: SkyeColors.textSecondary,
                ),
                onPressed: onEdit,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: Icon(
                  Icons.delete_outline_rounded,
                  size: 20,
                  color: SkyeColors.error,
                ),
                onPressed: onDelete,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    Color? color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: (color ?? SkyeColors.textSecondary).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: color ?? SkyeColors.textSecondary,
          ),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                color: color ?? SkyeColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes}m ago';
      }
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
