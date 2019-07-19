import 'package:flutter/material.dart';
import 'package:gamepointsflutter/services/settings_service.dart';
import './models/settingsbag.dart';

class Settings extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SettingsState();
  }
}

class SettingsState extends State<Settings> {
  final SettingsService _settingsService = SettingsService();

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SwitchListTile(
        title: Row(children: [
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: Icon(Icons.watch),
          ),
          Text('Use timer'),
        ]),
        value: _settingsService.useTimer,
        onChanged: (bool value) {
          setState(() {
            _settingsService.useTimer = value;
          });
        },
      )
    ]);
  }
}