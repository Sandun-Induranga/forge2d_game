import 'package:flame/game.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    const GameWidget.controlled(
      gameFactory: FlameGame.new,
    ),
  );
}
