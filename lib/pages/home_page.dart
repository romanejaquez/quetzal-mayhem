import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quetzalmayhem/providers/game_providers.dart';
import 'package:rive/rive.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {

  @override 
  void initState() {
    super.initState();

    ref.read(gameActionsProvider.notifier).addListener((action) {
      if (action == GameActions.start) {
        Navigator.pushNamed(context, '/game');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RiveAnimation.asset(
        './assets/animations/quetzal.riv',
        artboard: 'mainmenu',
      ),
    );
  }
}