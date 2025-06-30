import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as ui;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:quetzalmayhem/providers/game_providers.dart';
import 'package:quetzalmayhem/widgets/counter.dart';
import 'package:quetzalmayhem/widgets/nest.dart';
import 'package:quetzalmayhem/widgets/quetzal_top_log.dart';
import 'package:rive/rive.dart';

class GamePage extends StatelessWidget {
  const GamePage({super.key});

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

          Nest(),

          Align(
            alignment: Alignment.bottomRight,
            child: Consumer(
              builder: (context, ref, child) {

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      child: Text('<'),
                      onPressed: () {
                        ref.read(nestValueProvider.notifier).state -= 20;
                      },
                    ),

                    TextButton(
                      child: Text('>'),
                      onPressed: () {
                        ref.read(nestValueProvider.notifier).state += 20;
                      },
                    ),
                  ],
                );
              }
            ),
          ),

          Center(child: Counter()),
        ],
      ),
    );
  }
}