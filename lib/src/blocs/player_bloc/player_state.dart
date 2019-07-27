import '../../models/player.dart';

class PlayerState {
  List<Player> players;

  PlayerState._();

  factory PlayerState.initial() {
    return PlayerState._()..players = new List<Player>();
  }
}