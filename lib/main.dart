import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:test1/sub_screen/login_screen.dart';

import 'WeatherScreen.dart';

// 커뮤니티 들어갈 수 있는지 권환 확인
bool communityPermission = false;
// 어플의 주요 기능을 당담하는 위험도 비율
double hazardRate = 0;
// 밑에 변수는 우리가 임의로 날씨 온도를 지정해 테스트할 수 있는 환경 구축
double temperatureInKelvin = 0;
// 어떤 조건에서 위허몯가 결정되냐에 따라 위험도 모드가 정해지고
// 그에 맞는 대응 메뉴얼을 띄울 때 사용
String? hazardMode;
double testTemperature = 40;

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

// 토스트 하수 밑에 문자 메시지를 보여주는 역할
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

