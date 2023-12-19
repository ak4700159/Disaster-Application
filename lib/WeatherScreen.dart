import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:test1/main.dart';

// 기상 api 가져오기
class HttpHelper {
  final String domain = 'api.openweathermap.org';
  final String path = 'data/2.5/weather';
  final String apiKey = 'ca47ef2434b9b55eb7b7706137a15f1f';

  Future<Map<String, dynamic>> getWeather(String location) async {
    Map<String, dynamic> parameters = {'q': location, 'appid': apiKey};
    Uri uri = Uri.https(domain, path, parameters);
    http.Response response = await http.get(uri);

    if (response.statusCode == 200) {
      Map<String, dynamic> result = json.decode(response.body);
      return result;
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}

// 좌측 상단에 온도 표시 및 터치 시 상세 날씨 정보 확인 가능
// 지도 위에 표시됨
class WeatherScreen extends StatefulWidget {
  const WeatherScreen({Key? key}) : super(key: key);

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  String result = ' ';
  double temperatureInCelsius = 0.0;
  Map<String, dynamic> weatherResult = {};

  @override
  void initState() {
    super.initState();
    getWeatherData();

    // 타이머 설정
    const Duration updateInterval = Duration(minutes: 3); //3분마다 업데이트
    Timer.periodic(updateInterval, (Timer t) => getWeatherData());
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 10,
      child: GestureDetector(
        onTap: () {
          _showWeatherDetails(weatherResult);
        },
        child: Container(
          padding: const EdgeInsets.all(10.0),
          color: Colors.transparent,
          child: Row(
            children: [
              SizedBox(
                width: 20,
              ),
              const Icon(
                Icons.sunny,
                size: 40,
              ),
              Text(
                '온도: ${temperatureInCelsius.toStringAsFixed(2)} °C',
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void getWeatherData() async {
    HttpHelper helper = HttpHelper();

    try {
      // 자동적으로
      weatherResult = await helper.getWeather('daegu');
      setState(() {
        temperatureInKelvin = weatherResult['main']['temp'];
        temperatureInCelsius = temperatureInKelvin - 273.15;
        temperatureInCelsius = -15;
      });
    } catch (e) {
      print('Error: $e');
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
