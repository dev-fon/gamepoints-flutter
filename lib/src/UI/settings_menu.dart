import 'package:flutter/material.dart';
import 'package:gamepointsflutter/src/UI/gp_themes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsMenu extends StatefulWidget {
  final VoidCallback onTimerToggled;
  final VoidCallback onPastPlayersToggled;
  final VoidCallback onThemeSelected;

  SettingsMenu(
      {Key key,
      this.onTimerToggled,
      this.onPastPlayersToggled,
      this.onThemeSelected});

  @override
  _SettingsMenuState createState() => _SettingsMenuState(
      this.onTimerToggled, this.onPastPlayersToggled, this.onThemeSelected);
}

class _SettingsMenuState extends State<SettingsMenu> {
  bool _useTimer = true;
  bool _usePastPlayers = true;
  Color _selectedThemeAccent;
  List<FloatingActionButton> themeButtons;
  final VoidCallback onTimerToggled;
  final VoidCallback onPastPlayersToggled;
  final VoidCallback onThemeSelected;

  _SettingsMenuState(
      this.onTimerToggled, this.onPastPlayersToggled, this.onThemeSelected);

  @override
  void initState() {
    _loadSettings();
    super.initState();
  }

  _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _useTimer = prefs.getBool('useTimer') ?? true;
      _usePastPlayers = prefs.getBool('usePastPlayers') ?? true;

      var savedThemeColor = prefs.getString('themeColor') ??
          GpThemes.themes[0].accentColor.toString();
      _selectedThemeAccent = GpThemes.themes
          .firstWhere((t) => t.accentColor.toString() == savedThemeColor)
          .accentColor;
    });

    _loadThemes();
  }

  _loadThemes() {
    themeButtons = List<FloatingActionButton>();

    GpThemes.themes.forEach((val) {
      themeButtons.add(FloatingActionButton(
          mini: true,
          onPressed: () {
            setState(() async {
              await _setTheme(val);
              await _loadThemes();
            });
          },
          backgroundColor: val.accentColor,
          child: val.accentColor == _selectedThemeAccent
              ? Icon(Icons.check, color: Colors.white)
              : Container()));
    });
  }

  _setTimer(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setBool('useTimer', value);
      _useTimer = value;
    });

    if (onTimerToggled != null) onTimerToggled();
  }

  _setPrevPlayers(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setBool('usePastPlayers', value);
      _usePastPlayers = value;
    });

    if (onPastPlayersToggled != null) onPastPlayersToggled();
  }

  _setTheme(ThemeData value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setString('themeColor', value.accentColor.toString());
      _selectedThemeAccent = value.accentColor;
    });
    if (onThemeSelected != null) onThemeSelected();
  }

  _createMenuItem(String name, IconData icon, VoidCallback onPressed,
      bool closeMenuAfterPress, BuildContext context) {
    return FlatButton(
      onPressed: () {
        onPressed();
        if (closeMenuAfterPress) Navigator.pop(context);
      },
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: Icon(icon),
          ),
          Text(name),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SwitchListTile(
          activeColor: Theme.of(context).accentColor,
          title: _createMenuItem(
              'Use Timer', Icons.watch, onTimerToggled, false, context),
          value: _useTimer,
          onChanged: (bool value) {
            setState(() {
              _setTimer(value);
            });
          },
        ),
        SwitchListTile(
          activeColor: Theme.of(context).accentColor,
          title: _createMenuItem('Use Past Players', Icons.playlist_add_check,
              onPastPlayersToggled, false, context),
          value: _usePastPlayers,
          onChanged: (bool value) {
            setState(() {
              _setPrevPlayers(value);
            });
          },
        ),
        Row(
          children: themeButtons ?? [Container()],
        )
      ],
    );
  }
}
