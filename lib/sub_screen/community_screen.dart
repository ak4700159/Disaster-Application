import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


// 커뮤니티 화면만 구현
// 기능들은 동작 X
// 커뮤니티 권한을 이용해 화면 진입 못하게 하는 기능도 아직 미구현
class Screen1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('커뮤니티 - 미구현'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.chat),
            onPressed: () {
              // 채팅 버튼이 눌렸을 때의 동작 추가
              // 예: Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen()));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Board(title: '실시간 재난 현황/뉴스'),
          ),
          Expanded(
            child: Board(title: '실시간 핫픽'),
          ),
          // "지역별 게시판"으로 이동하는 버튼 추가
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: ElevatedButton(
              onPressed: () {
                // "지역별 게시판" 버튼이 눌렸을 때의 동작 추가
                // 예: Navigator.push(context, MaterialPageRoute(builder: (context) => LocalCommunityBoard()));
                // 여기서 LocalCommunityBoard는 지역별 게시판을 나타내는 페이지로 교체해야 합니다.
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50), // 버튼의 최소 크기를 지정
              ),
              child: Text('지역별 게시판'),
            ),
          ),
        ],
      ),
    );
  }
}

class Board extends StatelessWidget {
  final String title;

  const Board({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 5, // 실제 게시물 수로 교체하세요
              itemBuilder: (context, index) {
                // 실제 게시물 데이터로 교체하세요
                String postTitle = '게시물 $index';
                String postContent = '이것은 게시물 $index 내용의 일부입니다.';
                String postTime = '게시 시간: ${DateTime.now()}';
                String author = '글쓴이 $index';

                return ListTile(
                  title: Text(postTitle),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(postContent),
                      Text(postTime),
                      Text('글쓴이: $author'),
                    ],
                  ),
                );
              },
            ),
          ),

          // "더 보기" 버튼 추가
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                // "더 보기" 버튼이 눌렸을 때의 동작 추가
                // 예: 더 많은 게시물을 로드하거나 다른 화면으로 이동
              },
              child: Text('더 보기'),
            ),
          ),
        ],
      ),
    );
  }
}
