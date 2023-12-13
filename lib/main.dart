import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:flutter/services.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "GoogleMap",
      home: GoogleMapPage(),
    );
  }
}


class GoogleMapPage extends StatefulWidget {
  const GoogleMapPage({Key? key}) : super(key: key);
  @override
  _GoogleMapPageState createState() => _GoogleMapPageState();
}

class _GoogleMapPageState extends State<GoogleMapPage> {
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
    // 상태바의 높이 확인
    var statusBarHeight = MediaQuery.of(context).padding.top;
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
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
                _buildLocationButtons(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "현재 좌표: ${_currentPosition?.latitude}, ${_currentPosition?.longitude}",
              style: TextStyle(fontSize: 16.0),
            ),
          ),
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
          markerId: MarkerId("current_position"),
          position: LatLng(
            _currentPosition!.latitude,
            _currentPosition!.longitude,
          ),
          infoWindow: InfoWindow(title: "현재 위치"),
        ),
      },
    )
        : Center(child: CircularProgressIndicator());
  }


  Widget _buildLocationButtons() {
    return Positioned(
      bottom: MediaQuery.of(context).size.height * 0.02,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(5.0),
        child: Column(
          children: [
            Row(
              children: [
                FloatingActionButton(
                  heroTag: 'but5',
                  onPressed: _moveToCurrentLocation,
                  child: const Icon(Icons.my_location),
                ),
              ],
            ),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FloatingActionButton(
                  heroTag: 'but1',
                  onPressed: () => _navigateToScreen(Screen1()),
                  child: const Icon(Icons.one_k),
                ),
                FloatingActionButton(
                  heroTag: 'but2',
                  onPressed: () => _navigateToScreen(Screen2()),
                  child: const Icon(Icons.two_k),
                ),
                FloatingActionButton(
                  heroTag: 'but3',
                  onPressed: _moveToCurrentLocation,
                  child: const Icon(Icons.settings),
                ),
                FloatingActionButton(
                  heroTag: 'but4',
                  onPressed: _moveToCurrentLocation,
                  child: const Icon(Icons.access_alarm_outlined),
                ),
                SizedBox(width: 25,),
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


class Screen1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('화면 1')),
      body: Center(child: Text('이것은 화면 1입니다')),
    );
  }
}


class Screen2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('화면 2')),
      body: Center(child: Text('이것은 화면 2입니다')),
    );
  }
}

