import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/theme/cloudly_theme.dart';
import '../../../core/utils/cloudly_weather_utils.dart';
import '../../../core/utils/date_utils.dart';
import '../../../core/utils/weather_formatters.dart';
import '../../../core/widgets/weather_animation.dart';
import '../../../data/models/weather_model.dart';
import '../../settings/viewmodels/settings_viewmodel.dart';

class SkyeHeroSection extends ConsumerWidget {
  final WeatherModel weather;
  final VoidCallback? onForecastTap;

  const SkyeHeroSection({
    super.key,
    required this.weather,
    this.onForecastTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final settings = ref.watch(settingsProvider);
    final gradient = SkyeWeatherUtils.getWeatherGradient(
      weather.getWeatherCondition(),
    );

    return Container(
      width: size.width,
      height: size.height * 1,
      decoration: BoxDecoration(
        gradient: gradient,
      ),
      child: Stack(
        children: [
          // Main content
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 120, 24, 16),
              child: Column(
                children: [
                  // Location & Date
                  FadeInDown(
                    duration: const Duration(milliseconds: 600),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.location_on_rounded,
                              color: SkyeColors.textPrimary.withAlphaFromOpacity(0.9),
                              size: 20,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              weather.cityName,
                              style: SkyeTypography.headline,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          AppDateUtils.formatDayMonth(DateTime.now()),
                          style: SkyeTypography.body.copyWith(
                            color: SkyeColors.textSecondary.withAlphaFromOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 50),

                  // Weather Animation
                  FadeIn(
                    duration: const Duration(milliseconds: 800),
                    delay: const Duration(milliseconds: 200),
                    child: WeatherAnimation(
                      condition: weather.getWeatherCondition(),
                      size: 120,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Temperature
                  FadeInUp(
                    duration: const Duration(milliseconds: 600),
                    delay: const Duration(milliseconds: 300),
                    child: TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 1400),
                      tween: Tween(begin: 0, end: weather.temperature),
                      curve: Curves.easeOutCubic,
                      builder: (context, value, child) {
                        return Text(
                          value.formatTemperature(settings),
                          style: SkyeTypography.display,
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Condition
                  FadeInUp(
                    duration: const Duration(milliseconds: 600),
                    delay: const Duration(milliseconds: 400),
                    child: Text(
                      SkyeWeatherUtils.getConditionText(weather.description),
                      style: SkyeTypography.condition.copyWith(
                        letterSpacing: 2,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const Spacer(),

                  // Quick stats row
                  FadeInUp(
                    duration: const Duration(milliseconds: 600),
                    delay: const Duration(milliseconds: 500),
                    child: _buildQuickStats(settings),
                  ),

                  const SizedBox(height: 16),

                  // Forecast hint
                  if (onForecastTap != null)
                    FadeInUp(
                      duration: const Duration(milliseconds: 600),
                      delay: const Duration(milliseconds: 600),
                      child: _buildForecastButton(),
                    ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(settings) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withAlphaFromOpacity(0.15),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildQuickStat(
            'Feels Like',
            weather.feelsLike.formatTemperature(settings),
          ),
          _buildDivider(),
          _buildQuickStat(
            'Humidity',
            SkyeWeatherUtils.formatHumidity(weather.humidity),
          ),
          _buildDivider(),
          _buildQuickStat(
            'Wind Speed',
            weather.windSpeed.formatWindSpeed(settings),
          ),
        ],
      ),
    );
  }

  Widget _buildForecastButton() {
    return GestureDetector(
      onTap: onForecastTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 14,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withAlphaFromOpacity(0.15),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '7-Day Forecast',
              style: SkyeTypography.label.copyWith(
                color: SkyeColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.keyboard_arrow_up_rounded,
              color: SkyeColors.textPrimary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: SkyeTypography.subtitle.copyWith(
            color: SkyeColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: SkyeTypography.caption.copyWith(
            color: SkyeColors.textSecondary.withAlphaFromOpacity(0.85),
            letterSpacing: 0.8,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 32,
      color: Colors.white.withAlphaFromOpacity(0.25),
    );
  }

}

