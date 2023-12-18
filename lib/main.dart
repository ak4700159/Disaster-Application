import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:test1/sub_screen/login_screen.dart';

bool communityPermission = false;
double hazardRate = 0;
double temperatureInKelvin = 0;
String? hazardMode;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
  runApp(
    const MaterialApp(
      home: LoginScreen(),
      debugShowCheckedModeBanner: false, // 디버그 표시 비활성화
    ),
  );
}

void showToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 5,
    backgroundColor: Colors.transparent,
    textColor: Colors.black,
    fontSize: 14,
  );
}
