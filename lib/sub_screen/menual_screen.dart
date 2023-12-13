import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Screen2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('대응메뉴얼')),
      body: Center(child: Text('이것은 대응 메뉴얼 화면입니다')),
    );
  }
}