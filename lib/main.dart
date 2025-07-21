import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quetzalmayhem/pages/game_page.dart';
import 'package:quetzalmayhem/pages/home_page.dart';
import 'package:quetzalmayhem/services/game_controller_service.dart';

void main() {
  runApp(const ProviderScope(child: QuetzalApp()));
}

class QuetzalApp extends ConsumerWidget {
  const QuetzalApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        ref.read(gameControllerServiceProvider).initialize();
        return child!;
      },
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/game': (context) => const GamePage(),
      },
    );
  }
}