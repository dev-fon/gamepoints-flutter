import 'package:flutter/material.dart';
import 'package:animator/animator.dart';
import 'package:gamepointsflutter/services/settings_service.dart';
import './settings.dart';
import './models/player.dart';

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
  final SettingsService _settingsService = SettingsService();
  final List<Player> _players = [];
  bool entryToggle = true;
  bool isButtonEnabled = false;
  bool _useTimer;

  addPlayer(String name) {
    if (name.length > 0) {
      setState(() {
        _players.add(Player(name: name, points: 0));
      });
    }

    controller.text = '';
    isButtonEnabled = false;
  }

     @override
  void initState() {
    super.initState();
    _loadCounter();
  }

  _loadCounter() async {
      setState(() {
        _useTimer = _settingsService.useTimer;
    });
  }

  getUseTimer() {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: Text("GamePoints"), actions: [
        appBar: AppBar(title: Text(, actions: [
        IconButton(
          icon: Icon(Icons.delete_forever, color: Colors.white),
          tooltip: "Delete all",
          onPressed: () {
            setState(() {
              _players.clear();
              entryToggle = true;
            });
          },
        ),
        IconButton(
          icon: Icon(Icons.refresh, color: Colors.white),
          tooltip: "Clear points",
          onPressed: () {
            setState(() {
              for (var player in _players) {
                player.points = 0;
              }
            });
          },
        ),
        IconButton(
          icon: Icon(Icons.group_add, color: Colors.white),
          tooltip: "Add",
          onPressed: () {
            setState(() {
              entryToggle = !entryToggle;
            });
          },
        )
      ]),
       drawer: Drawer(
          child: ListView(
        children: [
          Container(
            height: 50.0,
            child: DrawerHeader(
              child: Text('Settings'),
            ),
          ),
          Settings()
        ],
      )),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Visibility(
                  visible: entryToggle,
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
                                  ? isButtonEnabled = true
                                  : isButtonEnabled = false;
                              if (value.length > 0 && value.contains("\n")) {
                                addPlayer(value.trim());
                              }
                            });
                          },
                          controller: controller,
                          textCapitalization: TextCapitalization.words,
                          textInputAction: TextInputAction.newline,
                        ),
                        RaisedButton(
                            child: Icon(Icons.add),
                            onPressed: isButtonEnabled
                                ? () {
                                    addPlayer(controller.text);
                                  }
                                : null),
                      ])),
              _players.length > 0
                  ? Expanded(
                      child: entryToggle
                          ? SimpleList(players: _players)
                          : CardList(players: _players),
                    )
                  : Text("")
            ],
          ),
        ),
      ),
    );
  }
}

class SimpleList extends StatefulWidget {
  final List<Player> players;

  SimpleList({Key key, this.players});
  @override
  State<StatefulWidget> createState() {
    return SimpleListState(players: players);
  }
}

class SimpleListState extends State<SimpleList> {
  final List<Player> players;

  SimpleListState({Key key, this.players});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: ListTile.divideTiles(
        context: context,
        tiles: List.generate(
          players.length,
          (i) {
            return ListTile(
                leading: Icon(Icons.account_circle,
                    color: Theme.of(context).accentColor),
                title: Text(
                  players[i].name,
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                trailing: IconButton(
                    icon: Icon(Icons.restore_from_trash,
                        color: Theme.of(context).errorColor),
                    onPressed: () {
                      setState(() {
                        players.remove(players[i]);
                      });
                    }));
          },
        ),
      ).toList(),
    );
  }
}

class CardList extends StatelessWidget {
  final List<Player> players;
  final List<Color> colors = [
    Colors.grey,
    Colors.cyan[900],
    Colors.deepPurple,
    Colors.red,
    Colors.blue,
    Colors.blueGrey,
    Colors.green,
    Colors.brown
  ];

  CardList({Key key, this.players}) : super(key: key);

  double getCardAspectRatio(BuildContext context, Orientation orientation) {
    var size = MediaQuery.of(context).size;
    var toolbarYield =
        orientation == Orientation.portrait ? kToolbarHeight : 73;
    final double itemHeight = (size.height - toolbarYield - 24) / 2;

    return orientation == Orientation.portrait
        ? (size.width * 1.4 / itemHeight)
        : (itemHeight / size.width * 9.4);
  }

  Color getPlayerColor(int index) {
    return colors[index % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
        key: key,
        builder: (context, orientation) {
          return GridView.count(
              primary: true,
              padding: const EdgeInsets.all(0.3),
              crossAxisCount: orientation == Orientation.portrait ? 2 : 3,
              childAspectRatio: getCardAspectRatio(context, orientation),
              mainAxisSpacing: 1.0,
              crossAxisSpacing: 1.0,
              children: List.generate(players.length, (i) {
                return PlayerCard(player: players[i], color: getPlayerColor(i));
              }));
        });
  }
}

class PlayerCard extends StatefulWidget {
  final Player player;
  final Color color;

  const PlayerCard({Key key, this.player, this.color}) : super(key: key);

  @override
  PlayerCardState createState() =>
      PlayerCardState(player: player, color: color);
}

class PlayerCardState extends State<PlayerCard> {
  Player player;
  Color color;
  bool showAnimation = false;

  PlayerCardState({Key key, this.player, this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
        color: color,
        elevation: 0,
        child: Column(
          children: [
            Center(
              child: Text(
                player.name.toUpperCase(),
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
            ),
            Row(children: [
              IconButton(
                icon: Icon(Icons.remove_circle_outline,
                    size: 38, color: Colors.white),
                onPressed: () {
                  setState(() {
                    player.points--;
                   // showAnimation = true;
                  });
                },
              ),
              Animator(
                  duration: Duration(milliseconds: showAnimation ? 500 : 0),
                  cycles: 4,
                  //endAnimationListener: showAnimation,
                  //endAnimationListener: () => print("animation finished"),
                  builder: (anim) => Expanded(
                          child: Text(
                        player.points.toString(),
                        style: TextStyle(
                            color: Colors.white, fontSize: showAnimation ? 55 * anim.value : 55),
                        textAlign: TextAlign.center,
                      ))),
              IconButton(
                icon: Icon(
                  Icons.add_circle,
                  size: 38,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    player.points++;
                    //showAnimation = true;
                  });
                },
              ),
            ]),
          ],
        ));
  }
}