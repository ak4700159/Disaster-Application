import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HazardGraph extends CustomPainter{

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    Paint paint = Paint()
    ..color = Colors.blue
    ..strokeCap = StrokeCap.square
    ..strokeWidth = 20.0;

    Offset p1 = Offset(10, 10);
    Offset p2 = Offset(10, 40);

    canvas.drawLine(p1, p2, paint);

    paint.color = Colors.red;
    p1 = Offset(10, 40);
    p2 = Offset(10, 100);
    canvas.drawLine(p1, p2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}