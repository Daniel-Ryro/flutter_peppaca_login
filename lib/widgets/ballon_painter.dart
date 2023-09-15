import 'package:flutter/material.dart';

class BalloonPainter extends CustomPainter {
  final Color balloonColor;
  final Color borderColor;
  final double borderRadius;
  final double offsetY;  // Parâmetro para o deslocamento vertical

  BalloonPainter({
    required this.balloonColor, 
    required this.borderColor,
    this.borderRadius = 10.0,
    this.offsetY = 16.0,  // Valor padrão de 10 pixels para baixo
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..color = balloonColor;
    final double arrowTipOffset = size.width * 0.1;

    final Path path = Path()
      ..moveTo(borderRadius, offsetY)
      ..lineTo(arrowTipOffset - 10, offsetY)
      ..lineTo(arrowTipOffset, offsetY - 10)  // Esta parte da seta não é deslocada
      ..lineTo(arrowTipOffset + 10, offsetY)
      ..lineTo(size.width - borderRadius, offsetY)
      ..arcToPoint(
        Offset(size.width, borderRadius + offsetY),
        radius: Radius.circular(borderRadius),
      )
      ..lineTo(size.width, size.height - borderRadius + offsetY)
      ..arcToPoint(
        Offset(size.width - borderRadius, size.height + offsetY),
        radius: Radius.circular(borderRadius),
      )
      ..lineTo(borderRadius, size.height + offsetY)
      ..arcToPoint(
        Offset(0, size.height - borderRadius + offsetY),
        radius: Radius.circular(borderRadius),
      )
      ..lineTo(0, borderRadius + offsetY)
      ..arcToPoint(
        Offset(borderRadius, offsetY),
        radius: Radius.circular(borderRadius),
      );

    canvas.drawPath(path, paint);

    final Paint borderPaint = Paint()
      ..color = borderColor
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

