import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';

import '../src/models/player.dart';
import '../src/ui/player_list.dart';
import '../src/ui/card_list.dart';
import '../src/ui/menu.dart';
import '../src/ui/gp_themes.dart';
import 'blocs/player_bloc/player_bloc.dart';
import 'blocs/player_bloc/player_state.dart';

const DEFAULT_TIMER_VALUE = 120;

class App extends StatefulWidget {
  static final navKey = new GlobalKey<NavigatorState>();
  @override
  AppState createState() => AppState();
}

class AppState extends State<App> with WidgetsBindingObserver {
  final TextEditingController controller = TextEditingController();
  final _playerBloc = PlayerBloc();
  bool _entryToggle = true;
  bool _isButtonEnabled = false;
  bool _useTimer = false;
  bool _usePastPlayers = true;
  int _maxTimerValue = DEFAULT_TIMER_VALUE;
  int _currentTimerValue = 0;
  Stopwatch _stopwatch = Stopwatch();
  AudioPlayer audioPlayer;
  Timer _timer;
  ThemeData selectedTheme;
  List<String> _previouslyAddedPlayers = [];
  int _maxPrevPlayers = 9;

  @override
  void initState() {
    super.initState();
    _loadTheme();
    _loadTimer();
    _loadPrevPlayers();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      case AppLifecycleState.suspending:
        _stopwatch?.stop();
        break;
      case AppLifecycleState.resumed:
        _stopwatch?.start();
    }
  }

  @override
  void dispose() {
    _stopwatch?.stop();
    _playerBloc.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  addPlayer(String name) {
    if (name.length > 0) {
      _playerBloc.addPlayer(Player(name: name, points: 0));
    }

    controller.text = '';
    _isButtonEnabled = false;
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
            .forEach((playerName) => _addIfNotFound(playerName, _playerBloc.currentState.players));
      } else {
        prefs.setStringList('previouslyAddedPlayers', []);
      }
    });
  }

  _loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      String themeColor = prefs.getString('themeColor') ??
          GpThemes.themes[0].accentColor.toString();
      selectedTheme = GpThemes.themes
          .firstWhere((t) => t.accentColor.toString() == themeColor);
    });
  }

  _addIfNotFound(String playerName, List<Player> players) {
    if (!players.contains(playerName))
      _playerBloc.addPlayer(Player(name: playerName, points: 0));
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

    for (var player in _playerBloc.currentState.players) {
      if (!_previouslyAddedPlayers.contains(player.name))
        _previouslyAddedPlayers.add(player.name);
    }

    var sublistLen = _previouslyAddedPlayers.length <= _maxPrevPlayers
        ? _previouslyAddedPlayers.length
        : _maxPrevPlayers;
    prefs.setStringList('previouslyAddedPlayers',
        _previouslyAddedPlayers.sublist(0, sublistLen));
  }

  void _showDialog(BuildContext myContext) {
    showDialog(
      context: myContext,
      builder: (BuildContext bContext) {
        return AlertDialog(
          title: Text(
            "Duplicate Player",
            style: TextStyle(
                color: Theme.of(bContext).primaryTextTheme.display1.color),
          ),
          content: Text("Enter a unique player name",
              style: TextStyle(
                  color: Theme.of(bContext).primaryTextTheme.display1.color)),
          actions: [
            FlatButton(
              child: Text("Close"),
              onPressed: () {
                Navigator.of(bContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: _playerBloc,
      builder: (context, PlayerState state) {
        return MaterialApp(
          navigatorKey: App.navKey,
          theme: selectedTheme ??
              ThemeData(
                  primarySwatch: Colors.black,
                  brightness: Brightness.dark,
                  primaryTextTheme:
                      TextTheme(display1: TextStyle(color: Colors.white))),
          home: Scaffold(
            appBar: AppBar(
              title: Text("GamePoints"),
              actions: [
                _useTimer && !_entryToggle
                    ? FlatButton(
                        padding: EdgeInsets.all(10),
                        child: Text("$_currentTimerValue sec",
                            style: TextStyle(
                                fontSize: 30,
                                color: Theme.of(
                                        App.navKey.currentState.overlay.context)
                                    .primaryTextTheme
                                    .display1
                                    .color)),
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
                    child: Text(
                      'Menu',
                    ),
                  ),
                ),
                Menu(
                  playerBloc: _playerBloc,
                  onTimerToggled: () {
                    setState(() {
                      _loadTimer();
                    });
                  },
                  onAddPlayerPressed: () {
                    _entryToggle = true;
                  },
                  onClearPointsPressed: () {
                    setState(() {
                      startTimer();
                    });
                  },
                  onPastPlayersToggled: () {
                    setState(() {
                       _loadPrevPlayers();
                    });
                  },
                  onThemeSelected: () {
                    setState(() {
                      _loadTheme();
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
                                value.length > 0
                                    ? _isButtonEnabled = true
                                    : _isButtonEnabled = false;
                                if (value.length > 0 && value.contains("\n")) {
                                  controller.text = value.trim();

                                  if (state.players
                                      .any((p) => p.name == controller.text)) {
                                    _showDialog(App
                                        .navKey.currentState.overlay.context);
                                  } else {
                                    addPlayer(controller.text);
                                  }
                                }
                              },
                              controller: controller,
                              textCapitalization: TextCapitalization.words,
                              textInputAction: TextInputAction.newline,
                            ),
                            RaisedButton(
                                child: Icon(Icons.add),
                                onPressed: _isButtonEnabled
                                    ? () {
                                        if (state.players.any(
                                            (p) => p.name == controller.text)) {
                                          _showDialog(App.navKey.currentState
                                              .overlay.context);
                                        } else {
                                          addPlayer(controller.text);
                                        }
                                      }
                                    : null),
                            RaisedButton(
                                child: Text('Start Game'),
                                onPressed: state.players.length > 0
                                    ? () {
                                        setState(
                                          () {
                                            _entryToggle = false;
                                            startTimer();
                                            savePlayersToDisk();
                                          },
                                        );
                                      }
                                    : null),
                          ],
                        ),
                      ),
                      state.players.length > 0
                          ? Expanded(
                              child: _entryToggle
                                  ? PlayerList(
                                      playerBloc: _playerBloc,
                                      playerState: state
                                    )
                                  : CardList(
                                      playerBloc: _playerBloc,
                                      playerState: state,
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
                )),
          ),
        );
      },
    );
  }
}
