import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/theme/skye_colors.dart';
import '../../../core/theme/skye_typography.dart';
import '../../../core/widgets/glass_card.dart';

class PlantCareAlert extends StatelessWidget {
  final double temperature;
  final int humidity;

  const PlantCareAlert({
    super.key,
    required this.temperature,
    required this.humidity,
  });

  @override
  Widget build(BuildContext context) {
    final alertData = _getPlantAlert();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: FadeInUp(
        duration: const Duration(milliseconds: 600),
        delay: const Duration(milliseconds: 250),
        child: GlassCard(
          borderRadius: 24,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Title row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Plant Care',
                  style: SkyeTypography.bodySmall.copyWith(
                    color: SkyeColors.textSecondary,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    letterSpacing: 0.5,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: alertData['severityColor'].withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    alertData['severity'],
                    style: SkyeTypography.caption.copyWith(
                      color: alertData['severityColor'],
                      fontWeight: FontWeight.w600,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Alert content
            Row(
              children: [
                // Icon
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: alertData['severityColor'].withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    alertData['icon'],
                    color: alertData['severityColor'],
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                // Message
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        alertData['title'],
                        style: SkyeTypography.subtitle.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        alertData['message'],
                        style: SkyeTypography.bodySmall.copyWith(
                          color: SkyeColors.textSecondary,
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Additional tips
            if (alertData['tips'] != null) ...[
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: SkyeColors.glassLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: SkyeColors.glassBorder,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.tips_and_updates_rounded,
                      size: 16,
                      color: SkyeColors.sunYellow,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        alertData['tips'],
                        style: SkyeTypography.caption.copyWith(
                          color: SkyeColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
      ),
    );
  }

  Map<String, dynamic> _getPlantAlert() {
    // Frost Alert
    if (temperature < 5) {
      return {
        'severity': 'URGENT',
        'severityColor': SkyeColors.error,
        'icon': Icons.ac_unit_rounded,
        'title': 'Frost Alert',
        'message': 'Bring outdoor plants inside tonight to prevent frost damage',
        'tips': 'Cover sensitive plants if you can\'t move them',
      };
    }

    // Extreme Heat
    if (temperature > 35) {
      return {
        'severity': 'WARNING',
        'severityColor': const Color(0xFFF59E0B),
        'icon': Icons.wb_sunny_rounded,
        'title': 'Extreme Heat',
        'message': 'Move plants to shade and mist leaves frequently',
        'tips': 'Water in early morning or late evening',
      };
    }

    // Heat Wave
    if (temperature > 30) {
      return {
        'severity': 'CAUTION',
        'severityColor': const Color(0xFFF59E0B),
        'icon': Icons.local_fire_department_rounded,
        'title': 'Hot Weather',
        'message': 'Increase watering frequency, especially for container plants',
        'tips': 'Check soil moisture twice daily',
      };
    }

    // High Humidity - Good for tropicals
    if (humidity > 80) {
      return {
        'severity': 'INFO',
        'severityColor': SkyeColors.skyBlue,
        'icon': Icons.water_drop_rounded,
        'title': 'High Humidity',
        'message': 'Perfect for tropical plants! Watch succulents for mold',
        'tips': 'Ensure good air circulation around plants',
      };
    }

    // Dry Air
    if (humidity < 30) {
      return {
        'severity': 'NOTICE',
        'severityColor': const Color(0xFFF59E0B),
        'icon': Icons.air_rounded,
        'title': 'Low Humidity',
        'message': 'Mist tropical plants or use a humidifier',
        'tips': 'Group plants together to create a micro-climate',
      };
    }

    // Moderate humidity - good for most plants
    if (humidity >= 50 && humidity <= 70) {
      return {
        'severity': 'IDEAL',
        'severityColor': SkyeColors.success,
        'icon': Icons.eco_rounded,
        'title': 'Perfect Conditions',
        'message': 'Ideal humidity for most houseplants',
        'tips': 'Great day for repotting or propagating',
      };
    }

    // Perfect temperature range
    if (temperature >= 18 && temperature <= 24) {
      return {
        'severity': 'GOOD',
        'severityColor': SkyeColors.success,
        'icon': Icons.spa_rounded,
        'title': 'Great Plant Weather',
        'message': 'Optimal temperature for plant growth',
        'tips': 'Perfect day for fertilizing or pruning',
      };
    }

    // Cold but not freezing
    if (temperature < 15) {
      return {
        'severity': 'NOTICE',
        'severityColor': SkyeColors.skyBlue,
        'icon': Icons.thermostat_rounded,
        'title': 'Cool Temperature',
        'message': 'Reduce watering frequency for most plants',
        'tips': 'Keep plants away from cold windows',
      };
    }

    // Default - moderate conditions
    return {
      'severity': 'GOOD',
      'severityColor': SkyeColors.success,
      'icon': Icons.yard_rounded,
      'title': 'Good Plant Day',
      'message': 'Conditions are favorable for your plants',
      'tips': 'Regular care routine is sufficient',
    };
  }
}
