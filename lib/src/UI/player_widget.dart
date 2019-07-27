import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gamepointsflutter/src/blocs/player_bloc/player_bloc.dart';
import '../models/player.dart';

const Duration _playerCardFadeDuration = const Duration(milliseconds: 2100);

class PlayerWidget extends StatefulWidget {
  final PlayerBloc playerBloc;
  final Player player;
  final Color color;
  final VoidCallback onPointsChanged;

  const PlayerWidget(
      {Key key,
      @required this.playerBloc,
      this.player,
      this.color,
      this.onPointsChanged});

  static final navKey = new GlobalKey<NavigatorState>();

  @override
  PlayerWidgetState createState() => PlayerWidgetState();
}

class PlayerWidgetState extends State<PlayerWidget>
    with SingleTickerProviderStateMixin {
  Color cardColor = Colors.transparent;
  Animation animation;
  AnimationController animationController;

  @override
  void initState() {
    super.initState();
    cardColor = widget.color;

    animationController =
        AnimationController(duration: _playerCardFadeDuration, vsync: this);

    animation = ColorTween(begin: cardColor, end: Colors.white)
        .animate(animationController)
          ..addListener(() {
            setState(() {});
          });

    animation.addStatusListener((s) {
      switch (s) {
        case AnimationStatus.completed:
          animationController.reverse();
          break;
        case AnimationStatus.dismissed:
          break;
        case AnimationStatus.forward:
          break;
        case AnimationStatus.reverse:
          break;
      }
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: animation?.value ?? cardColor,
      elevation: 0,
      child: Column(
        children: [
          Center(
            child: Text(
              widget.player.name.toUpperCase(),
              style: TextStyle(
                  color: Theme.of(context).primaryTextTheme.display1.color,
                  fontSize: 25),
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.remove_circle_outline,
                    size: 38,
                    color: Theme.of(context).primaryTextTheme.display1.color),
                onPressed: () {
                  setState(() {
                    animationController.forward();
                    widget.playerBloc.removePoint(widget.player);
                    widget.onPointsChanged();
                  });
                },
              ),
              Expanded(
                  child: Text(
                widget.player.points.toString(),
                style: TextStyle(
                    color: Theme.of(context).primaryTextTheme.display1.color,
                    fontSize: 55),
                textAlign: TextAlign.center,
              )),
              IconButton(
                icon: Icon(
                  Icons.add_circle,
                  size: 38,
                  color: Theme.of(context).primaryTextTheme.display1.color,
                ),
                onPressed: () {
                  setState(() {
                    animationController.forward();
                    widget.playerBloc.addPoint(widget.player);
                    widget.onPointsChanged();
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
