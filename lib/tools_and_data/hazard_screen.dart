import 'package:flutter/material.dart';
import 'package:test1/tools_and_data/hazard_graph.dart';

class HazardScreen extends StatefulWidget {
  HazardScreen({super.key});

  @override
  State<HazardScreen> createState() => _HazardScreenState();
}

class _HazardScreenState extends State<HazardScreen> {
  double hazardRate = 50;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(100, 100),
      child: Container(
        width: 100,
        height: 100,
        color: Colors.black,
      ),
      painter: HazardGraph(hazardRate: hazardRate),
    );
  }
}
