import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:quetzalmayhem/providers/game_providers.dart';

class Nest extends ConsumerStatefulWidget {
  final double screenWidth;
  const Nest({super.key, required this.screenWidth});

  @override
  ConsumerState<Nest> createState() => _NestState();
}

class _NestState extends ConsumerState<Nest> with SingleTickerProviderStateMixin {

  late AnimationController ctrl;
  double _leftPosition = 0;
  bool leftpressed = false;
  bool rightpressed = false;
  double nestWidth = 0;
  double nestMovementThreshold = 40;
  late GlobalKey nestKey;

  @override
  void initState() {
    super.initState();

    nestKey = ref.read(gameLogicProvider).nestKey;
    nestWidth = widget.screenWidth / 4;
    ctrl = AnimationController(vsync: this, duration: Duration(seconds: 10));
    _leftPosition = (widget.screenWidth / 2) - (nestWidth / 2);
  }

  @override
  Widget build(BuildContext context) {

    final next = ref.watch(controlDirectionsProvider);

    if (next == ControlDirections.left) {
        leftpressed = true;
        rightpressed = false;
    } else if (next == ControlDirections.right) {
        leftpressed = false;
        rightpressed = true;
    }

    if (leftpressed) {
      _leftPosition = (_leftPosition - nestWidth).clamp(0, widget.screenWidth - nestWidth);
    }
    else if (rightpressed) {
      _leftPosition = (_leftPosition + nestWidth).clamp(0, widget.screenWidth - nestWidth);
    }
    else {
      _leftPosition = (widget.screenWidth / 2) - (nestWidth / 2);
    }
    ref.invalidate(controlDirectionsProvider);


    return AnimatedPositioned(
      duration: const Duration(milliseconds: 1000),
      curve: Curves.linear,
      bottom: 0,
      left: _leftPosition,
      child: SvgPicture.asset('./assets/images/nest.svg',
        key: nestKey,
        width: nestWidth,
        height: nestWidth / 2,
        fit: BoxFit.contain,
      ),
    );
  }
}