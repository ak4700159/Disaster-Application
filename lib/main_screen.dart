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

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Completer<GoogleMapController> _controller = Completer();
  LocationPermission? _locationPermission;
  StreamSubscription<Position>? _positionStreamSubscription;
  Position? _currentPosition;
  bool _isLocationReady = false;
  bool _showCustomMarkers = true;

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Manual findManual(List<Manual> manuals, String? mode) {
    Manual? result;

    for (int idx = 0; idx < manuals.length; idx++) {
      if (manuals[idx].title == mode) {
        result = manuals[idx];
      }
    }
    return result!;
  }

  Widget _buildManualScreen() {
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.1,
      right: 10,
      child: hazardMode != null
          ? Container(
              padding: EdgeInsets.all(10.0),
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
                  onTap: () {},
                  leading: Image.network(
                      findManual(ManualDumy().getManuals(), hazardMode!).image),
                  title: Text(
                    findManual(ManualDumy().getManuals(), hazardMode!).title +
                        '주의!!',
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
          : const Text(
            '이용해주셔서 감사합니다.',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
          ),
    );
  }

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
              if (_showCustomMarkers) ...[
                Marker(
                  markerId: const MarkerId("custom_marker"),
                  position: LatLng(35.8515176, 128.491982), //y좌표, x좌표
                  infoWindow: const InfoWindow(title: "계명대역(지하2층 역사) 대피소"),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueAzure),
                ),
                Marker(
                  markerId: const MarkerId("custom_marker_2"),
                  position: LatLng(35.8632694, 128.490464),
                  infoWindow:
                      const InfoWindow(title: "한화꿈에그린아파트(지하1층 주차장) 대피소"),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueAzure),
                ),
                Marker(
                  markerId: const MarkerId("custom_marker_3"),
                  position: LatLng(35.8530918, 128.478341),
                  infoWindow: const InfoWindow(title: "강창역(지하2층 역사) 대피소"),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueAzure),
                ),
                Marker(
                  markerId: const MarkerId("custom_marker_4"),
                  position: LatLng(35.8537495, 128.474689),
                  infoWindow: const InfoWindow(title: "우방유쉘(지하1층 주차장) 대피소"),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueAzure),
                ),
                Marker(
                  markerId: const MarkerId("custom_marker_5"),
                  position: LatLng(35.8588913, 128.504817),
                  infoWindow: const InfoWindow(title: "서한2차아파트 대피소"),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueAzure),
                ),
                Marker(
                  markerId: const MarkerId("custom_marker_6"),
                  position: LatLng(35.8576148, 128.503841),
                  infoWindow: const InfoWindow(title: "동서서한아파트 대피소"),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueAzure),
                ),
                Marker(
                  markerId: const MarkerId("custom_marker_7"),
                  position: LatLng(35.8556738, 128.504125),
                  infoWindow: const InfoWindow(title: "보성화성아파트 대피소"),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueAzure),
                ),
                Marker(
                  markerId: const MarkerId("custom_marker_8"),
                  position: LatLng(35.8540803, 128.500398),
                  infoWindow: const InfoWindow(title: "청남타운 대피소"),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueAzure),
                ),
                Marker(
                  markerId: const MarkerId("custom_marker_9"),
                  position: LatLng(35.8524038, 128.500422),
                  infoWindow: const InfoWindow(title: "대백창신한라아파트 대피소"),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueAzure),
                ),
              ],
            },
          )
        : const Center(child: CircularProgressIndicator());
  }

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
                    Container(
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
                Container(
                  height: 40,
                  width: 40,
                  child: FloatingActionButton(
                    heroTag: 'but6',
                    onPressed: () {
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
            SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 10), // 추가된 간격 조정
                Container(
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
                Container(
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
                Container(
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
                Container(
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
                SizedBox(
                  width: 25,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

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
}
