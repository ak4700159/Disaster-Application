import 'dart:async';

import 'package:flutter/material.dart';
import 'package:test1/WeatherScreen.dart';
import 'package:test1/model/hazard_graph.dart';

import '../main.dart';

class HazardScreen extends StatefulWidget {
  HazardScreen({super.key});

  @override
  State<HazardScreen> createState() => _HazardScreenState();
}

class _HazardScreenState extends State<HazardScreen> {
  double temperatureInCelsius = 0;

  late Map<String, dynamic> weatherResult;

  @override
  Widget build(BuildContext context) {
    return TextButton(
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
    );
  }

  @override
  void initState() {
    getWeatherData();

    const Duration updateInterval = Duration(minutes: 3); //3분마다 업데이트
    Timer.periodic(updateInterval, (Timer t) => getWeatherData());
    setState(() {});
    super.initState();
  }

  void getWeatherData() async {
    HttpHelper helper = HttpHelper();

    try {
      weatherResult = await helper.getWeather('daegu');
      setState(() {
        temperatureInKelvin = weatherResult['main']['temp'];
        temperatureInCelsius = temperatureInKelvin - 273.15;
        updateHazardRate();
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  void updateHazardRate() {
    temperatureInCelsius;
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

        double minTemperatureInKelvin = main['temp_min'];
        double maxTemperatureInKelvin = main['temp_max'];
        double feelsLikeInKelvin = main['feels_like'];

        return AlertDialog(
          title: Text('지역: ${weatherResult['name']}'), // 지역
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('온도: ${temperatureInCelsius.toStringAsFixed(2)} °C'),
                Text(
                    '체감온도: ${(feelsLikeInKelvin - 273.15).toStringAsFixed(2)} °C'), // 체감온도 추가
                Text('날씨: ${weather['description']}'),
                Text(
                    '최저 온도: ${(minTemperatureInKelvin - 273.15).toStringAsFixed(2)} °C'),
                Text(
                    '최고 온도: ${(maxTemperatureInKelvin - 273.15).toStringAsFixed(2)} °C'),
                Text(
                  '현재 위험도: ${hazardRate}%',
                  style: hazardRate > 50
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
              child: Text('확인'),
            ),
          ],
        );
      },
    );
  }
}
