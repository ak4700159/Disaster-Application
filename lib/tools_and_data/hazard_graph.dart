import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HazardGraph extends CustomPainter{
  final double hazardRate;
  HazardGraph({required this.hazardRate});

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    Paint paint = Paint()
    ..color = Colors.blue
    ..strokeCap = StrokeCap.square
    ..strokeWidth = 25.0;
    Offset p1 = Offset(10, 0);
    Offset p2 = Offset(10, 100 - hazardRate);
    canvas.drawLine(p1, p2, paint);

    if(hazardRate == 0)
      return;

    paint.color = Colors.red;
    p1 = Offset(10, 100 - hazardRate);
    p2 = Offset(10, 100);
    canvas.drawLine(p1, p2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}