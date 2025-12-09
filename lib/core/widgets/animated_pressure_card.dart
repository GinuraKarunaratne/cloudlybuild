import 'package:flutter/material.dart';
import '../theme/skye_theme.dart';
import 'dart:math' as math;
import 'glass_card.dart';

/// Compact animated pressure card with rising gauge meter
class AnimatedPressureCard extends StatefulWidget {
  final String value;
  final double pressure; // hPa
  final Color? accentColor;

  const AnimatedPressureCard({
    super.key,
    required this.value,
    required this.pressure,
    this.accentColor,
  });

  @override
  State<AnimatedPressureCard> createState() => _AnimatedPressureCardState();
}

class _AnimatedPressureCardState extends State<AnimatedPressureCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.accentColor ?? SkyeColors.twilightPurple;

    return GlassCard(
      padding: const EdgeInsets.fromLTRB(22, 22, 22, 28),
      borderRadius: 24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Value and label
          Text(
            widget.value,
            style: SkyeTypography.metricValue.copyWith(
              fontSize: 22,
              color: SkyeColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Pressure',
            style: SkyeTypography.metricLabel.copyWith(
              fontSize: 12,
              color: SkyeColors.textSecondary,
            ),
          ),
          const SizedBox(height: 20),
          // Animated gauge visualization
          SizedBox(
            height: 80,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return CustomPaint(
                  painter: _PressureGaugePainter(
                    color: color,
                    pressure: widget.pressure,
                    animationValue: _controller.value,
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

class _PressureGaugePainter extends CustomPainter {
  final Color color;
  final double pressure;
  final double animationValue;

  _PressureGaugePainter({
    required this.color,
    required this.pressure,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Normalize pressure to 0-1 (980-1050 hPa range)
    final normalizedPressure = ((pressure - 980) / 70).clamp(0.0, 1.0);

    final center = Offset(size.width / 2, size.height / 2 + 10);
    final radius = size.width / 2.5;

    // Draw background arc
    final bgPaint = Paint()
      ..color = color.withAlphaFromOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi * 0.75,
      math.pi * 1.5,
      false,
      bgPaint,
    );

    // Draw pressure value arc with subtle pulse
    final pulse = math.sin(animationValue * math.pi * 2) * 0.05;
    final animatedValue = (normalizedPressure + pulse).clamp(0.0, 1.0);

    final valuePaint = Paint()
      ..shader = LinearGradient(
        colors: [
          color.withAlphaFromOpacity(0.6),
          color,
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi * 0.75,
      math.pi * 1.5 * animatedValue,
      false,
      valuePaint,
    );

    // Draw animated needle
    final needleAngle = math.pi * 0.75 + (math.pi * 1.5 * animatedValue);
    final needleLength = radius - 5;
    final needleEnd = Offset(
      center.dx + needleLength * math.cos(needleAngle),
      center.dy + needleLength * math.sin(needleAngle),
    );

    final needlePaint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(center, needleEnd, needlePaint);

    // Draw center dot with pulse
    final dotRadius = 6 + pulse * 2;
    final dotPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, dotRadius, dotPaint);

    // Draw tick marks
    for (int i = 0; i <= 5; i++) {
      final tickAngle = math.pi * 0.75 + (math.pi * 1.5 * (i / 5));
      final tickStart = Offset(
        center.dx + (radius + 5) * math.cos(tickAngle),
        center.dy + (radius + 5) * math.sin(tickAngle),
      );
      final tickEnd = Offset(
        center.dx + (radius + 10) * math.cos(tickAngle),
        center.dy + (radius + 10) * math.sin(tickAngle),
      );

      final tickPaint = Paint()
        ..color = color.withAlphaFromOpacity(0.3)
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round;

      canvas.drawLine(tickStart, tickEnd, tickPaint);
    }
  }

  @override
  bool shouldRepaint(_PressureGaugePainter oldDelegate) =>
      animationValue != oldDelegate.animationValue ||
      pressure != oldDelegate.pressure;
}

