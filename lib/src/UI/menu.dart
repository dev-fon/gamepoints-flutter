import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gamepointsflutter/src/blocs/player_bloc/player_bloc.dart';

class Menu extends StatefulWidget {
  final VoidCallback onClearPointsPressed;
  final VoidCallback onAddPlayerPressed;

  Menu(
      {Key key,
      this.onClearPointsPressed,
      this.onAddPlayerPressed});

  @override
  State<StatefulWidget> createState() {
    return MenuState(
        this.onClearPointsPressed,
        this.onAddPlayerPressed);
  }
}

class MenuState extends State<Menu> {
  PlayerBloc playerBloc;
  final VoidCallback onClearPointsPressed;
  final VoidCallback onAddPlayerPressed;

  MenuState(this.onClearPointsPressed, this.onAddPlayerPressed);

  @override
  void initState() {
    super.initState();
    playerBloc = BlocProvider.of<PlayerBloc>(context);
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
        _createMenuItem(
            'Add', Icons.group_add, onAddPlayerPressed, true, context),
        _createMenuItem('Clear points', Icons.refresh, () {
          playerBloc.clearPoints();
        }, true, context),
        _createMenuItem('Delete all', Icons.delete_forever, () {
          playerBloc.removeAllPlayers();
        }, true, context)
      ],
    );
  }
}
