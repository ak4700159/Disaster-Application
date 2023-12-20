import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:test1/dumy/manual_dumy.dart';
import 'package:test1/main.dart';
import 'package:test1/sub_screen/community_screen.dart';
import 'package:test1/sub_screen/disaster_screen.dart';
import 'package:test1/sub_screen/login_screen.dart';
import 'package:test1/sub_screen/manual_screen.dart';
import 'package:test1/sub_screen/setting_screen.dart';
import 'package:test1/sub_screen/hazard_screen.dart';
import 'WeatherScreen.dart';
import 'model/manual_model.dart';
import 'package:test1/dumy/custom_markers.dart';

// 메인 스크린 : 로그인 화면에서 회원 로그인 or 비회원 접속을 통해 넘어가지는 화면.
class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final TextEditingController _testController = TextEditingController();
  final Completer<GoogleMapController> _controller = Completer();
  LocationPermission? _locationPermission;
  StreamSubscription<Position>? _positionStreamSubscription;
  double temperatureInCelsius = 0;
  late Map<String, dynamic> weatherResult;
  Position? _currentPosition;
  bool _isLocationReady = false;
  bool _showCustomMarkers = true;
  bool _isManualReady = false;
  Manual? nowManual;

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
    getWeatherData();
    Future.delayed(const Duration(seconds: 2), () {
      _isManualReady = true;
      nowManual = findManual(ManualDumy().getManuals(), hazardMode!);
      setState(() {});
    });
    const Duration updateInterval = Duration(minutes: 3); //3분마다 업데이트
    Timer.periodic(updateInterval, (Timer t) => getWeatherData());
  }

  void _toggleCustomMarkers() {
    setState(() {
      _showCustomMarkers = !_showCustomMarkers;
    });
  }

  void _checkLocationPermission() async {
    _locationPermission = await Geolocator.checkPermission();
    if (_locationPermission == LocationPermission.denied) {
      _locationPermission = await Geolocator.requestPermission();
    }
    if (_locationPermission == LocationPermission.denied) {
      return;
    }
    _positionStreamSubscription = Geolocator.getPositionStream().listen(
      (Position position) {
        setState(() {
          _currentPosition = position;
          _isLocationReady = true;
        });
      },
    );
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    _testController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var statusBarHeight = MediaQuery.of(context).padding.top;
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);

    return Scaffold(
      body: WillPopScope(
        onWillPop: () {
          showDialog(
            context: context,
            builder: (BuildContext buildContext) {
              return AlertDialog(
                content: Container(
                  width: 100,
                  height: 30,
                  child: const Center(
                    child: Text(
                      '나가시겠습니까?',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                      );
                    },
                    child: const Text('로그인창'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('취소'),
                  ),
                  TextButton(
                    onPressed: () {
                      SystemNavigator.pop();
                    },
                    child: Text('종료'),
                  ),
                ],
              );
            },
          );
          return Future(() => false);
        },
        child: Column(
          children: [
            Container(
              height: statusBarHeight,
              color: Colors.transparent,
            ),
            Expanded(
              child: Stack(
                children: [
                  _buildGoogleMap(),
                  _buildHazardStick(),
                  _buildLocationButtons(),
                  WeatherScreen(), // WeatherScreen을 맨 위로 이동
                  _buildManualScreen(),
                  _buildTestBox(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestBox() {
    return Positioned(
      right: 10,
      top: 10,
      child: Container(
        child: Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.3,
              child: TextField(
                decoration: const InputDecoration(
                  hintText: '온도 테스트',
                  hintStyle: TextStyle(fontSize: 10),
                ),
                controller: _testController,
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.2,
              child: OutlinedButton(
                onPressed: () {
                  testTemperature = double.parse(_testController.text);
                  didUpdateWidget(const MainScreen());
                  _testController.text = '';
                },
                child: const Text(
                  'Update',
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 모드에 따른 메뉴얼 탐색 하는 함수
  Manual findManual(List<Manual> manuals, String? mode) {
    Manual? result;
    for (int idx = 0; idx < manuals.length; idx++) {
      if (manuals[idx].title == mode) {
        result = manuals[idx];
      }
    }
    return result!;
  }

  // 모드에 따라 적용되는 대응 메뉴얼 - 지도맵 위에 표시
  Widget _buildManualScreen() {
    return !_isManualReady
        ? Positioned(
            top: MediaQuery.of(context).size.height * 0.1,
            right: 10,
            child: const Center(
              child: Icon(Icons.rotate_right_rounded),
            ))
        : Positioned(
            top: MediaQuery.of(context).size.height * 0.1,
            right: 10,
            child: hazardMode != null && nowManual != null
                ? Container(
                    padding: const EdgeInsets.all(10.0),
                    width: 250,
                    height: 80,
                    decoration: ShapeDecoration(
                      shape: Border.all(
                        width: 2.0,
                        color: Colors.red,
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: ListTile(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(nowManual!.title),
                                content: SizedBox(
                                  width: 300,
                                  height: 300,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: <Widget>[
                                        Image.network(nowManual!.image),
                                        Text(nowManual!.description),
                                        Row(
                                          children: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                                nowManual = null;
                                              },
                                              child: Text('팝업 삭제'),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        leading: Image.network(nowManual!.image),
                        title: Text(
                          nowManual!.title + '주의!!',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: const Text(
                          '대피 요령 확인하기',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  )
                : SizedBox(
                    width: 150,
                    height: 70,
                    child: Column(
                      children: [
                        Image.network(
                            'https://tse1.mm.bing.net/th?id=OIP.1fX9pb6ZCOXSE26sG5E5_gHaCg&pid=Api&P=0&h=220'),
                        const Text(
                          '광고 위치',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 10),
                        ),
                      ],
                    ),
                  ));
  }

  // 위험도 막대
  Widget _buildHazardStick() {
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.1,
      left: 10,
      child: Column(
        children: [
          HazardScreen(),
        ],
      ),
    );
  }

  // 구글맵 - 대피소 포함
  Widget _buildGoogleMap() {
    return _isLocationReady
        ? GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: LatLng(
                _currentPosition!.latitude,
                _currentPosition!.longitude,
              ),
              zoom: 15.0,
            ),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            myLocationEnabled: false,
            markers: {
              if (_currentPosition != null)
                Marker(
                  markerId: const MarkerId("current_position"),
                  position: LatLng(
                    _currentPosition!.latitude,
                    _currentPosition!.longitude,
                  ),
                  infoWindow: const InfoWindow(title: "현재 위치"),
                ),
              if (_showCustomMarkers) ..._buildCustomMarkers(),
            },
          )
        : const Center(child: CircularProgressIndicator());
  }

  // 대피서 위치를 받아와 지도에 표시
  List<Marker> _buildCustomMarkers() {
    List<Marker> markers = [];

    for (CustomMarkerInfo info in customMarkers) {
      markers.add(
        Marker(
          markerId: MarkerId(info.markerId),
          position: info.position,
          infoWindow: InfoWindow(
            title: info.title,
            snippet: info.info,
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(240.0),
        ),
      );
    }
    return markers;
  }

  // 지도 위에 띄워져 있는 모든 버튼들
  Widget _buildLocationButtons() {
    return Positioned(
      left: 10, // 왼쪽 여백 추가
      bottom: MediaQuery.of(context).size.height * 0.02,
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: 40,
                  width: 40,
                  child: FloatingActionButton(
                    heroTag: 'but5',
                    onPressed: _moveToCurrentLocation,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    shape: const BeveledRectangleBorder(),
                    child: const Icon(
                      Icons.my_location,
                      size: 30,
                      color: Colors.red,
                    ),
                  ),
                ),
                Row(
                  children: [
                    SizedBox(
                      height: 40,
                      width: 40,
                      child: FloatingActionButton(
                        heroTag: 'bbt',
                        onPressed: _toggleCustomMarkers,
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        shape: const BeveledRectangleBorder(),
                        child: const Icon(
                          Icons.visibility,
                          size: 30,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 40,
                  width: 40,
                  child: FloatingActionButton(
                    heroTag: 'but6',
                    onPressed: () {
                      if (hazardMode != null) {
                        nowManual =
                            findManual(ManualDumy().getManuals(), hazardMode!);
                      }
                      setState(() {});
                    },
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    shape: const BeveledRectangleBorder(),
                    child: const Icon(
                      Icons.rotate_left_outlined,
                      size: 30,
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(width: 10), // 추가된 간격 조정
                SizedBox(
                  height: 40,
                  width: 60,
                  child: FloatingActionButton(
                    backgroundColor: Colors.transparent,
                    shape: const BeveledRectangleBorder(),
                    elevation: 0,
                    heroTag: 'but1',
                    onPressed: () => _navigateToScreen(Screen1()),
                    child: const Icon(
                      Icons.account_balance,
                      size: 40,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                  width: 60,
                  child: FloatingActionButton(
                    backgroundColor: Colors.transparent,
                    shape: const BeveledRectangleBorder(),
                    elevation: 0,
                    heroTag: 'but2',
                    onPressed: () => _navigateToScreen(ManualScreen()),
                    child: const Icon(
                      Icons.accessibility,
                      size: 40,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                  width: 60,
                  child: FloatingActionButton(
                    backgroundColor: Colors.transparent,
                    shape: const BeveledRectangleBorder(),
                    elevation: 0,
                    heroTag: 'but3',
                    onPressed: () => _navigateToScreen(SettingsScreen()),
                    child: const Icon(
                      Icons.settings,
                      size: 40,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                  width: 60,
                  child: FloatingActionButton(
                    backgroundColor: Colors.transparent,
                    shape: const BeveledRectangleBorder(),
                    elevation: 0,
                    heroTag: 'but4',
                    onPressed: () => _navigateToScreen(const DisasterScreen()),
                    child: const Icon(
                      Icons.access_alarm_outlined,
                      size: 40,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 25,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 메인 스크린 내장 함수들
  void _navigateToScreen(Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  void _moveToCurrentLocation() {
    if (_controller.isCompleted) {
      _controller.future.then((controller) {
        controller.animateCamera(CameraUpdate.newLatLng(
          LatLng(
            _currentPosition!.latitude,
            _currentPosition!.longitude,
          ),
        ));
      });
    }
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
    temperatureInCelsius = testTemperature;
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
}
