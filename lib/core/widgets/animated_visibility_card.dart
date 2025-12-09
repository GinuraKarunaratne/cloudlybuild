import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../theme/skye_colors.dart';
import '../theme/skye_typography.dart';
import 'glass_card.dart';

/// Compact animated visibility card with fog/mist layers
class AnimatedVisibilityCard extends StatefulWidget {
  final String value;
  final double visibility; // km
  final Color? accentColor;

  const AnimatedVisibilityCard({
    super.key,
    required this.value,
    required this.visibility,
    this.accentColor,
  });

  @override
  State<AnimatedVisibilityCard> createState() => _AnimatedVisibilityCardState();
}

class _AnimatedVisibilityCardState extends State<AnimatedVisibilityCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    )..repeat();
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
            'Visibility',
            style: SkyeTypography.metricLabel.copyWith(
              fontSize: 12,
              color: SkyeColors.textSecondary,
            ),
          ),
          const SizedBox(height: 20),
          // Animated fog/mist visualization
          SizedBox(
            height: 80,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return CustomPaint(
                  painter: _FogMistPainter(
                    color: color,
                    visibility: widget.visibility,
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

class _FogMistPainter extends CustomPainter {
  final Color color;
  final double visibility;
  final double animationValue;

  _FogMistPainter({
    required this.color,
    required this.visibility,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Normalize visibility (0-20 km range)
    // Lower visibility = more fog layers
    // Higher visibility = fewer/lighter fog layers
    final normalizedVisibility = (visibility / 20).clamp(0.0, 1.0);
    final fogDensity = 1.0 - normalizedVisibility; // Inverted: high visibility = low fog

    // Number of fog layers based on visibility
    final numLayers = 3 + (fogDensity * 3).round(); // 3-6 layers

    // Draw wavy fog/mist layers
    for (int i = 0; i < numLayers; i++) {
      final layerProgress = i / numLayers;
      final yPosition = size.height * (0.15 + layerProgress * 0.7);

      // Each layer has different animation speed and direction
      final layerSpeed = (i % 2 == 0) ? 1.0 : -0.7;
      final animOffset = animationValue * layerSpeed;

      // Opacity based on fog density and layer depth
      final baseOpacity = 0.08 + (fogDensity * 0.25);
      final layerOpacity = baseOpacity * (1.0 - layerProgress * 0.4);

      _drawFogLayer(
        canvas,
        size,
        yPosition,
        animOffset,
        layerOpacity,
        i,
      );
    }

    // Draw landscape silhouettes that fade based on visibility
    _drawLandscapeSilhouettes(canvas, size, normalizedVisibility);
  }

  void _drawFogLayer(
    Canvas canvas,
    Size size,
    double yPosition,
    double animOffset,
    double opacity,
    int layerIndex,
  ) {
    final path = Path();
    final layerHeight = 15.0 + (layerIndex * 3);

    // Create wavy fog layer
    for (double x = -size.width; x <= size.width * 2; x += 3) {
      final adjustedX = x - (animOffset * size.width);

      // Create organic, flowing waves
      final frequency1 = 0.02 + (layerIndex * 0.003);
      final frequency2 = 0.015 - (layerIndex * 0.002);
      final amplitude = 8 + (layerIndex * 2);

      final wave1 = math.sin(adjustedX * frequency1) * amplitude;
      final wave2 = math.cos(adjustedX * frequency2 + layerIndex) * (amplitude * 0.5);
      final combinedWave = wave1 + wave2;

      if (x == -size.width) {
        path.moveTo(x, yPosition + combinedWave - layerHeight / 2);
      } else {
        path.lineTo(x, yPosition + combinedWave - layerHeight / 2);
      }
    }

    // Complete the fog shape
    path.lineTo(size.width * 2, yPosition + layerHeight);
    path.lineTo(-size.width, yPosition + layerHeight);
    path.close();

    // Draw fog layer with gradient
    final fogPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          color.withOpacity(opacity * 0.3),
          color.withOpacity(opacity),
          color.withOpacity(opacity * 0.5),
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromLTWH(0, yPosition - layerHeight / 2, size.width, layerHeight))
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, fogPaint);
  }

  void _drawLandscapeSilhouettes(Canvas canvas, Size size, double normalizedVisibility) {
    // Draw distant mountains/buildings that fade based on visibility
    final silhouettes = [
      {'x': 0.15, 'height': 0.25, 'width': 0.15},
      {'x': 0.35, 'height': 0.35, 'width': 0.2},
      {'x': 0.6, 'height': 0.2, 'width': 0.15},
      {'x': 0.8, 'height': 0.3, 'width': 0.18},
    ];

    for (int i = 0; i < silhouettes.length; i++) {
      final silhouette = silhouettes[i];
      final x = size.width * (silhouette['x'] as double);
      final height = size.height * (silhouette['height'] as double);
      final width = size.width * (silhouette['width'] as double);

      // Opacity based on visibility and distance
      final distanceFactor = (i + 1) / silhouettes.length;
      final baseOpacity = 0.15 * normalizedVisibility;
      final opacity = baseOpacity * (1.0 - distanceFactor * 0.6);

      // Draw simple mountain/building shape
      final silhouettePath = Path();
      silhouettePath.moveTo(x, size.height);

      // Create peaked shape
      silhouettePath.lineTo(x + width * 0.3, size.height - height * 0.7);
      silhouettePath.lineTo(x + width * 0.5, size.height - height);
      silhouettePath.lineTo(x + width * 0.7, size.height - height * 0.6);
      silhouettePath.lineTo(x + width, size.height);
      silhouettePath.close();

      final silhouettePaint = Paint()
        ..color = color.withOpacity(opacity)
        ..style = PaintingStyle.fill;

      canvas.drawPath(silhouettePath, silhouettePaint);
    }

    // Draw visibility indicator lines (like distance markers)
    final numLines = (normalizedVisibility * 4).round() + 1;
    for (int i = 0; i < numLines; i++) {
      final x = size.width * (0.1 + i * 0.2);
      final lineOpacity = 0.1 * normalizedVisibility * (1.0 - i / numLines * 0.5);

      final linePaint = Paint()
        ..color = color.withOpacity(lineOpacity)
        ..strokeWidth = 1.5
        ..strokeCap = StrokeCap.round;

      canvas.drawLine(
        Offset(x, size.height * 0.6),
        Offset(x, size.height * 0.9),
        linePaint,
      );
    }
  }

  @override
  bool shouldRepaint(_FogMistPainter oldDelegate) =>
      animationValue != oldDelegate.animationValue ||
      visibility != oldDelegate.visibility;
}
