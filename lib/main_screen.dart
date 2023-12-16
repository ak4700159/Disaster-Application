import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:test1/sub_screen/community_screen.dart';
import 'package:test1/sub_screen/disaster_screen.dart';
import 'package:test1/sub_screen/manual_screen.dart';
import 'package:test1/sub_screen/setting_screen.dart';
import 'package:test1/tools_and_data/hazard_screen.dart';

import './WeatherScreen.dart';

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

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
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
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);

    return Scaffold(
      body: Column(
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
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "현재 좌표: ${_currentPosition?.latitude}, ${_currentPosition?.longitude}",
              style: const TextStyle(fontSize: 16.0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHazardStick() {
    return const Positioned(
      top: 100,
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
        Marker(
          markerId: const MarkerId("current_position"),
          position: LatLng(
            _currentPosition!.latitude,
            _currentPosition!.longitude,
          ),
          infoWindow: const InfoWindow(title: "현재 위치"),
        ),
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
                    onPressed: () => _navigateToScreen(const SettingsScreen()),
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
