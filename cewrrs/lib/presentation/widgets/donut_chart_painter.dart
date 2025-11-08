// lib/presentation/widgets/donut_chart_painter.dart
import 'package:flutter/material.dart';

class DonutSection {
  final Color color;
  final int percentage;
  DonutSection({required this.color, required this.percentage});
}

class DonutChartPainter extends CustomPainter {
  final List<DonutSection> sections;

  DonutChartPainter({required this.sections});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.4;
    final strokeWidth = 35.0;

    double startAngle = -90 * (3.14159 / 180); // top

    for (var s in sections) {
      final sweep = s.percentage / 100 * 360 * (3.14159 / 180);
      final paint = Paint()
        ..color = s.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweep,
        false,
        paint,
      );
      startAngle += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}