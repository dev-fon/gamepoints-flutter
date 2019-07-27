import 'package:gamepointsflutter/src/models/player.dart';

abstract class PlayerEvent {
  Player player;
  PlayerEvent(this.player);
}

class AddPlayerEvent extends PlayerEvent {
  AddPlayerEvent(Player player) : super(player);
}

class RemovePlayerEvent extends PlayerEvent {
  RemovePlayerEvent(Player player) : super(player);
}

class RemoveAllPlayersEvent extends PlayerEvent {
  RemoveAllPlayersEvent() : super(null);
}

class AddPointEvent extends PlayerEvent {
  AddPointEvent(Player player) : super(player);
}

class RemovePointEvent extends PlayerEvent {
  RemovePointEvent(Player player) : super(player);
}

class ClearPointsEvent extends PlayerEvent {
  ClearPointsEvent(): super(null);
}