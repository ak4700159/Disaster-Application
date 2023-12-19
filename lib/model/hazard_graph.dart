import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// 그래프 그려주도록 하는 클래스 - Canvus 활용
class HazardGraph extends CustomPainter{
  final double hazardRate;
  HazardGraph({required this.hazardRate});

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    Paint paint = Paint()
    ..color = Colors.blue
    ..strokeCap = StrokeCap.butt
    ..strokeWidth = 20.0;
    Offset p1 = Offset(0, 0);
    Offset p2 = Offset(0, 100 - hazardRate);
    canvas.drawLine(p1, p2, paint);

    paint.color = Colors.red;
    p1 = Offset(0, 100 - hazardRate);
    p2 = Offset(0, 100);
    canvas.drawLine(p1, p2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}