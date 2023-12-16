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
      size: Size(150, 50),
      painter: HazardGraph(hazardRate: hazardRate),
    );
  }
}
