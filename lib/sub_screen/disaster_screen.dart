import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
    );
  }
}
