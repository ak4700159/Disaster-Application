import 'package:flutter/material.dart';

import '../model/setting_model.dart';

// 옵션 더미
class Settings {
  List<Setting> settings = [
    Setting(
      title: '환경 설정',
      description: '어플 환경 설정',
      settingIcon: Icon(Icons.settings, size: 40,),
    ),
    Setting(
      title: '셀터 on/off',
      description: '지도에 보는 피난처 위치를 끄고 킬 수 있습니다.',
      settingIcon: Icon(Icons.night_shelter, size: 40,),
    ),
    Setting(
      title: '알림 설정',
      description: '어플 외부에 발생되는 알림 설정',
      settingIcon: Icon(Icons.alarm, size: 40,),
    ),
  ];

  List<Setting> getSettings() {
    return settings;
  }
}
