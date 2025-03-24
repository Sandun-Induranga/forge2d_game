import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:forge2d_game/widgets/game.dart';

void main() {
  runApp(
    const GameWidget.controlled(
      gameFactory: MyPhysicsGame.new,
    ),
  );
}
