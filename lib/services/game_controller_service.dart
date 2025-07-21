import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamepads/gamepads.dart';
import 'package:quetzalmayhem/providers/game_providers.dart';

class GameControllerService {

  final Ref ref;
  final Stream<GamepadEvent?> gamePadEvent;
  bool _initialized = false;
  
  GameControllerService(this.ref, this.gamePadEvent);

  void initialize() {
    if (_initialized) return;
    _initialized = true;
    
    gamePadEvent.listen((event) {
      
      var key = event!.key;
      
      // print(event.key);
      // print(event.value);

      if (key == 'KEYCODE_BUTTON_A') {
          
      }
      else if (key == 'KEYCODE_BUTTON_B') {
        
      }
      else if (key == 'KEYCODE_BUTTON_X') {
        
      }
        else if (key == 'KEYCODE_BUTTON_Y') {
       
      }
      else if (key == 'KEYCODE_DPAD_RIGHT') {
        ref.read(controlDirectionsProvider.notifier).state = ControlDirections.right;
      }
      else if (key == 'KEYCODE_DPAD_LEFT') {
        ref.read(controlDirectionsProvider.notifier).state = ControlDirections.left;
      }
      else if (key == 'KEYCODE_BUTTON_START') {
        ref.read(gameActionsProvider.notifier).state = GameActions.start;
      }
      
    });
  }
}

final subscriptionProvider = Provider<Stream<GamepadEvent?>>((ref) {
  return Gamepads.events;
});

final gameControllerServiceProvider = Provider<GameControllerService>((ref) {

  final sub = ref.read(subscriptionProvider);
  return GameControllerService(ref, sub);
});