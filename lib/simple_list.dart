import 'package:flutter/material.dart';
import './models/player.dart';
import 'color_fade_animator.dart';

const Duration _fadeDuration = const Duration(milliseconds: 300);

class SimpleList extends ImplicitlyAnimatedWidget {
  final List<Player> players;
  final VoidCallback onDeletePressed;  

  const SimpleList({Key key, this.players, @required this.onDeletePressed})
  : super(key: key, duration: _fadeDuration );

  @override
  SimpleListState createState() {
    return SimpleListState(players: players, onDeletePressed: onDeletePressed);
  }
}

class SimpleListState extends AnimatedWidgetBaseState<SimpleList> {
  final List<Player> players;
  final VoidCallback onDeletePressed;
  ColorFadeAnimator _iconColorTween;
  ColorFadeAnimator _textColorTween;

SimpleListState({Key key, this.players, @required this.onDeletePressed});

@override
  void forEachTween(visitor) {
    _iconColorTween = visitor(
      _iconColorTween,
      Colors.blueGrey[400],
      (c) => ColorFadeAnimator(begin: Colors.white70)
    );
    _textColorTween = visitor(
      _textColorTween,
      Colors.black,
      (c) => ColorFadeAnimator(begin: Colors.white70)
    );
  }  

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: players.length,
      itemBuilder: (context, index) {
        final player = players[index];

        return Dismissible(
          key: Key(player.name),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            setState(() {
              players.remove(players[index]);
              onDeletePressed();
            });

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
            leading: Icon(Icons.account_circle,
                color: _iconColorTween.evaluate(animation)),
            title: Text(
              player.name,
              textAlign: TextAlign.left,
              style: TextStyle(
                color: _textColorTween.evaluate(animation),
                fontSize: 20, 
                fontWeight: FontWeight.bold),
            ),
          ),
        );
      },
    );
  }
}
