import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:quetzalmayhem/providers/game_providers.dart';

class Nest extends StatefulWidget {
  const Nest({super.key});

  @override
  State<Nest> createState() => _NestState();
}

class _NestState extends State<Nest> with SingleTickerProviderStateMixin {

  late AnimationController ctrl;
  @override
  void initState() {
    super.initState();

    ctrl = AnimationController(vsync: this, duration: Duration(seconds: 10));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {

        final value = ref.watch(nestValueProvider);
        return AnimatedPositioned(
          curve: Curves.linear,
          duration: Duration.zero,
          bottom: 0,
          left: value,
          child: SvgPicture.asset('./assets/images/nest.svg',
            width: 100,
            height: 50,
          ),
        );
      }
    );
  }
}