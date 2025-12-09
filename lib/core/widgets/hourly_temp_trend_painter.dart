import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../theme/skye_theme.dart';

/// Custom painter for hourly temperature trend line with dots
class HourlyTempTrendPainter extends CustomPainter {
  final List<double> temperatures;
  final Color lineColor;
  final Color dotColor;
  final Color gradientStartColor;
  final Color gradientEndColor;

  HourlyTempTrendPainter({
    required this.temperatures,
    required this.lineColor,
    required this.dotColor,
    required this.gradientStartColor,
    required this.gradientEndColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (temperatures.isEmpty || temperatures.length < 2) return;

    // Find min and max temperatures for normalization
    final minTemp = temperatures.reduce(math.min);
    final maxTemp = temperatures.reduce(math.max);
    final tempRange = (maxTemp - minTemp).abs() < 0.1 ? 1.0 : (maxTemp - minTemp);

    // Calculate X-step for evenly distributed points
    final dxStep = temperatures.length > 1
        ? size.width / (temperatures.length - 1)
        : size.width / 2;

    // Generate points for the trend line
    final points = <Offset>[];
    for (int i = 0; i < temperatures.length; i++) {
      final t = temperatures[i];
      final normalized = (t - minTemp) / tempRange;

      // Invert Y so higher temp is higher on canvas (leave margins)
      final y = size.height - (normalized * (size.height - 16)) - 8;
      final x = dxStep * i;

      points.add(Offset(x, y));
    }

    // Draw gradient fill under the line
    _drawGradientFill(canvas, size, points);

    // Draw the smooth trend line
    _drawTrendLine(canvas, points);

    // Draw dots at each hour point
    _drawDots(canvas, points);
  }

  void _drawGradientFill(Canvas canvas, Size size, List<Offset> points) {
    if (points.isEmpty) return;

    final gradientPath = Path();
    gradientPath.moveTo(points.first.dx, size.height);
    gradientPath.lineTo(points.first.dx, points.first.dy);

    // Create smooth curve through points
    for (int i = 1; i < points.length; i++) {
      gradientPath.lineTo(points[i].dx, points[i].dy);
    }

    gradientPath.lineTo(points.last.dx, size.height);
    gradientPath.close();

    final gradientPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          gradientStartColor.withAlphaFromOpacity(0.25),
          gradientEndColor.withAlphaFromOpacity(0.05),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    canvas.drawPath(gradientPath, gradientPaint);
  }

  void _drawTrendLine(Canvas canvas, List<Offset> points) {
    final linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    path.moveTo(points.first.dx, points.first.dy);

    // Draw smooth curve through points
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }

    canvas.drawPath(path, linePaint);
  }

  void _drawDots(Canvas canvas, List<Offset> points) {
    final dotPaint = Paint()
      ..color = dotColor
      ..style = PaintingStyle.fill;

    final dotOutlinePaint = Paint()
      ..color = lineColor.withAlphaFromOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (final point in points) {
      // Draw outer ring
      canvas.drawCircle(point, 5.5, dotOutlinePaint);
      // Draw filled dot
      canvas.drawCircle(point, 4, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant HourlyTempTrendPainter oldDelegate) {
    return oldDelegate.temperatures != temperatures ||
        oldDelegate.lineColor != lineColor ||
        oldDelegate.dotColor != dotColor;
  }
}

