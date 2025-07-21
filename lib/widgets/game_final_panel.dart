import 'package:flutter/material.dart';
import 'package:quetzalmayhem/providers/game_providers.dart';
import 'package:rive/rive.dart';

class GameFinalPanel extends StatefulWidget {

  final int score;
  final GameFinalPanelDisplay panel;
  const GameFinalPanel({super.key, required this.score, required this.panel});

  @override
  State<GameFinalPanel> createState() => _GameFinalPanelState();
}

class _GameFinalPanelState extends State<GameFinalPanel> {

  late RiveAnimation anim;
  late StateMachineController panelCtrl;
  bool isLoaded = false;
  late TextValueRun score;

  @override 
  void initState() {
    super.initState();

    anim = RiveAnimation.asset('./assets/animations/quetzal.riv',
      artboard: 'resultpanel',
      onInit: onRiveInit,
    );
  }

  void onRiveInit(Artboard ab) {
    panelCtrl = StateMachineController.fromArtboard(ab, '${widget.panel == GameFinalPanelDisplay.winPanel ? 'win' : 'lose'}panel')!;
    ab.addController(panelCtrl);
    score = ab.component<TextValueRun>('score') as TextValueRun;

    setState(() {
      isLoaded = true;
    });

  }

  @override
  Widget build(BuildContext context) {

    if (isLoaded) {
      score.text = widget.score.toString();
    }

    return anim;
  }
}