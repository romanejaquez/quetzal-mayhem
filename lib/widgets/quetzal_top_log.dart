import 'package:flutter/material.dart';
import 'package:quetzalmayhem/models/enums.dart';
import 'package:rive/rive.dart';

class QuetzalTopLog extends StatefulWidget {
  const QuetzalTopLog({super.key});

  @override
  State<QuetzalTopLog> createState() => _QuetzalTopLogState();
}

class _QuetzalTopLogState extends State<QuetzalTopLog> {

  late RiveAnimation animation;
  late StateMachineController ctrl;
  Map<TopLogPosition, SMITrigger> triggers = {};
  bool isLoaded = false;

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

    setState(() {
      isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {

    if (isLoaded) {
      Future.delayed(const Duration(seconds: 2), () {
        triggers[TopLogPosition.pos1]!.fire();
      });

      Future.delayed(const Duration(seconds: 4), () {
        triggers[TopLogPosition.pos2]!.fire();
      });
    }

    return animation;
  }
}