import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:quetzalmayhem/providers/game_providers.dart';

class EggField extends StatefulWidget {
  const EggField({super.key});

  @override
  State<EggField> createState() => _EggFieldState();
}

class _EggFieldState extends State<EggField> {

  List<Widget> eggs = [];
  int index = 0;

  @override 
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {

        final eggPos = ref.watch(eggRandomPosProvider);
        index++;
        
        eggs.add(Positioned(
          key: ValueKey(index),
          top: 100,
          left: eggPos.toDouble(),
          child: SizedBox(
            child: SvgPicture.asset('./assets/images/egg.svg',
              key: ValueKey('egg$index'),
              width: 30,
              height: 30,
              fit: BoxFit.contain,
            ).animate(
              onComplete: (controller) {
                controller.repeat();
              },
            )
            .rotate(
              begin: 0, end: 1,
              duration: 1.seconds,
              curve: Curves.linear,
            )
          ),
          ).animate(
            onComplete: (controller) {
              eggs.removeWhere((e) => e.key == ValueKey(index));
            },
          )
          .slideY(
            begin: 0, end: 10,
            curve: Curves.linear,
            duration: 2.seconds,
          ),
        );

        return Stack(
          children: eggs,
        );
      }
    );
  }
}