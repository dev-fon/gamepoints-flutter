import 'package:flutter/material.dart';
import 'package:gamepointsflutter/src/blocs/player_bloc/player_bloc.dart';
import 'package:gamepointsflutter/src/blocs/player_bloc/player_state.dart';

import './player_widget.dart';

class CardList extends StatelessWidget {
  final PlayerBloc playerBloc;
  final PlayerState playerState;
  final VoidCallback onPointsChanged;

  final List<Color> colors = [
    Colors.grey,
    Colors.cyan,
    Colors.deepPurple,
    Colors.deepOrange,
    Colors.blue,
    Colors.blueGrey,
    Colors.amber,
    Colors.brown
  ];

  CardList(
      {Key key,
      @required this.playerBloc,
      @required this.playerState,
      this.onPointsChanged})
      : super(key: key);

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
              children: List.generate(playerState.players.length, (i) {
                return PlayerWidget(
                    playerBloc: playerBloc,
                    player: playerState.players[i],
                    color: getPlayerColor(i),
                    onPointsChanged: () => onPointsChanged());
              }));
        });
  }
}
