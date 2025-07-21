import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quetzalmayhem/pages/game_page.dart';
import 'package:quetzalmayhem/pages/home_page.dart';
import 'package:quetzalmayhem/providers/game_providers.dart';
import 'package:quetzalmayhem/services/game_controller_service.dart';
import 'package:quetzalmayhem/services/utils.dart';

void main() {
  runApp(const ProviderScope(child: QuetzalApp()));
}

class QuetzalApp extends ConsumerWidget {
  const QuetzalApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      navigatorKey: Utils.navKey,
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        ref.read(gameLogicProvider).initializeGame();
        return child!;
      },
      home: HomePage(),
    );
  }
}