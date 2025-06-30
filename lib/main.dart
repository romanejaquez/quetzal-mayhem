import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quetzalmayhem/pages/game_page.dart';
import 'package:quetzalmayhem/pages/home_page.dart';

void main() {
  runApp(const ProviderScope(child: QuetzalApp()));
}

class QuetzalApp extends StatelessWidget {
  const QuetzalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/game': (context) => const GamePage(),
      },
    );
  }
}