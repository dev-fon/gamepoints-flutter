import 'package:flutter/material.dart';
import './models/player.dart';
import './color_fade_animator.dart';

const Duration _playerCardFadeDuration = const Duration(milliseconds: 300);
const Duration _playerNameAndPointsFadeDuration = const Duration(seconds: 2);

class PlayerCard extends ImplicitlyAnimatedWidget {
  final Player player;
  final Color color;
  final VoidCallback onPointsChanged;

  const PlayerCard({Key key, this.player, this.color, this.onPointsChanged})
      : super(key: key, duration: _playerCardFadeDuration);

  @override
  PlayerCardState createState() => PlayerCardState();
}

class PlayerCardState extends AnimatedWidgetBaseState<PlayerCard> {
  ColorFadeAnimator _cardBackgroundColorTween;
  ColorFadeAnimator _cardDetailsColorTween;
  Color playerNameColor = Colors.white;

  @override
  void forEachTween(visitor) {
    _cardBackgroundColorTween = visitor(_cardBackgroundColorTween, widget.color,
        (c) => ColorFadeAnimator(begin: Colors.white70));
    _cardDetailsColorTween = visitor(_cardDetailsColorTween, playerNameColor,
        (c) => ColorFadeAnimator(begin: Colors.white));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: _cardBackgroundColorTween.evaluate(animation),
      elevation: 0,
      child: Column(
        children: [
          Center(
            child: Text(
              widget.player.name.toUpperCase(),
              style: TextStyle(
                  color: _cardDetailsColorTween.evaluate(animation),
                  fontSize: 25),
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.remove_circle_outline,
                    size: 38, color: _cardDetailsColorTween.evaluate(animation)),
                onPressed: () {
                  setState(() async {
                    playerNameColor = Colors.black;
                    widget.player.points--;
                    widget.onPointsChanged();
                    // This feels like a hackey way to do this :\
                    await new Future.delayed(_playerNameAndPointsFadeDuration);
                    playerNameColor = Colors.white;
                  });
                },
              ),
              Expanded(
                  child: Text(
                widget.player.points.toString(),
                style: TextStyle(
                    color: _cardDetailsColorTween.evaluate(animation),
                    fontSize: 55),
                textAlign: TextAlign.center,
              )),
              IconButton(
                icon: Icon(
                  Icons.add_circle,
                  size: 38,
                  color: _cardDetailsColorTween.evaluate(animation),
                ),
                onPressed: () {
                  setState(() async {
                    playerNameColor = Colors.black;
                    widget.player.points++;
                    widget.onPointsChanged();
                    // This feels like a hackey way to do this :\
                    await new Future.delayed(_playerNameAndPointsFadeDuration);
                    playerNameColor = Colors.white;
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
