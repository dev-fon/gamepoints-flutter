import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';

void main() {
  //SystemChrome.setEnabledSystemUIOverlays([]);
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
      primarySwatch: Colors.blueGrey,
    ),
  ));
}

class Player {
  String name;
  int points;

  Player({this.name, this.points});
}

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  final TextEditingController controller = TextEditingController();
  final List<Player> _players = [];
  bool entryToggle = true;
  bool isButtonEnabled = false;

  addPlayer(String name) {
    setState(() {
      _players.add(Player(name: name, points: 0));
    });
    controller.text = '';
    isButtonEnabled = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("GamePoints"), actions: [
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

  CardList({Key key, this.players}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
        key: key,
        builder: (context, orientation) {
          return GridView.count(
              primary: true,
              padding: const EdgeInsets.all(0.3),
              crossAxisCount: orientation == Orientation.portrait ? 2 : 3,
              childAspectRatio: orientation == Orientation.portrait ? 2 : 2.2,
              mainAxisSpacing: 1.0,
              crossAxisSpacing: 1.0,
              children: List.generate(players.length, (i) {
                return PlayerCard(player: players[i]);
              }));
        });
  }
}

class PlayerCard extends StatefulWidget {
  final Player player;
  const PlayerCard({Key key, this.player}) : super(key: key);

  @override
  PlayerCardState createState() => PlayerCardState(player: player);
}

class PlayerCardState extends State<PlayerCard> {
  Player player;

  final List<Color> colors = [
    Colors.grey,
    Colors.cyan[900],
    Colors.deepPurple,
    Colors.red,
    Colors.blue,
    Colors.blueGrey,
  ];

  PlayerCardState({Key key, this.player});

  Color getRandomColor() {
    return colors[player.name.length % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        color: getRandomColor(),
        elevation: 1.5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          verticalDirection: VerticalDirection.down,
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
                  });
                },
              ),
              Expanded(
                  child: Text(
                player.points.toString(),
                style: TextStyle(color: Colors.white, fontSize: 55),
                textAlign: TextAlign.center,
              )),
              IconButton(
                icon: Icon(
                  Icons.add_circle,
                  size: 38,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    player.points++;
                  });
                },
              ),
            ]),
          ],
        ));
  }
}
