import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import '../../../core/theme/skye_theme.dart';
import '../../../data/models/weather_model.dart';
import '../../../data/models/forecast_model.dart';
import '../../../data/models/uv_data_model.dart';

class WeatherQualitySection extends StatefulWidget {
  final WeatherModel? weather;
  final ForecastModel? forecast;
  final UVDataModel? uvData;

  const WeatherQualitySection({
    Key? key,
    this.weather,
    this.forecast,
    this.uvData,
  }) : super(key: key);

  @override
  State<WeatherQualitySection> createState() => _WeatherQualitySectionState();
}

class _WeatherQualitySectionState extends State<WeatherQualitySection> with TickerProviderStateMixin {
  late AnimationController _scoreAnimationController;
  late Animation<double> _scoreAnimation;

  @override
  void initState() {
    super.initState();
    _scoreAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    final score = _computeScore();
    _scoreAnimation = Tween<double>(begin: 0, end: score / 100.0).animate(
      CurvedAnimation(parent: _scoreAnimationController, curve: Curves.easeOut),
    );

    // Start animation after widget builds
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scoreAnimationController.forward();
    });
  }

  @override
  void dispose() {
    _scoreAnimationController.dispose();
    super.dispose();
  }

  // Compute a score (0-100) based on several factors:
  // - Temperature comfort (ideal between 18-25 C)
  // - Humidity (ideal 30-60%)
  // - Wind (lower is better)
  // - Precipitation probability (lower is better)
  // - UV index (lower is better for outdoor comfort/safety)
  int _computeScore() {
    if (widget.weather == null) return 0;

    double score = 0.0;

    // Temperature comfort: optimal at 21°C, falloff +/-10°C
    final temp = widget.weather!.feelsLike;
    final tempDiff = (temp - 21.0).abs();
    final tempScore = (1.0 - (tempDiff / 10.0)).clamp(0.0, 1.0) * 30.0;
    score += tempScore;

    // Humidity: optimal 30-60
    final humidity = widget.weather!.humidity.toDouble();
    double humidityScore;
    if (humidity < 30) {
      humidityScore = (humidity / 30.0) * 10.0; // lower is worse below 30
    } else if (humidity <= 60) {
      humidityScore = 10.0; // perfect
    } else {
      humidityScore = (1.0 - ((humidity - 60.0) / 40.0)).clamp(0.0, 1.0) * 10.0;
    }
    score += humidityScore;

    // Wind: ideal < 5 m/s
    final wind = widget.weather!.windSpeed;
    final windScore = (1.0 - (wind / 15.0)).clamp(0.0, 1.0) * 15.0;
    score += windScore;

    // Precipitation: use today's pop if present, else use forecast average
    double pop = 0.0;
    if (widget.forecast != null && widget.forecast!.dailyForecasts.isNotEmpty) {
      pop = widget.forecast!.dailyForecasts.first.pop; // today's pop
    }
    final popScore = (1.0 - pop).clamp(0.0, 1.0) * 20.0;
    score += popScore;

    // UV safety: penalize high UV (if available)
    double uvPenalty = 0.0;
    if (widget.uvData != null) {
      final u = widget.uvData!.uvIndex;
      uvPenalty = (1.0 - (u / 11.0)).clamp(0.0, 1.0) * 25.0;
    } else {
      // If no UV data, give a neutral mid contribution
      uvPenalty = 12.5;
    }
    score += uvPenalty;

    // Normalize scale: max possible is about 30+10+15+20+25 = 100
    final int finalScore = score.round().clamp(0, 100);
    return finalScore;
  }

  String _labelForScore(int score) {
    if (score >= 85) return 'Excellent';
    if (score >= 70) return 'Great';
    if (score >= 50) return 'Good';
    if (score >= 30) return 'Fair';
    return 'Poor';
  }

  String _descriptionForScore(int score) {
    if (score >= 85) return 'Ideal conditions for outdoor activities.';
    if (score >= 70) return 'Comfortable conditions with minor caveats.';
    if (score >= 50) return 'Acceptable but check specific metrics (wind/UV).';
    if (score >= 30) return 'Conditions may be uncomfortable; consider indoors.';
    return 'Poor weather quality — avoid extended outdoor exposure.';
  }

  @override
  Widget build(BuildContext context) {
    final score = _computeScore();
    final label = _labelForScore(score);
    final description = _descriptionForScore(score);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: SkyeColors.surfaceMid,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: SkyeColors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Weather Quality', style: SkyeTypography.subtitle),
              Text('Today', style: SkyeTypography.caption.copyWith(color: SkyeColors.textMuted)),
            ],
          ),
          const SizedBox(height: 12),

          // Main content
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Gauge with animated progress
              AnimatedBuilder(
                animation: _scoreAnimation,
                builder: (context, child) {
                  return WeatherQualityGauge(
                    progress: _scoreAnimation.value,
                    size: 170,
                  );
                },
              ),

              const SizedBox(width: 16),

              // Description column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: SkyeTypography.title.copyWith(color: SkyeColors.textPrimary)),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: SkyeTypography.body.copyWith(color: SkyeColors.textSecondary),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),

                    // Small metrics summary displayed horizontally; allow horizontal scroll on overflow
                    if (widget.weather != null) ...[
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 40,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          child: Row(
                            children: [
                              _metricChip('Temp', '${widget.weather!.temperature.round()}°'),
                              const SizedBox(width: 12),
                              _metricChip('Humidity', '${widget.weather!.humidity}%'),
                              const SizedBox(width: 12),
                              _metricChip('Wind', '${widget.weather!.windSpeed.toStringAsFixed(1)} m/s'),
                              if (widget.uvData != null) ...[
                                const SizedBox(width: 12),
                                _metricChip('UV', widget.uvData!.uvIndex.toStringAsFixed(1)),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _metricChip(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: SkyeColors.behindContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: SkyeTypography.label.copyWith(color: SkyeColors.textTertiary)),
          const SizedBox(width: 8),
          Text(value, style: SkyeTypography.subtitle.copyWith(color: SkyeColors.textPrimary)),
        ],
      ),
    );
  }
}

class WeatherQualityGauge extends StatelessWidget {
  final double progress; // 0.0 - 1.0
  final double size;

  const WeatherQualityGauge({
    Key? key,
    required this.progress,
    this.size = 170,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = size / 2;

    return SizedBox(
      width: size,
      height: height + 24, // allow space for centered score
      child: LayoutBuilder(
        builder: (context, constraints) {
          final paintSize = Size(constraints.maxWidth, height);
          return Stack(
            alignment: Alignment.center,
            children: [
              // Arc
              CustomPaint(
                size: paintSize,
                painter: WeatherQualityGaugePainter(progress: progress),
              ),

              // Score text positioned at bottom center of the semicircle
              Positioned(
                bottom: 6,
                child: Column(
                  children: [
                    Text(
                      '${(progress * 100).round()}',
                      style: SkyeTypography.metricValue.copyWith(fontSize: 32, color: SkyeColors.textPrimary),
                    ),
                    Text('%', style: SkyeTypography.caption.copyWith(color: SkyeColors.textSecondary)),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class WeatherQualityGaugePainter extends CustomPainter {
  final double progress; // 0.0 - 1.0
  final double strokeWidth;

  WeatherQualityGaugePainter({required this.progress, this.strokeWidth = 12});

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;
    final center = Offset(width / 2, height);
    final radius = math.min(width / 2, height) - strokeWidth / 2;

    final rect = Rect.fromCircle(center: center, radius: radius);

    // Background track paint
    final trackPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..color = SkyeColors.textMuted.withAlphaFromOpacity(0.25);

    // Draw background semicircle (from pi to 0)
    canvas.drawArc(rect, math.pi, math.pi, false, trackPaint);

    // Progress paint with monotone gradient
    final gradient = ui.Gradient.linear(
      rect.topLeft,
      rect.bottomRight,
      [SkyeColors.textSecondary.withAlphaFromOpacity(0.35), SkyeColors.textPrimary.withAlphaFromOpacity(0.9)],
    );

    final progressPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..shader = gradient
      ..isAntiAlias = true;

    final sweep = math.pi * (progress.clamp(0.0, 1.0));

    canvas.drawArc(rect, math.pi, sweep, false, progressPaint);
  }

  @override
  bool shouldRepaint(covariant WeatherQualityGaugePainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.strokeWidth != strokeWidth;
  }
}
