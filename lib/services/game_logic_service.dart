import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:quetzalmayhem/models/enums.dart';
import 'package:quetzalmayhem/pages/game_page.dart';
import 'package:quetzalmayhem/providers/game_providers.dart';
import 'package:quetzalmayhem/services/game_controller_service.dart';
import 'package:quetzalmayhem/services/utils.dart';

class GameLogicService {

  final Ref ref;
  bool _initialized = false;
  bool gameStopped = false;
  
  GameLogicService(this.ref);

  Timer loopTimer = Timer(0.seconds, () {});
  Timer topTimer = Timer(Duration.zero, () {});
  Timer eggPosTimer = Timer(Duration.zero, () {});
  Timer countdown = Timer(Duration.zero, () {});

  Timer gameTimer = Timer(Duration.zero, () {});
  int countdownValue = 7;
  final random = Random();
  int gameCountInSecs = 60;

  GlobalKey nestKey = GlobalKey();
  Map<GlobalKey, Widget> eggKeys = {};
  List<GlobalKey> positionEggKeys = [];



  void addEgg(Widget egg, GlobalKey posKey) {
    Future.delayed(0.seconds, () => ref.read(eggsVMProvider.notifier).addEgg(egg));
    positionEggKeys.add(posKey);
    eggKeys[posKey] = egg;
  }

  void removeEggKey(GlobalKey posKey) {
    positionEggKeys.remove(posKey);
    Future.delayed(0.seconds, () => ref.read(eggsVMProvider.notifier).removeEgg(eggKeys[posKey]!));
  }

  void startGameLoop() {

    loopTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (gameStopped) {
        timer.cancel();
        return;
      }

      checkForCollision();
    });
  }

  void checkForCollision() {

    final nestRect = nestKey.currentContext!.findRenderObject() as RenderBox;
    final nestPos = nestRect.localToGlobal(Offset.zero);

    List<GlobalKey> keysToRemove = [];

    // check if the nest has collided with any of the eggs
    for (var eggKey in positionEggKeys) {
      if (eggKey.currentContext != null) {
        final eggRect = eggKey.currentContext!.findRenderObject() as RenderBox;
        final eggPos = eggRect.localToGlobal(Offset.zero);
        debugPrint('EGG => ${eggPos.dx} ${eggPos.dy} ${eggKey}');
        debugPrint('NEST => ${nestPos.dx} ${nestPos.dy}');
        
        if (nestPos.dx < eggPos.dx + eggRect.size.width &&
            nestPos.dx + nestRect.size.width > eggPos.dx &&
            nestPos.dy < eggPos.dy + eggRect.size.height &&
            nestPos.dy + nestRect.size.height > eggPos.dy) {
          // collision detected
          debugPrint('COLLISION!!!!!!!======>>>>>');
          keysToRemove.add(eggKey);
        }
      }
    }

    ref.read(scoreProvider.notifier).state = ref.read(scoreProvider) + keysToRemove.length * 100;

    if (keysToRemove.isNotEmpty) {
      for (var key in keysToRemove) {
        removeEggKey(key);
      }
    }
  }

  void stopGameLoop() {
    gameStopped = true;
    loopTimer.cancel();
  }

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
      eggPosTimer = Timer(const Duration(milliseconds: 500), () {
        addEggToField(pos.eggPos.toDouble());

        if (ref.read(eggsCountProvider) == 0) {
          eggPosTimer.cancel();
          topTimer.cancel();
          t.cancel();
          return;
        }
      });
    });
  }

  void addEggToField(double pos) {
    final eggPos = pos;
        
    final posKey = GlobalKey();

    final egg = Positioned(
      top: 100,
      left: eggPos.toDouble(),
      child: SizedBox(
        key: posKey,
        child: SvgPicture.asset('./assets/images/egg.svg',
          width: 30,
          height: 30,
          fit: BoxFit.contain,
        ).animate(
          onComplete: (controller) {
            controller.repeat();
          },
        )
        .rotate(
          begin: 0, end: 1,
          duration: 1.seconds,
          curve: Curves.linear,
        )
      ),
      ).animate(
        onComplete: (controller) {
          decreaseEggDropCount();
        },
      )
      .slideY(
        begin: 0, end: 10,
        curve: Curves.linear,
        duration: 2.seconds,
      );

    addEgg(egg, posKey);
  }

  void decreaseEggDropCount() {
    if (gameStopped) {
      return;
    }

    ref.read(eggsCountProvider.notifier).state = ref.read(eggsCountProvider) - 1;

    if (ref.read(eggsCountProvider) == 0) {
      stopGame();
    }
  }

  void startGame() {
    initializeSettings();
    startGameLoop();
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
    gameStopped = true;
    stopGameLoop();
    eggPosTimer.cancel();
    topTimer.cancel();
    gameTimer.cancel();
    countdown.cancel();
    ref.read(eggsVMProvider.notifier).clearEggs();
    ref.read(showCountdownProvider.notifier).state = false;

    ref.read(finalGamePanelDisplayProvider.notifier).state = ref.read(eggsCountProvider) == 0 ? GameFinalPanelDisplay.winPanel : 
      GameFinalPanelDisplay.losePanel;
  }

  void abortGame() {
    if(gameStopped) {
      return;
    }

    stopGame();
    resetGame();
  }

  void resetGame() {
    ref.read(eggsCountProvider.notifier).state = 5;
    ref.read(scoreProvider.notifier).state = 0;
    ref.read(gameTimerValueProvider.notifier).state = '00:00';
    
    ref.read(finalGamePanelDisplayProvider.notifier).state = GameFinalPanelDisplay.none;
    Navigator.of(Utils.navKey.currentContext!).pop();
  }

  void initializeGame() {
    ref.read(gameControllerServiceProvider).initialize();
    ref.watch(gameActionsProvider.notifier).addListener((action) {
      if (action == GameActions.start) {
        Navigator.push(Utils.navKey.currentContext!, MaterialPageRoute(builder: (context) => const GamePage()));
      }
      else if (action == GameActions.back) {
        abortGame();
      }
    });

    initializeSettings();
  }

  void initializeSettings() {
    loopTimer = Timer(0.seconds, () {});
    topTimer = Timer(Duration.zero, () {});
    eggPosTimer = Timer(Duration.zero, () {});
    countdown = Timer(Duration.zero, () {});

    gameTimer = Timer(Duration.zero, () {});
    countdownValue = 7;
    gameCountInSecs = 60;

    nestKey = GlobalKey();
    eggKeys = {};
    positionEggKeys = [];
    Future.delayed(0.seconds, () {
      ref.read(eggsVMProvider.notifier).clearEggs();
    });

    gameStopped = false;
  }
}