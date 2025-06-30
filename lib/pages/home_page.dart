import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {

    Future.delayed(const Duration(seconds: 3), (){
      Navigator.pushNamed(context, '/game');
    });

    return Scaffold(
      body: RiveAnimation.asset(
        './assets/animations/quetzal.riv',
        artboard: 'mainmenu',
      ),
    );
  }
}