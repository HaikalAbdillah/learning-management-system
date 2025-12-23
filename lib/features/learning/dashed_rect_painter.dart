import 'package:flutter/material.dart';
import 'dart:math' as math;

class DashedRectPainter extends CustomPainter {
  final double strokeWidth;
  final Color color;
  final double gap;
  final double dashLength;

  DashedRectPainter({
    this.strokeWidth = 5.0,
    this.color = Colors.red,
    this.gap = 5.0,
    this.dashLength = 10.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint dashedPaint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    double x = size.width;
    double y = size.height;

    Path topPath = getDashedPath(
      a: Offset(0, 0),
      b: Offset(x, 0),
      gap: gap,
      dashLength: dashLength,
    );

    Path rightPath = getDashedPath(
      a: Offset(x, 0),
      b: Offset(x, y),
      gap: gap,
      dashLength: dashLength,
    );

    Path bottomPath = getDashedPath(
      a: Offset(0, y),
      b: Offset(x, y),
      gap: gap,
      dashLength: dashLength,
    );

    Path leftPath = getDashedPath(
      a: Offset(0, 0),
      b: Offset(0, y),
      gap: gap,
      dashLength: dashLength,
    );

    canvas.drawPath(topPath, dashedPaint);
    canvas.drawPath(rightPath, dashedPaint);
    canvas.drawPath(bottomPath, dashedPaint);
    canvas.drawPath(leftPath, dashedPaint);
  }

  Path getDashedPath({
    required Offset a,
    required Offset b,
    required double gap,
    required double dashLength,
  }) {
    final Path path = Path();
    path.moveTo(a.dx, a.dy);

    // Calculate the total length of the line
    final double totalLength = (b.dx - a.dx).abs() + (b.dy - a.dy).abs();

    double currentX = a.dx;
    double currentY = a.dy;
    bool shouldDraw = true;
    double drawn = 0;

    while (drawn < totalLength) {
      final double remainingToEnd =
          (b.dx - currentX).abs() + (b.dy - currentY).abs();

      if (remainingToEnd <= 0) break;

      if (shouldDraw) {
        // Draw dash
        final double dashToDraw = math.min(dashLength, remainingToEnd);

        // Calculate the direction towards the end point
        final double deltaX = (b.dx - currentX) / remainingToEnd * dashToDraw;
        final double deltaY = (b.dy - currentY) / remainingToEnd * dashToDraw;

        currentX += deltaX;
        currentY += deltaY;
        path.lineTo(currentX, currentY);
        drawn += dashToDraw;
      } else {
        // Skip gap
        final double gapToSkip = math.min(gap, remainingToEnd);
        final double deltaX = (b.dx - currentX) / remainingToEnd * gapToSkip;
        final double deltaY = (b.dy - currentY) / remainingToEnd * gapToSkip;

        currentX += deltaX;
        currentY += deltaY;
        drawn += gapToSkip;
      }

      shouldDraw = !shouldDraw;
    }

    return path;
  }

  @override
  bool shouldRepaint(DashedRectPainter oldDelegate) {
    return strokeWidth != oldDelegate.strokeWidth ||
        color != oldDelegate.color ||
        gap != oldDelegate.gap ||
        dashLength != oldDelegate.dashLength;
  }
}
