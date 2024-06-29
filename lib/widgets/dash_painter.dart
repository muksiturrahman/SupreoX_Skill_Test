import 'package:flutter/material.dart';

class DashPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double radius;

  DashPainter({required this.color, this.strokeWidth = 2.0, this.radius = 8.0});

  @override
  void paint(Canvas canvas, Size size) {
    double dashWidth = 5.0;
    double dashSpace = 3.0;
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(radius, 0)
      ..lineTo(size.width - radius, 0)
      ..arcToPoint(Offset(size.width, radius), radius: Radius.circular(radius))
      ..lineTo(size.width, size.height - radius)
      ..arcToPoint(Offset(size.width - radius, size.height), radius: Radius.circular(radius))
      ..lineTo(radius, size.height)
      ..arcToPoint(Offset(0, size.height - radius), radius: Radius.circular(radius))
      ..lineTo(0, radius)
      ..arcToPoint(Offset(radius, 0), radius: Radius.circular(radius));

    // Create a path metric to measure and create the dashes
    final pathMetrics = path.computeMetrics();
    for (var metric in pathMetrics) {
      var distance = 0.0;
      while (distance < metric.length) {
        final length = (dashWidth + dashSpace).clamp(0.0, metric.length - distance);
        final end = distance + length;
        final dash = metric.extractPath(distance, distance + dashWidth);
        canvas.drawPath(dash, paint);
        distance = end;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
