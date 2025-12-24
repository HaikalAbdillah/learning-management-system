import 'dart:math' as math;
import 'package:flutter/material.dart';

class PentagonPainter extends CustomPainter {
  final double size;
  final Color shadowColor;
  final double blurRadius;
  final Offset offset;

  PentagonPainter({
    required this.size,
    required this.shadowColor,
    this.blurRadius = 10.0,
    this.offset = const Offset(0, 4),
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Create pentagon path
    final path = Path();
    final center = Offset(
      size.width / 2 + offset.dx,
      size.height / 2 + offset.dy,
    );
    final radius = this.size / 2;

    // Pentagon vertices (rotated to have flat top)
    final angles = [
      -90 * (3.14159 / 180), // Top
      -18 * (3.14159 / 180), // Top right
      54 * (3.14159 / 180), // Bottom right
      126 * (3.14159 / 180), // Bottom left
      198 * (3.14159 / 180), // Top left
    ];

    final points = angles
        .map(
          (angle) => Offset(
            center.dx + radius * math.cos(angle),
            center.dy + radius * math.sin(angle),
          ),
        )
        .toList();

    path.moveTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    path.close();

    // Create shadow with blur
    canvas.drawShadow(
      path,
      shadowColor,
      blurRadius,
      false, // invert: false (shadow below the shape)
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class PentagonShadow extends StatelessWidget {
  final Widget child;
  final double size;
  final Color shadowColor;
  final double blurRadius;
  final Offset offset;

  const PentagonShadow({
    super.key,
    required this.child,
    required this.size,
    this.shadowColor = Colors.black,
    this.blurRadius = 10.0,
    this.offset = const Offset(0, 4),
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: PentagonPainter(
        size: size,
        shadowColor: shadowColor.withAlpha((0.4 * 255).round()),
        blurRadius: blurRadius,
        offset: offset,
      ),
      child: child,
    );
  }
}
