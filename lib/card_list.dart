import 'package:flutter/material.dart';

import './player_widget.dart';
import './models/player.dart';

class CardList extends StatelessWidget {
  final VoidCallback onPointsChanged;
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

  CardList({Key key, this.players, this.onPointsChanged}) : super(key: key);

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
                return PlayerCard(
                    player: players[i],
                    color: getPlayerColor(i),
                    onPointsChanged: () => onPointsChanged());
              }));
        });
  }
}
