import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as ui;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:quetzalmayhem/providers/game_providers.dart';
import 'package:quetzalmayhem/widgets/counter.dart';
import 'package:quetzalmayhem/widgets/egg_field.dart';
import 'package:quetzalmayhem/widgets/nest.dart';
import 'package:quetzalmayhem/widgets/quetzal_top_log.dart';
import 'package:rive/rive.dart';

class GamePage extends ConsumerStatefulWidget {
  const GamePage({super.key});

  @override
  ConsumerState<GamePage> createState() => _GamePageState();
}

class _GamePageState extends ConsumerState<GamePage> {

  @override 
  void initState() {
    super.initState();

    ref.read(gameLogicProvider).startGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: ui.LinearGradient(colors: [
                  Color(0xFF6FFFFF),
                  Color(0xFFFFED90),
                  Color(0xFFFFED90),
                  Color(0xFFCEAF10),
                ],
                begin: Alignment.center,
                end: Alignment.bottomCenter,
                stops: [0.0, 0.0125, 0.45, 1.0],
              ),
            ),
          ),

          Positioned(
            top: -140,
            left: 0,
            right: 0,
            bottom: 0,
            child: QuetzalTopLog(),
          ),

          Nest(
            screenWidth: MediaQuery.of(context).size.width,
          ),

          EggField(),

          Consumer(
            builder: (context, ref, child) {
              final showCoundown = ref.watch(showCountdownProvider);
              return showCoundown ? Center(child: Counter()) : const SizedBox.shrink();
            }
          ),
        ],
      ),
    );
  }
}