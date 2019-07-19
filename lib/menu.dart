import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Menu extends StatefulWidget {
  final VoidCallback onTimerToggled;
  final VoidCallback onPastPlayersToggled;
  final VoidCallback onDeleteAllPressed;
  final VoidCallback onClearPointsPressed;
  final VoidCallback onAddPlayerPressed;

  Menu({
    Key key,
    this.onTimerToggled,
    this.onPastPlayersToggled,
    this.onDeleteAllPressed,
    this.onClearPointsPressed,
    this.onAddPlayerPressed
  });

  @override
  State<StatefulWidget> createState() {
    return MenuState(this.onTimerToggled, this.onPastPlayersToggled, this.onDeleteAllPressed,
        this.onClearPointsPressed, this.onAddPlayerPressed);
  }
}

class MenuState extends State<Menu> {
  bool _useTimer = true;
  bool _usePastPlayers = true;
  final VoidCallback onTimerToggled;
  final VoidCallback onPastPlayersToggled;
  final VoidCallback onDeleteAllPressed;
  final VoidCallback onClearPointsPressed;
  final VoidCallback onAddPlayerPressed;

  MenuState(this.onTimerToggled, this.onPastPlayersToggled, this.onDeleteAllPressed,
      this.onClearPointsPressed, this.onAddPlayerPressed);

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _useTimer = prefs.getBool('useTimer') ?? true;
      _usePastPlayers = prefs.getBool('usePastPlayers') ?? true;
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
    return Column(children: [
      SwitchListTile(
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
        title: _createMenuItem(
            'Use Past Players', Icons.playlist_add_check, onPastPlayersToggled, false, context),
        value: _usePastPlayers,
        onChanged: (bool value) {
          setState(() {
            _setPrevPlayers(value);
          });
        },
      ),
      _createMenuItem(
          'Add', Icons.group_add, onAddPlayerPressed, true, context),
      _createMenuItem(
          'Clear points', Icons.refresh, onClearPointsPressed, true, context),
      _createMenuItem(
          'Delete all', Icons.delete_forever, onDeleteAllPressed, true, context)
    ]);
  }
}
