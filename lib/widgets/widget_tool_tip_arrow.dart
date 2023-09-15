import 'package:flutter/material.dart';

class TooltipArrowPainter extends CustomPainter {
  final Color color;

  TooltipArrowPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(size.width / 2 - 10, 10)
      ..lineTo(size.width / 2 + 10, 10)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
