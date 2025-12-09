import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../theme/skye_theme.dart';
import 'glass_card.dart';

/// Large animated wind speed card with flowing wave lines
class AnimatedWindCard extends StatefulWidget {
  final String value;
  final double windSpeed; // m/s
  final Color? accentColor;

  const AnimatedWindCard({
    super.key,
    required this.value,
    required this.windSpeed,
    this.accentColor,
  });

  @override
  State<AnimatedWindCard> createState() => _AnimatedWindCardState();
}

class _AnimatedWindCardState extends State<AnimatedWindCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.accentColor ?? SkyeColors.skyBlue;

    return GlassCard(
      padding: const EdgeInsets.all(24),
      borderRadius: 28,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Icon container
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withAlphaFromOpacity(0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.air_rounded,
                  color: color,
                  size: 28,
                ),
              ),
              const Spacer(),
              // Value
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    widget.value,
                    style: SkyeTypography.metricValue.copyWith(
                      fontSize: 32,
                      color: SkyeColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Wind Speed',
                    style: SkyeTypography.metricLabel.copyWith(
                      fontSize: 13,
                      color: SkyeColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Animated flowing wind visualization
          SizedBox(
            height: 100,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return CustomPaint(
                  painter: _FlowingWindPainter(
                    color: color,
                    animationValue: _controller.value,
                    windSpeed: widget.windSpeed,
                  ),
                  size: Size.infinite,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FlowingWindPainter extends CustomPainter {
  final Color color;
  final double animationValue;
  final double windSpeed;

  _FlowingWindPainter({
    required this.color,
    required this.animationValue,
    required this.windSpeed,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Normalize wind speed for visual intensity (0-20 m/s range)
    final intensity = (windSpeed / 20).clamp(0.0, 1.0);

    // Draw multiple flowing wave lines
    for (int lineIndex = 0; lineIndex < 5; lineIndex++) {
      final yPosition = size.height * (0.2 + lineIndex * 0.15);
      final opacity = 0.15 + (intensity * 0.3);

      // Create paint with gradient
      final paint = Paint()
        ..shader = LinearGradient(
          colors: [
            color.withAlphaFromOpacity(0.0),
            color.withAlphaFromOpacity(opacity),
            color.withAlphaFromOpacity(opacity * 0.5),
            color.withAlphaFromOpacity(0.0),
          ],
          stops: const [0.0, 0.3, 0.7, 1.0],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
        ..strokeWidth = 2.5 + (intensity * 1.5)
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;

      final path = Path();

      // Starting point with offset based on animation
      final animOffset = animationValue * size.width;

      for (double x = -size.width; x <= size.width * 2; x += 4) {
        final adjustedX = x - animOffset;

        // Create flowing wave effect
        final frequency = 0.015 + (lineIndex * 0.002);
        final amplitude = 8 + (intensity * 12);
        final phase = lineIndex * 0.5;

        final wave = math.sin(adjustedX * frequency + phase) * amplitude;
        final currentY = yPosition + wave;

        if (x == -size.width) {
          path.moveTo(x, currentY);
        } else {
          path.lineTo(x, currentY);
        }
      }

      canvas.drawPath(path, paint);

      // Draw flowing particles/arrows along the lines
      if (lineIndex % 2 == 0) {
        _drawFlowingArrows(canvas, size, yPosition, lineIndex, animOffset, color, intensity);
      }
    }
  }

  void _drawFlowingArrows(
    Canvas canvas,
    Size size,
    double yPosition,
    int lineIndex,
    double animOffset,
    Color color,
    double intensity,
  ) {
    final arrowPaint = Paint()
      ..color = color.withAlphaFromOpacity(0.4 + intensity * 0.3)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Draw arrows at intervals
    for (double x = 0; x < size.width; x += size.width / 3) {
      final adjustedX = (x + animOffset) % size.width;
      final arrowSize = 10.0;

      // Arrow pointing right
      final arrowPath = Path();
      arrowPath.moveTo(adjustedX - arrowSize, yPosition - arrowSize / 2);
      arrowPath.lineTo(adjustedX, yPosition);
      arrowPath.lineTo(adjustedX - arrowSize, yPosition + arrowSize / 2);

      canvas.drawPath(arrowPath, arrowPaint);
    }
  }

  @override
  bool shouldRepaint(_FlowingWindPainter oldDelegate) =>
      animationValue != oldDelegate.animationValue ||
      windSpeed != oldDelegate.windSpeed;
}

