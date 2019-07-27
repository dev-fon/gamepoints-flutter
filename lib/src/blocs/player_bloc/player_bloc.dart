import 'package:bloc/bloc.dart';
import 'package:gamepointsflutter/src/models/player.dart';

import 'player_event.dart';
import 'player_state.dart';

class PlayerBloc extends Bloc<PlayerEvent, PlayerState> {
  addPlayer(Player player) {
    dispatch(AddPlayerEvent(player));
  }

  removePlayer(Player player) {
    dispatch(RemovePlayerEvent(player));
  }

  removeAllPlayers() {
    dispatch(RemoveAllPlayersEvent());
  }

  addPoint(Player player) {
    dispatch(AddPointEvent(player));
  }

  removePoint(Player player) {
    dispatch(RemovePointEvent(player));
  }

  clearPoints() {
    dispatch(ClearPointsEvent());
  }

  @override
  get initialState => PlayerState.initial();

  @override
  Stream<PlayerState> mapEventToState(
    PlayerEvent event,
  ) async* {
    switch (event.runtimeType) {
      case AddPlayerEvent:
        yield currentState..players.add(event.player);
        break;
      case RemovePlayerEvent:
        yield currentState..players.remove(event.player);
        break;
      case RemoveAllPlayersEvent:
        yield currentState..players.clear();
        break;
      case AddPointEvent:
        yield currentState
          ..players.firstWhere((p) => p == event.player).incrementPoints();
        break;
      case RemovePointEvent:
        yield currentState
          ..players.firstWhere((p) => p == event.player).decrementPoints();
        break;
      case ClearPointsEvent:
        yield currentState..players.forEach((p) => p.points = 0);
        break;
      default:
        yield null;
        break;
    }
  }
}
