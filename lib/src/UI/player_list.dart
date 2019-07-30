import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gamepointsflutter/src/blocs/player_bloc/player_bloc.dart';

class PlayerList extends StatefulWidget {
  @override
  PlayerListState createState() => PlayerListState();
}

class PlayerListState extends State<PlayerList> {
  @override
  Widget build(BuildContext context) {
    PlayerBloc playerBloc = BlocProvider.of<PlayerBloc>(context);

    return ListView.builder(
      itemCount: playerBloc.currentState.players.length,
      itemBuilder: (context, index) {
        final player = playerBloc.currentState.players[index];

        return Dismissible(
          key: Key(player.name),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            playerBloc.removePlayer(playerBloc.currentState.players[index]);

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
