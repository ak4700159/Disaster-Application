import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// 미구현 -- 누적된 데이터를 받아오는데 시간적 한계
class DisasterScreen extends StatelessWidget {
  const DisasterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '피해 누적 현황',
        ),
      ),
      body: Center(child: Text(''),),
    );
  }
}
