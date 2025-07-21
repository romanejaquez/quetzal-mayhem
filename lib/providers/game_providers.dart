import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quetzalmayhem/models/enums.dart';
import 'package:quetzalmayhem/services/eggs_viewmodel.dart';
import 'package:quetzalmayhem/services/game_logic_service.dart';

final gameActionsProvider = StateProvider<GameActions>((ref) => GameActions.none);
final controlDirectionsProvider = StateProvider<ControlDirections>((ref) => ControlDirections.none);
final quetzalRandomPos = StateProvider<TopLogPosition>((ref) => TopLogPosition.pos1);
final gameLogicProvider = Provider((ref) => GameLogicService(ref));
final showCountdownProvider = StateProvider<bool>((ref) => false);
final gameTimerValueProvider = StateProvider<String>((ref) => '00:00');

final eggsCountProvider = StateProvider<int>((ref) => 5);
final scoreProvider = StateProvider<int>((ref) => 0);

final eggsVMProvider = StateNotifierProvider<EggsViewmodel, List<Widget>>((ref) => EggsViewmodel());
final eggRandomPosProvider = StateProvider<int>((ref) => -500);
final finalGamePanelDisplayProvider = StateProvider<GameFinalPanelDisplay>((ref) => GameFinalPanelDisplay.none);


enum GameActions {
  none,
  start,
  back,
}

enum ControlDirections {
  none,
  up,
  down,
  left,
  right,
}

enum GameFinalPanelDisplay {
  winPanel,
  losePanel,
  none,
}