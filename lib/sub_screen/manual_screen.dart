import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test1/dumy/manual_dumy.dart';
import '../model/manual_model.dart';

class ManualScreen extends StatefulWidget {
  ManualScreen({super.key});

  @override
  State<ManualScreen> createState() => _ManualScreenState();
}

class _ManualScreenState extends State<ManualScreen> {
  List<Manual> manuals = ManualDumy().getManuals();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('대응 메뉴얼'),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('메뉴얼 검색'),
                    content: Container(
                      width: 300,
                      height: 300,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(10.0),
                            child: TextField(
                              decoration: InputDecoration(
                                labelText: '검색',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            icon: Icon(
              Icons.search,
              size: 40,
            ),
          )
        ],
      ),
      body: ListView.separated(
        itemCount: manuals.length,
        itemBuilder: (context, idx) {
          return ManualTile(manual: manuals[idx]);
        },
        separatorBuilder: (context, idx) {
          return Divider(
            height: 10,
          );
        },
      ),
    );
  }
}
