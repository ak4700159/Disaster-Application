import 'package:flutter/material.dart';

import 'main.dart';

// 좌측 상단에 온도 표시 및 터치 시 상세 날씨 정보 확인 가능
// 지도 위에 표시됨

class WeatherScreen extends StatefulWidget {
  WeatherScreen({Key? key, required this.weatherResult}) : super(key: key);
  Map<String, dynamic> weatherResult;

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  double temperatureInCelsius = 0; // 테스트 문구

  @override
  void didUpdateWidget(covariant WeatherScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    //weatherResult = widget.weatherResult;
    if (widget.weatherResult != oldWidget.weatherResult) {
      updateTemperature();
    }

  }

  void updateTemperature() {
    double temperatureInKelvin = widget.weatherResult['main']['temp'];
    setState(() {
      temperatureInCelsius = temperatureInKelvin - 273.15;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 10,
      child: GestureDetector(
        onTap: () {
          _showWeatherDetails(widget.weatherResult);
        },
        child:Container(
                padding: const EdgeInsets.all(10.0),
                color: Colors.transparent,
                child: Row(
                  children: [
                    const SizedBox(
                      width: 20,
                    ),
                    selectWeatherIcon(widget.weatherResult['weather'][0]),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      '온도: ${temperatureInCelsius.toStringAsFixed(2)} °C',
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  void _showWeatherDetails(Map<String, dynamic> weatherResult) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        var main = weatherResult['main'];
        var weather = weatherResult['weather'][0];
        var wind = weatherResult['wind'];
        var sys = weatherResult['sys'];

        double feelsLikeInKelvin = main['feels_like'];
        double temperatureInKelvin = weatherResult['main']['temp'];
        temperatureInCelsius = temperatureInKelvin - 273.15;
        //temperatureInCelsius = testTemperature; // 테스트 문구

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
                Text('습도: ${main['humidity']}%'),
                Text('기압: ${main['pressure']} hPa'),
                Text('풍향: ${wind['deg']}°'), // 풍향 정보 추가
                Text('풍속: ${wind['speed']} m/s'),
                Text(
                    '일출 시간: ${DateTime.fromMillisecondsSinceEpoch(sys['sunrise'] * 1000)}'),
                Text(
                    '일몰 시간: ${DateTime.fromMillisecondsSinceEpoch(sys['sunset'] * 1000)}'),
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
