import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../dumy/setting_dumy.dart';
import '../model/setting_model.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});
  List<Setting> settings = Settings().getSettings();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '설정',
        ),
      ),
      body: ListView.separated(
        itemBuilder: (context, index){
          return ListTile(
            leading: settings[index].settingIcon,
            title: Text(settings[index].title),
            subtitle: Text(settings[index].description),
          );
        },
        separatorBuilder: (context, index) {
          return const Divider();
        },
        itemCount: settings.length,
      ),
    );
  }
}
