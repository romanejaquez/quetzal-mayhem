import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quetzalmayhem/models/enums.dart';
import 'package:quetzalmayhem/providers/game_providers.dart';
import 'package:rive/rive.dart';

class QuetzalTopLog extends ConsumerStatefulWidget {
  const QuetzalTopLog({super.key});

  @override
  ConsumerState<QuetzalTopLog> createState() => _QuetzalTopLogState();
}

class _QuetzalTopLogState extends ConsumerState<QuetzalTopLog> {

  late RiveAnimation animation;
  late StateMachineController ctrl;
  Map<TopLogPosition, SMITrigger> triggers = {};
  bool isLoaded = false;
  late TextValueRun eggs;
  late TextValueRun score;
  late TextValueRun time;

  @override
  void initState() {
    super.initState();

    animation = RiveAnimation.asset(
      './assets/animations/quetzal.riv',
      artboard: 'topgamelog',
      onInit: onRiveInit,
    );
  }
  
  void onRiveInit(Artboard artboard) {

    ctrl = StateMachineController.fromArtboard(artboard, 'topgamelog')!;
    artboard.addController(ctrl);

    for(var position in TopLogPosition.values) {
      triggers[position] = ctrl.getTriggerInput(position.name)!;
    }

    eggs = artboard.component<TextValueRun>('eggs') as TextValueRun;
    score = artboard.component<TextValueRun>('score') as TextValueRun;
    time = artboard.component<TextValueRun>('time') as TextValueRun;

    setState(() {
      isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Consumer(
      builder: (context, ref, child) {
      
        final quetzalPos = ref.watch(quetzalRandomPos);
        final timeValue = ref.watch(gameTimerValueProvider);
        final eggsValue = ref.watch(eggsCountProvider);
        final scoreValue = ref.watch(scoreProvider);


        if (isLoaded) {
          triggers[quetzalPos]!.fire();
          time.text = timeValue;
          eggs.text = eggsValue.toString();
          score.text = scoreValue.toString();
        }

        return SizedBox(
          child: animation);
      },
    );
  }
}