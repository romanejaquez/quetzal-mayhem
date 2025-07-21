import 'dart:async';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quetzalmayhem/models/enums.dart';
import 'package:quetzalmayhem/providers/game_providers.dart';

class GameLogicService {

  final Ref ref;
  bool _initialized = false;
  
  GameLogicService(this.ref);
  Timer topTimer = Timer(Duration.zero, () {});
  Timer countdown = Timer(Duration.zero, () {});

  Timer gameTimer = Timer(Duration.zero, () {});
  int countdownValue = 7;
  final random = Random();
  int gameCountInSecs = 60;

  void startCountDown(Function onCountDownDone) {
    Future.delayed(Duration.zero, () {
      ref.read(showCountdownProvider.notifier).state = true;
    });
    Timer.periodic(const Duration(seconds: 1), (t) {
      countdownValue--;
      if (countdownValue == 0) {
        Future.delayed(Duration.zero, () {
          ref.read(showCountdownProvider.notifier).state = false;
        });
        t.cancel();
        onCountDownDone();
      }
    });
  }

  void startTopLogTimer() {
    topTimer = Timer.periodic(const Duration(milliseconds: 2000), (t) {
      final pos = TopLogPosition.values[random.nextInt(TopLogPosition.values.length)];
      ref.read(quetzalRandomPos.notifier).state = pos;
      Future.delayed(const Duration(milliseconds: 500), () {
        ref.read(eggRandomPosProvider.notifier).state = pos.eggPos;
      });
    });
  }

  void startGame() {
    startCountDown(() {
        startTopLogTimer();
        startGameTimer();
    });
  }

  void startGameTimer() {
    gameTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      int seconds = gameCountInSecs;
      int minutes = (seconds / 60).floor();
      seconds = seconds % 60;
      String formattedTime = '';
      if (minutes < 10) {
        formattedTime = '0$minutes:';
      } else {
        formattedTime = '$minutes:';
      }
      if (seconds < 10) {
        formattedTime += '0$seconds';
      } else {
        formattedTime += '$seconds';
      }

      ref.read(gameTimerValueProvider.notifier).state = formattedTime;
      if (gameCountInSecs == 0) {
        t.cancel();
        stopGame();
      }
      gameCountInSecs--;
      
    });
  }

  void stopGame() {
    topTimer.cancel();
    gameTimer.cancel();
    countdown.cancel();
  }
  
}