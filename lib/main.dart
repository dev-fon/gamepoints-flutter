import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';

import './models/player.dart';
import './simple_list.dart';
import './card_list.dart';
import './menu.dart';

const DEFAULT_TIMER_VALUE = 120;

void main() {
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
      primarySwatch: Colors.blueGrey,
    ),
  ));
}

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  final TextEditingController controller = TextEditingController();
  final List<Player> _players = [];
  bool _entryToggle = true;
  bool _isButtonEnabled = false;
  bool _isStartGameButtonEnabled = false;
  bool _useTimer = false;
  bool _usePastPlayers = true;
  int _maxTimerValue = DEFAULT_TIMER_VALUE;
  int _currentTimerValue = 0;
  Stopwatch _stopwatch = Stopwatch();
  AudioPlayer audioPlayer;
  Timer _timer;
  List<String> _previouslyAddedPlayers = [];
  int _maxPrevPlayers = 9;

  addPlayer(String name) {
    if (name.length > 0) {
      setState(() {
        _players.add(Player(name: name, points: 0));
      });
    }

    controller.text = '';
    _isButtonEnabled = false;
  }

  @override
  void initState() {
    _loadTimer();
    _loadPrevPlayers();

    super.initState();
  }

  @override
  void dispose() {
    _stopwatch?.stop();
    super.dispose();
  }

  _loadTimer() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _useTimer = prefs.getBool('useTimer') ?? true;

      if (_useTimer)
        _timer = new Timer.periodic(new Duration(seconds: 1), refreshUi);
    });
  }

  _loadPrevPlayers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _usePastPlayers = prefs.getBool('usePastPlayers') ?? true;

      _previouslyAddedPlayers =
          prefs.getStringList('previouslyAddedPlayers') ?? [];

      if (_usePastPlayers) {
        _previouslyAddedPlayers
            .forEach((playerName) => _addIfNotFound(playerName));
      } else {
        prefs.setStringList('previouslyAddedPlayers', []);
      }

      _toggleStartGameButtonEnableState();
    });
  }

  _addIfNotFound(String playerName) {
    if (!_players.contains(playerName))
      _players.add(Player(name: playerName, points: 0));
  }

  refreshUi(Timer timer) {
    setState(() {
      if (!_useTimer) {
        return;
      }

      _currentTimerValue = _maxTimerValue - _stopwatch.elapsed.inSeconds;

      if (_stopwatch.elapsed.inSeconds >= _maxTimerValue) {
        print("here");
        _currentTimerValue = 0;
        _stopwatch.stop();
        _stopwatch.reset();
        play();
        _timer.cancel();
        stop();
      }
    });
  }

  Future play() async {
    audioPlayer = await AudioCache().play("air-horn_1.mp3");
  }

  Future stop() async {
    await audioPlayer.stop();
  }

  _toggleStartGameButtonEnableState() {
    setState(() {
      _players.length > 0
          ? _isStartGameButtonEnabled = true
          : _isStartGameButtonEnabled = false;
    });
  }

  startTimer() {
    setState(() {
      _currentTimerValue = _maxTimerValue;
      _stopwatch.reset();

      if (!_stopwatch.isRunning) _stopwatch.start();

      if (_useTimer)
        _timer = new Timer.periodic(new Duration(seconds: 1), refreshUi);
    });
  }

  savePlayersToDisk() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    for (var player in _players) {
      if (!_previouslyAddedPlayers.contains(player.name))
        _previouslyAddedPlayers.add(player.name);
    }

    var sublistLen = _previouslyAddedPlayers.length <= _maxPrevPlayers
        ? _previouslyAddedPlayers.length
        : _maxPrevPlayers;
    prefs.setStringList('previouslyAddedPlayers',
        _previouslyAddedPlayers.sublist(0, sublistLen));
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Duplicate Player"),
          content: Text("Enter a unique player name"),
          actions: <Widget>[
            FlatButton(
              child: Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("GamePoints"),
        actions: [
          _useTimer && !_entryToggle
              ? FlatButton(
                  textColor: Colors.white,
                  padding: EdgeInsets.all(10),
                  child: Text("$_currentTimerValue sec",
                      style: TextStyle(fontSize: 30)),
                  onPressed: () {
                    startTimer();
                  },
                )
              : Container()
        ],
      ),
      drawer: Drawer(
          child: ListView(
        children: [
          Container(
            height: 50.0,
            child: DrawerHeader(
              child: Text('Menu'),
            ),
          ),
          Menu(
            onTimerToggled: () {
              setState(() {
                _loadTimer();
              });
            },
            onAddPlayerPressed: () {
              setState(() {
                _entryToggle = true;
                _toggleStartGameButtonEnableState();
              });
            },
            onDeleteAllPressed: () {
              setState(() {
                _players.clear();
                _entryToggle = true;
                _toggleStartGameButtonEnableState();
              });
            },
            onClearPointsPressed: () {
              setState(() {
                for (var player in _players) {
                  player.points = 0;
                }

                startTimer();
              });
            },
            onPastPlayersToggled: () {
              setState(() {
                _loadPrevPlayers();
              });
            },
          ),
        ],
      )),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Visibility(
                  visible: _entryToggle,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Enter a player's name..."),
                          maxLines: null,
                          autofocus: true,
                          onChanged: (value) {
                            setState(() {
                              value.length > 0
                                  ? _isButtonEnabled = true
                                  : _isButtonEnabled = false;
                              if (value.length > 0 && value.contains("\n")) {
                                addPlayer(value.trim());
                                _toggleStartGameButtonEnableState();
                              }
                            });
                          },
                          controller: controller,
                          textCapitalization: TextCapitalization.words,
                          textInputAction: TextInputAction.newline,
                        ),
                        RaisedButton(
                            child: Icon(Icons.add),
                            onPressed: _isButtonEnabled
                                ? () {
                                    setState(() {
                                      if (_players.any(
                                          (p) => p.name == controller.text)) {
                                        _showDialog();
                                      } else {
                                        addPlayer(controller.text);
                                        _toggleStartGameButtonEnableState();
                                      }
                                    });
                                  }
                                : null),
                        RaisedButton(
                            child: Text('Start Game'),
                            onPressed: _isStartGameButtonEnabled
                                ? () {
                                    setState(() {
                                      _entryToggle = false;
                                      startTimer();
                                      savePlayersToDisk();
                                    });
                                  }
                                : null),
                      ])),
              _players.length > 0
                  ? Expanded(
                      child: _entryToggle
                          ? SimpleList(
                              players: _players,
                              onDeletePressed: () {
                                setState(() {
                                  _toggleStartGameButtonEnableState();
                                });
                              },
                            )
                          : CardList(
                              players: _players,
                              onPointsChanged: () {
                                setState(() {
                                  startTimer();
                                });
                              },
                            ),
                    )
                  : Text("")
            ],
          ),
        ),
      ),
    );
  }
}
