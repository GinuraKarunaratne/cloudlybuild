import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/theme/skye_theme.dart';
import '../../../core/widgets/animated_wind_card.dart';
import '../../../core/widgets/animated_humidity_card.dart';
import '../../../core/widgets/animated_pressure_card.dart';
import '../../../core/widgets/animated_visibility_card.dart';
import '../../../core/utils/skye_weather_utils.dart';
import '../../../core/utils/date_utils.dart';
import '../../../core/utils/weather_formatters.dart';
import '../../../data/models/weather_model.dart';
import '../../settings/viewmodels/settings_viewmodel.dart';
import '../../settings/viewmodels/settings_state.dart';

class SkyeMetricsSection extends ConsumerWidget {
  final WeatherModel weather;

  const SkyeMetricsSection({
    super.key,
    required this.weather,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sunrise & Sunset
          FadeInUp(
            duration: const Duration(milliseconds: 600),
            delay: const Duration(milliseconds: 100),
            child: Row(
              children: [
                Expanded(
                  child: _buildSunCard(
                    icon: Icons.wb_sunny_rounded,
                    label: 'Sunrise',
                    time: AppDateUtils.getTimeFromTimestamp(
                      weather.sunrise,
                      use24Hour: settings.timeFormat == TimeFormat.twentyFourHour,
                    ),
                    color: SkyeColors.sunYellow,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildSunCard(
                    icon: Icons.nightlight_round,
                    label: 'Sunset',
                    time: AppDateUtils.getTimeFromTimestamp(
                      weather.sunset,
                      use24Hour: settings.timeFormat == TimeFormat.twentyFourHour,
                    ),
                    color: SkyeColors.twilightPurple,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Section title
          FadeInUp(
            duration: const Duration(milliseconds: 600),
            delay: const Duration(milliseconds: 200),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                'Weather Details',
                style: SkyeTypography.title,
              ),
            ),
          ),

          // Metrics - Animated infographic style
          Column(
            children: [
              // Large Wind Card
              FadeInUp(
                duration: const Duration(milliseconds: 600),
                delay: const Duration(milliseconds: 300),
                child: AnimatedWindCard(
                  value: weather.windSpeed.formatWindSpeed(settings),
                  windSpeed: weather.windSpeed,
                  accentColor: SkyeColors.skyBlue,
                ),
              ),
              const SizedBox(height: 16),

              // Large Humidity Card
              FadeInUp(
                duration: const Duration(milliseconds: 600),
                delay: const Duration(milliseconds: 400),
                child: AnimatedHumidityCard(
                  value: SkyeWeatherUtils.formatHumidity(weather.humidity),
                  humidity: weather.humidity.toDouble(),
                  accentColor: SkyeColors.skyBlue,
                ),
              ),
              const SizedBox(height: 16),

              // Small cards row (Pressure & Visibility)
              FadeInUp(
                duration: const Duration(milliseconds: 600),
                delay: const Duration(milliseconds: 500),
                child: Row(
                  children: [
                    Expanded(
                      child: AnimatedPressureCard(
                        value: SkyeWeatherUtils.formatPressure(weather.pressure),
                        pressure: weather.pressure.toDouble(),
                        accentColor: SkyeColors.twilightPurple,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: AnimatedVisibilityCard(
                        value: SkyeWeatherUtils.formatVisibility(weather.visibility),
                        visibility: weather.visibility / 1000, // Convert to km
                        accentColor: SkyeColors.twilightPurple,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSunCard({
    required IconData icon,
    required String label,
    required String time,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: SkyeColors.glassLight,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            time,
            style: SkyeTypography.temperature,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: SkyeTypography.metricLabel,
          ),
        ],
      ),
    );
  }
}

