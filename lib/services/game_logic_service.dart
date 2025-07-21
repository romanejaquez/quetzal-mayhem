import 'dart:async';
import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:quetzalmayhem/models/enums.dart';
import 'package:quetzalmayhem/providers/game_providers.dart';

class GameLogicService {

  final Ref ref;
  bool _initialized = false;
  bool gameStopped = false;
  
  GameLogicService(this.ref);

  Timer loopTimer = Timer(0.seconds, () {});
  
  Timer topTimer = Timer(Duration.zero, () {});
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
    //ref.read(gameStartedFlagProvider.notifier).state = true;

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
      Future.delayed(const Duration(milliseconds: 500), () {
        addEggToField(pos.eggPos.toDouble());
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
          //removeEggKey(posKey);
        },
      )
      .slideY(
        begin: 0, end: 10,
        curve: Curves.linear,
        duration: 2.seconds,
      );

    addEgg(egg, posKey);
  }

  void startGame() {
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
    stopGameLoop();
    topTimer.cancel();
    gameTimer.cancel();
    countdown.cancel();
  }
  
}