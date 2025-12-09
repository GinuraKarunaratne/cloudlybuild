import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import '../../../core/theme/skye_theme.dart';

class WeatherQualitySection extends StatelessWidget {
  final int weatherQualityScore; // 0 - 100
  final String qualityLabel;
  final String qualityDescription;

  const WeatherQualitySection({
    Key? key,
    required this.weatherQualityScore,
    required this.qualityLabel,
    required this.qualityDescription,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final score = weatherQualityScore.clamp(0, 100);

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
              // Gauge
              WeatherQualityGauge(
                progress: score / 100.0,
                size: 170,
              ),

              const SizedBox(width: 16),

              // Description column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(qualityLabel, style: SkyeTypography.title.copyWith(color: SkyeColors.textPrimary)),
                    const SizedBox(height: 8),
                    Text(
                      qualityDescription,
                      style: SkyeTypography.body.copyWith(color: SkyeColors.textSecondary),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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
