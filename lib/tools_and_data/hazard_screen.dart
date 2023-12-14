import 'package:flutter/material.dart';
import 'package:test1/tools_and_data/hazard_graph.dart';


class HazardScreen extends StatefulWidget {
  const HazardScreen({super.key});

  @override
  State<HazardScreen> createState() => _HazardScreenState();
}

class _HazardScreenState extends State<HazardScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(100, 40),
      painter: HazardGraph(),
    );
  }
}
