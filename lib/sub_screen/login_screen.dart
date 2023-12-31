import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test1/main.dart';
import 'package:test1/main_screen.dart';
import 'package:test1/sub_screen/manual_screen.dart';
import 'package:test1/sub_screen/setting_screen.dart';

// 맨 처음은 어플 키면 맞이하는 화면
// 아직 회원가입, 아이디, 비밀번호 찾기는 미구현 ( 로그인 데이터 베이스 미구현 )
// ID : 5645164 / passwd : 123456789 입력 시 로그인 가능
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? id;
  String? passwd;
  TextEditingController idController = TextEditingController();
  TextEditingController passwdController = TextEditingController();

  @override
  void dispose() {
    idController.dispose();
    passwdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
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
                    Navigator.pop(context);
                  },
                  child: const Text('취소'),
                ),
                TextButton(
                  onPressed: () {
                    SystemNavigator.pop();
                  },
                  child: const Text('종료'),
                ),
              ],
            );
          },
        );
        return Future(() => false);
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.network(
                'https://gdb.voanews.com/296c9c73-a5f4-4bc0-bfa3-2f2f28e9889d_w1200_r1.jpg',
                width: MediaQuery.sizeOf(context).width,
                height: MediaQuery.sizeOf(context).height * 0.3,
              ),
              const Text(
                'Endless',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50),
              ),
              Container(
                padding: const EdgeInsets.only(bottom: 10),
                child: const Text(
                  ': predicted Disaster',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: TextField(
                  controller: idController,
                  decoration: const InputDecoration(
                    label: Text('ID'),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: TextFormField(
                  controller: passwdController,
                  decoration: const InputDecoration(
                    label: Text('PASSWORD'),
                    border: OutlineInputBorder(),
                    hintText: '비밀번호를 입력하세요.',
                  ),
                  obscureText: true,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextButton(
                      style: const ButtonStyle(
                        fixedSize: MaterialStatePropertyAll<Size?>(Size(120, 50)),
                        backgroundColor:
                            MaterialStatePropertyAll<Color?>(Colors.blue),
                      ),
                      onPressed: () {
                        if (idController.text == '5645164' &&
                            passwdController.text == '123456789') {
                          idController.text = '';
                          passwdController.text = '';
                          showToast('로그인 성공');
                          communityPermission = true; // 커뮤니티 접속 권환 획득
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const MainScreen()),
                          );
                        } else {
                          idController.text = '';
                          passwdController.text = '';
                          showToast('로그인 실패');
                        }
                      },
                      child: const Text(
                        '로그인',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextButton(
                      style: const ButtonStyle(
                        fixedSize: MaterialStatePropertyAll<Size?>(Size(120, 50)),
                        backgroundColor:
                            MaterialStatePropertyAll<Color?>(Colors.orange),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MainScreen()));
                      },
                      child: const Text(
                        '비회원 접속',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: Text('회원가입'),
                  ),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: Text('아이디 찾기'),
                  ),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: Text('비밀번호 찾기'),
                  ),
                ],
              ),
              const SizedBox(
                height: 80,
              ),
              // 지도맵에 있는 버튼 대응메뉴얼 확인 버튼, 환경 설정 버튼
              // 원래는 환경 설정 버튼 대신 대피소 위치 표시 화면 구성할 예정이었음
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 5.0),
                    height: 40,
                    width: 60,
                    child: FloatingActionButton(
                      heroTag: 'Bt6',
                      backgroundColor: Colors.transparent,
                      shape: const BeveledRectangleBorder(),
                      elevation: 0,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ManualScreen()));
                      },
                      child: const Icon(
                        Icons.accessibility,
                        size: 50,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 5.0),
                    height: 40,
                    width: 60,
                    child: FloatingActionButton(
                      heroTag: 'Bt7',
                      backgroundColor: Colors.transparent,
                      shape: const BeveledRectangleBorder(),
                      elevation: 0,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SettingsScreen()));
                      },
                      child: const Icon(
                        Icons.settings,
                        size: 50,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
