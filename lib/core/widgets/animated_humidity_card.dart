import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../theme/skye_theme.dart';
import 'glass_card.dart';

/// Large animated humidity card with rain drops
class AnimatedHumidityCard extends StatefulWidget {
  final String value;
  final double humidity; // 0-100%
  final Color? accentColor;

  const AnimatedHumidityCard({
    super.key,
    required this.value,
    required this.humidity,
    this.accentColor,
  });

  @override
  State<AnimatedHumidityCard> createState() => _AnimatedHumidityCardState();
}

class _AnimatedHumidityCardState extends State<AnimatedHumidityCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_RainDrop> _rainDrops = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    // Initialize rain drops based on humidity
    _initializeRainDrops();
  }

  void _initializeRainDrops() {
    final random = math.Random();
    // More drops with higher humidity (3-12 drops)
    final numDrops = 3 + ((widget.humidity / 100) * 9).round();

    for (int i = 0; i < numDrops; i++) {
      _rainDrops.add(_RainDrop(
        x: random.nextDouble(),
        startY: -random.nextDouble() * 0.8,
        speed: 0.3 + random.nextDouble() * 0.4,
        size: 3 + random.nextDouble() * 4,
        delay: i * (1.0 / numDrops),
      ));
    }
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
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.water_drop_rounded,
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
                    'Humidity',
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
          // Animated rain drops visualization
          SizedBox(
            height: 100,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return CustomPaint(
                  painter: _RainDropsPainter(
                    color: color,
                    animationValue: _controller.value,
                    humidity: widget.humidity,
                    rainDrops: _rainDrops,
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

class _RainDrop {
  final double x; // 0-1 horizontal position
  final double startY;
  final double speed;
  final double size;
  final double delay;

  _RainDrop({
    required this.x,
    required this.startY,
    required this.speed,
    required this.size,
    required this.delay,
  });
}

class _RainDropsPainter extends CustomPainter {
  final Color color;
  final double animationValue;
  final double humidity;
  final List<_RainDrop> rainDrops;

  _RainDropsPainter({
    required this.color,
    required this.animationValue,
    required this.humidity,
    required this.rainDrops,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw ground puddle area that grows with humidity
    _drawPuddles(canvas, size);

    // Draw falling rain drops
    for (final drop in rainDrops) {
      _drawRainDrop(canvas, size, drop);
    }

;
  }

  void _drawPuddles(Canvas canvas, Size size) {
    // Puddles at the bottom that grow with humidity
    final puddleHeight = (humidity / 100) * 15;

    if (puddleHeight > 0) {
      final puddlePath = Path();

      // Create wavy puddle surface
      for (double x = 0; x <= size.width; x += 4) {
        final wave = math.sin(x * 0.05 + animationValue * math.pi * 2) * 2;
        final y = size.height - puddleHeight + wave;

        if (x == 0) {
          puddlePath.moveTo(x, y);
        } else {
          puddlePath.lineTo(x, y);
        }
      }

      puddlePath.lineTo(size.width, size.height);
      puddlePath.lineTo(0, size.height);
      puddlePath.close();

      final puddlePaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            color.withOpacity(0.1),
            color.withOpacity(0.25),
          ],
        ).createShader(Rect.fromLTWH(0, size.height - puddleHeight, size.width, puddleHeight));

      canvas.drawPath(puddlePath, puddlePaint);
    }
  }

  void _drawRainDrop(Canvas canvas, Size size, _RainDrop drop) {
    final progress = ((animationValue + drop.delay) % 1.0);
    final y = size.height * (drop.startY + progress * 1.2);
    final x = size.width * drop.x;

    // Only draw if visible
    if (y >= 0 && y <= size.height - 10) {
      // Fade out as it gets closer to bottom
      final opacity = y < size.height * 0.8 ? 0.7 : (1.0 - (y - size.height * 0.8) / (size.height * 0.2)) * 0.7;

      // Draw elongated drop shape
      final dropPath = Path();

      // Top point
      dropPath.moveTo(x, y - drop.size * 2);

      // Left side
      dropPath.quadraticBezierTo(
        x - drop.size * 0.4,
        y - drop.size,
        x - drop.size * 0.3,
        y,
      );

      // Bottom (rounded)
      dropPath.quadraticBezierTo(
        x,
        y + drop.size * 0.5,
        x + drop.size * 0.3,
        y,
      );

      // Right side
      dropPath.quadraticBezierTo(
        x + drop.size * 0.4,
        y - drop.size,
        x,
        y - drop.size * 2,
      );

      dropPath.close();

      final dropPaint = Paint()
        ..color = color.withOpacity(opacity)
        ..style = PaintingStyle.fill;

      canvas.drawPath(dropPath, dropPaint);

      // Add highlight to make it look glossy
      final highlightPaint = Paint()
        ..color = Colors.white.withOpacity(opacity * 0.3)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(x - drop.size * 0.15, y - drop.size * 1.5),
        drop.size * 0.25,
        highlightPaint,
      );

      // Draw motion streak for faster drops
      if (drop.speed > 0.5) {
        final streakPaint = Paint()
          ..color = color.withOpacity(opacity * 0.2)
          ..strokeWidth = drop.size * 0.3
          ..strokeCap = StrokeCap.round;

        canvas.drawLine(
          Offset(x, y - drop.size * 2.5),
          Offset(x, y - drop.size * 3.5),
          streakPaint,
        );
      }
    }

    // Draw splash effect when drop hits bottom
    if (y >= size.height - 15 && y <= size.height - 5) {
      final splashProgress = (y - (size.height - 15)) / 10;
      _drawSplash(canvas, Offset(x, size.height - 10), splashProgress, drop.size);
    }
  }

  void _drawSplash(Canvas canvas, Offset position, double progress, double dropSize) {
    final splashSize = dropSize * (1 + progress * 2);
    final opacity = (1.0 - progress) * 0.4;

    // Draw small splash ripple
    final splashPaint = Paint()
      ..color = color.withOpacity(opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    canvas.drawCircle(position, splashSize, splashPaint);

    // Draw splash particles
    for (int i = 0; i < 4; i++) {
      final angle = (i / 4) * math.pi * 2 + progress;
      final particleX = position.dx + math.cos(angle) * splashSize * 0.8;
      final particleY = position.dy + math.sin(angle) * splashSize * 0.5 - progress * 3;

      final particlePaint = Paint()
        ..color = color.withOpacity(opacity * 0.8)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(particleX, particleY),
        dropSize * 0.2 * (1 - progress),
        particlePaint,
      );
    }
  }


  @override
  bool shouldRepaint(_RainDropsPainter oldDelegate) =>
      animationValue != oldDelegate.animationValue ||
      humidity != oldDelegate.humidity;
}

