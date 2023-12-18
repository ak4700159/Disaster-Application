import 'dart:async';

import 'package:flutter/material.dart';
import 'package:test1/WeatherScreen.dart';
import 'package:test1/model/hazard_graph.dart';

class HazardScreen extends StatefulWidget {
  HazardScreen({super.key});

  @override
  State<HazardScreen> createState() => _HazardScreenState();
}

class _HazardScreenState extends State<HazardScreen> {
  double hazardRate = 0;
  double temperatureInCelsius = 0;

  late Map<String, dynamic> weatherResult;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {

      },
      child: CustomPaint(
        size: const Size(100, 100),
        foregroundPainter: HazardGraph(hazardRate: hazardRate),
      ),
    );
  }

  @override
  void initState() {
    getWeatherData();

    const Duration updateInterval = Duration(minutes: 3); //3분마다 업데이트
    Timer.periodic(updateInterval, (Timer t) => getWeatherData());
    super.initState();
  }

  void getWeatherData() async {
    HttpHelper helper = HttpHelper();

    try {
      weatherResult = await helper.getWeather('daegu');
      setState(() {
        double temperatureInKelvin = weatherResult['main']['temp'];
        temperatureInCelsius = temperatureInKelvin - 273.15;
        updateHazardRate();
      });
    } catch (e) {
      print('Error: $e');

    }
  }

  void updateHazardRate(){
    if (temperatureInCelsius >= 35 && temperatureInCelsius < 45){
      hazardRate = (45 - temperatureInCelsius) / 10 * 100;
      return;
    }

    if(temperatureInCelsius <= -5 && temperatureInCelsius > 20){
      hazardRate = (-temperatureInCelsius - 5) / 15 * 100;
    }
  }

  void _showWeatherDetails(Map<String, dynamic> weatherResult) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        var main = weatherResult['main'];
        var weather = weatherResult['weather'][0];
        var wind = weatherResult['wind'];
        var sys = weatherResult['sys'];

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
                Text('체감온도: ${(feelsLikeInKelvin - 273.15).toStringAsFixed(2)} °C'), // 체감온도 추가
                Text('날씨: ${weather['description']}'),
                Text('최저 온도: ${(minTemperatureInKelvin - 273.15).toStringAsFixed(2)} °C'),
                Text('최고 온도: ${(maxTemperatureInKelvin - 273.15).toStringAsFixed(2)} °C'),
                Text('습도: ${main['humidity']}%'),
                Text('기압: ${main['pressure']} hPa'),
                Text('풍향: ${wind['deg']}°'), // 풍향 정보 추가
                Text('풍속: ${wind['speed']} m/s'),
                Text('일출 시간: ${DateTime.fromMillisecondsSinceEpoch(sys['sunrise'] * 1000)}'),
                Text('일몰 시간: ${DateTime.fromMillisecondsSinceEpoch(sys['sunset'] * 1000)}'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

}
