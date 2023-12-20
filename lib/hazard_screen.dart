import 'dart:async';

import 'package:flutter/material.dart';
import 'package:test1/model/hazard_graph.dart';

import 'main.dart';

// 위험도 그래프를 나타내는 스크린 막대
// 위험도 비율에 따라 유동적으로 변화
class HazardScreen extends StatefulWidget {
  HazardScreen({super.key, required this.weatherResult});

  Map<String, dynamic> weatherResult;

  @override
  State<HazardScreen> createState() => _HazardScreenState();
}

class _HazardScreenState extends State<HazardScreen> {
  double temperatureInCelsius = testTemperature; // 테스트 문구
  late Map<String, dynamic> weatherResult;

  @override
  void initState() {
    super.initState();

    weatherResult = widget.weatherResult;
    const Duration updateInterval = Duration(seconds: 2); //3초마다 업데이트
    Timer.periodic(updateInterval, (Timer t) => weatherResult = widget.weatherResult);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.1,
      left: 10,
      child: Column(
        children: [
          TextButton(
            onPressed: () {
              _showWeatherDetails(weatherResult);
            },
            child: Container(
              width: 40,
              height: 150,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomPaint(
                    size: const Size(5, 100),
                    foregroundPainter: HazardGraph(hazardRate: hazardRate),
                  ),
                  const Text(
                    '위험도',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 위험도 비율 산출
  void updateHazardRate() {
    temperatureInCelsius = testTemperature; // 테스트 문구
    if (temperatureInCelsius >= 35 && temperatureInCelsius < 45) {
      hazardRate = (temperatureInCelsius - 35) / 10 * 100;
      hazardMode = '폭염';
      return;
    }
    if (temperatureInCelsius >= 45) {
      hazardRate = 100;
      hazardMode = '폭염';
      return;
    }

    if (temperatureInCelsius <= -5 && temperatureInCelsius > -20) {
      hazardRate = (-temperatureInCelsius - 5) / 15 * 100;
      hazardMode = '한파';
      return;
    }
    if (temperatureInCelsius <= -20) {
      hazardMode = '한파';
      hazardRate = 100;
      return;
    }
  }

  void _showWeatherDetails(Map<String, dynamic> weatherResult) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        var main = weatherResult['main'];
        var weather = weatherResult['weather'][0];

        double feelsLikeInKelvin = main['feels_like'];
        double temperatureInKelvin = weatherResult['main']['temp'];
        temperatureInCelsius = temperatureInKelvin - 273.15;
        //temperatureInCelsius = testTemperature; // 테스트 문구

        return AlertDialog(
          title: Text(
            '지역: ${weatherResult['name']}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
          // 지역
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                selectWeatherIcon(weatherResult['weather'][0]),
                Text(
                  '온도: ${temperatureInCelsius.toStringAsFixed(2)} °C',
                  style: const TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                    '체감온도: ${(feelsLikeInKelvin - 273.15).toStringAsFixed(2)} °C'), // 체감온도 추가
                Text(
                  '현재 위험도: ${hazardRate}%',
                  style: hazardRate >= 50
                      ? const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        )
                      : const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }
}
