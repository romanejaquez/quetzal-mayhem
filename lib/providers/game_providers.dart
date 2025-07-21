import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quetzalmayhem/models/enums.dart';
import 'package:quetzalmayhem/services/game_logic_service.dart';

final gameActionsProvider = StateProvider<GameActions>((ref) => GameActions.none);
final controlDirectionsProvider = StateProvider<ControlDirections>((ref) => ControlDirections.none);
final quetzalRandomPos = StateProvider.autoDispose<TopLogPosition>((ref) => TopLogPosition.pos1);
final gameLogicProvider = Provider((ref) => GameLogicService(ref));
final showCountdownProvider = StateProvider<bool>((ref) => false);
final gameTimerValueProvider = StateProvider<String>((ref) => '00:00');

final eggsCountProvider = StateProvider<int>((ref) => 3);
final scoreProvider = StateProvider<int>((ref) => 0);

final eggRandomPosProvider = StateProvider<int>((ref) => -500);


enum GameActions {
  none,
  start,
  left,
  right,
}

enum ControlDirections {
  none,
  up,
  down,
  left,
  right,
}
