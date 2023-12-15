import 'package:flutter/material.dart';
import 'package:test1/main_screen.dart';
import 'package:test1/sub_screen/manual_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.network(
              'https://gdb.voanews.com/296c9c73-a5f4-4bc0-bfa3-2f2f28e9889d_w1200_r1.jpg',
              width: MediaQuery.sizeOf(context).width,
              height: MediaQuery.sizeOf(context).height * 0.3,
            ),
            SizedBox(
              height: 50,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.7,
              child: TextField(
                decoration: InputDecoration(
                  label: Text('ID'),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.7,
              child: TextField(
                decoration: InputDecoration(
                  label: Text('PASSWORD'),
                  border: OutlineInputBorder(),
                ),
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
                    onPressed: () {},
                    child: const Text(
                      '로그인',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 17,
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
                    child: Text(
                      '비회원 접속',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 17,
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
            SizedBox(
              height: 140,
            ),
            Row(
              children: [
                Container(
                  height: 40,
                  width: 60,
                  child: FloatingActionButton(
                    backgroundColor: Colors.transparent,
                    shape: const BeveledRectangleBorder(),
                    elevation: 0,
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => ManualScreen()));
                    },
                    child: const Icon(
                      Icons.accessibility,
                      size: 40,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
