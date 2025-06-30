import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class Counter extends StatefulWidget {
  const Counter({super.key});

  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {

  late RiveAnimation anim;
  late StateMachineController ctrl;
  bool isLoaded = false;

  @override 
  void initState() {
    super.initState();

    anim = RiveAnimation.asset(
      './assets/animations/quetzal.riv',
      artboard: 'countdown',
      onInit: onRiveInit,
      fit: BoxFit.cover,
    );
  }

  void onRiveInit(Artboard ab) {
    ctrl = StateMachineController.fromArtboard(ab, 'countdown')!;
    ab.addController(ctrl);

    setState(() {
      isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return anim;
  }
}