import 'package:flutter/material.dart';
import 'package:flutter_caraio/utils/typography.dart';
import 'package:flutter_caraio/widgets/ballon_painter.dart';

class PasswordBalloon extends StatelessWidget {
  final GlobalKey _passwordFieldKey;
  final TextStyle? textStyle;

  PasswordBalloon({
    required GlobalKey passwordFieldKey,
    this.textStyle,
    Key? key,
  })  : _passwordFieldKey = passwordFieldKey,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final RenderBox renderBox =
        _passwordFieldKey.currentContext!.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset(0, size.height + 5));

    return Positioned(
      left: offset.dx,
      top: offset.dy - 10,
      child: Material(
        color: Colors.transparent,
        child: CustomPaint(
          painter: BalloonPainter(
            balloonColor: Colors.white,
            borderColor: AppColors.primaryColor,
          ),
          child: Container(
            padding: const EdgeInsets.all(8.0).copyWith(
                top: 30.0), // Increase padding at the top for the arrow
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
            ),
            alignment: Alignment.center,
            child: Text(
              'Password must contain at least:\n'
              '• One uppercase letter\n'
              '• One number\n'
              '• One special character (~`!@#\$%^&*()-_+={}[]|\\;:"<>,./?)\n'
              '• 8 characters minimum',
              style: textStyle ?? AppTextStyles.regularAlert,
            ),
          ),
        ),
      ),
    );
  }
}
