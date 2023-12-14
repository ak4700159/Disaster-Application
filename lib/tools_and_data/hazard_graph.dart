import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HazardGraph extends CustomPainter{

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    Paint paint = Paint()
    ..color = Colors.red
    ..strokeCap = StrokeCap.square
    ..strokeWidth = 20.0;

    Offset p1 = Offset(10,10);
    Offset p2 = Offset(10, 80);

    canvas.drawLine(p1, p2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}