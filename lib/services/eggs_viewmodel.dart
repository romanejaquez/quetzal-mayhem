import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EggsViewmodel extends StateNotifier<List<Widget>> {
  EggsViewmodel() : super([]);

  void addEgg(Widget egg) {
    state = [...state, egg];
  }

  void removeEgg(Widget egg) {
    state = state.where((e) => e == egg).toList();
  }
}