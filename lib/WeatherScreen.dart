import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 10,
      left: 10,
      child: GestureDetector(
        onTap: () {
          _showWeatherDetails(weatherResult);
        },
        child: Container(
          padding: const EdgeInsets.all(10.0),
          color: Colors.blue,
          child: Text(
            '온도: ${temperatureInCelsius.toStringAsFixed(2)} °C',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  void getWeatherData() async {
    HttpHelper helper = HttpHelper();

    try {
      weatherResult = await helper.getWeather('daegu');
      setState(() {
        double temperatureInKelvin = weatherResult['main']['temp'];
        temperatureInCelsius = temperatureInKelvin - 273.15;
      });
    } catch (e) {
      print('Error: $e');
      // Handle the error gracefully, e.g., show an error message to the user.
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

        return AlertDialog(
          title: Text('지역 : ${weatherResult['name']}'), //지역
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('온도: ${temperatureInCelsius.toStringAsFixed(2)} °C'),
                Text('날씨: ${weather['description']}'),
                Text('최저 온도: ${main['temp_min']} °C'),
                Text('최고 온도: ${main['temp_max']} °C'),
                Text('습도: ${main['humidity']}%'),
                Text('기압: ${main['pressure']} hPa'),
                Text('풍속: ${wind['speed']} m/s'),
                //Text('City: ${weatherResult['name']}'),
                //Text('Country: ${sys['country']}'),
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
