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

        final eggs = ref.watch(eggsVMProvider);

        return Stack(
          children: eggs,
        );
      }
    );
  }
}