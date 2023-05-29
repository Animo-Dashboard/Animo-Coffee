import 'dart:math' as math;
import 'package:flutter/material.dart';

class CircularDiagram extends StatelessWidget {
  final double percentage;
  final Color backgroundColor;
  final Color foregroundColor;
  final double strokeWidth;

  CircularDiagram({
    required this.percentage,
    this.backgroundColor = Colors.grey,
    this.foregroundColor = Colors.blue,
    this.strokeWidth = 10.0,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _CircularDiagramPainter(
        percentage: percentage,
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        strokeWidth: strokeWidth,
      ),
    );
  }
}

class _CircularDiagramPainter extends CustomPainter {
  final double percentage;
  final Color backgroundColor;
  final Color foregroundColor;
  final double strokeWidth;

  _CircularDiagramPainter({
    required this.percentage,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (math.min(size.width, size.height) - strokeWidth) / 2;

    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(center, radius, backgroundPaint);

    final foregroundPaint = Paint()
      ..color = foregroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * math.pi * (percentage / 100);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweepAngle,
      false,
      foregroundPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
