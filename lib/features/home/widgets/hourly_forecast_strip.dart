import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/theme/skye_theme.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/hourly_temp_trend_painter.dart';
import '../../../data/models/forecast_model.dart';

/// Premium Apple-style hourly forecast strip with 4-row layout
class HourlyForecastStrip extends StatelessWidget {
  final List<HourlyForecast> hours;

  const HourlyForecastStrip({
    super.key,
    required this.hours,
  });

  @override
  Widget build(BuildContext context) {
    // Show max 6-7 hours to avoid cramping
    final visibleHours = hours.take(7).toList();

    if (visibleHours.isEmpty) {
      return const SizedBox.shrink();
    }

    return FadeInUp(
      duration: const Duration(milliseconds: 600),
      delay: const Duration(milliseconds: 200),
      child: GlassCard(
        borderRadius: 24,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Optional title row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Hourly Forecast',
                  style: SkyeTypography.bodySmall.copyWith(
                    color: SkyeColors.textSecondary,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Main 4-row grid content
            _HourlyForecastGrid(hours: visibleHours),
          ],
        ),
      ),
    );
  }
}

/// Internal grid layout with 4 rows: time, icon+temp, trend line, precipitation
class _HourlyForecastGrid extends StatelessWidget {
  final List<HourlyForecast> hours;

  const _HourlyForecastGrid({required this.hours});

  String _formatTime(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    final now = DateTime.now();

    // Show "Now" for current hour
    if (date.hour == now.hour && date.day == now.day) {
      return 'Now';
    }

    // Format as HH:00 (24-hour format)
    return '${date.hour.toString().padLeft(2, '0')}:00';
  }

  IconData _mapConditionToIcon(String condition, String icon) {
    final isNight = icon.endsWith('n');

    switch (condition.toLowerCase()) {
      case 'clear':
        return isNight ? Icons.nightlight_round : Icons.wb_sunny_rounded;
      case 'clouds':
        return isNight ? Icons.cloud_rounded : Icons.wb_cloudy_rounded;
      case 'rain':
      case 'drizzle':
        return Icons.water_drop_rounded;
      case 'snow':
        return Icons.ac_unit_rounded;
      case 'thunderstorm':
        return Icons.thunderstorm_rounded;
      case 'mist':
      case 'fog':
      case 'haze':
        return Icons.blur_on_rounded;
      default:
        return Icons.wb_sunny_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final temps = hours.map((h) => h.temperature).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Row 1: Time labels
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (final h in hours)
              Expanded(
                child: Center(
                  child: Text(
                    _formatTime(h.dt),
                    style: SkyeTypography.caption.copyWith(
                      color: SkyeColors.textSecondary.withOpacity(0.8),
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.3,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
          ],
        ),

        const SizedBox(height: 12),

        // Row 2: Icons + Temperatures
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (final h in hours)
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _mapConditionToIcon(h.condition, h.icon),
                      size: 24,
                      color: SkyeColors.textPrimary.withOpacity(0.9),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${h.temperature.round()}°',
                      style: SkyeTypography.bodySmall.copyWith(
                        color: SkyeColors.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
          ],
        ),

        const SizedBox(height: 16),

        // Row 3: Temperature trend line with dots
        SizedBox(
          height: 45,
          child: CustomPaint(
            painter: HourlyTempTrendPainter(
              temperatures: temps,
              lineColor: SkyeColors.skyBlue.withOpacity(0.8),
              dotColor: Colors.white,
              gradientStartColor: SkyeColors.skyBlue,
              gradientEndColor: SkyeColors.twilightPurple,
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Row 4: Precipitation percentages
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (final h in hours)
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.water_drop,
                      size: 12,
                      color: SkyeColors.skyBlue.withOpacity(0.7),
                    ),
                    const SizedBox(width: 3),
                    Text(
                      '${(h.pop * 100).round()}%',
                      style: SkyeTypography.caption.copyWith(
                        color: SkyeColors.textSecondary.withOpacity(0.75),
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.3,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }
}

