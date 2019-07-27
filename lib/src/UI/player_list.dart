import 'package:flutter/material.dart';
import 'package:gamepointsflutter/src/blocs/player_bloc/player_bloc.dart';
import 'package:gamepointsflutter/src/blocs/player_bloc/player_state.dart';

class PlayerList extends StatefulWidget {
  final PlayerBloc playerBloc;
  final PlayerState playerState;

  const PlayerList(
      {Key key,
      @required this.playerBloc,
      @required this.playerState})
      : super(key: key);

  @override
  PlayerListState createState() => PlayerListState();
}

class PlayerListState extends State<PlayerList> {

  PlayerListState({Key key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.playerState.players.length,
      itemBuilder: (context, index) {
        final player = widget.playerState.players[index];

        return Dismissible(
          key: Key(player.name),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            widget.playerBloc.removePlayer(widget.playerState.players[index]);

            Scaffold.of(context).showSnackBar(
                SnackBar(content: Text("${player.name} deleted")));
          },
          background: Container(
            color: Colors.red,
            child: ListTile(
              trailing: Icon(Icons.restore_from_trash, color: Colors.white),
            ),
          ),
          child: ListTile(
            leading: Icon(Icons.account_circle, color: Colors.grey),
            title: Text(
              player.name,
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        );
      },
    );
  }
}
