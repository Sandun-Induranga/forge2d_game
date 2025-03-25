import 'dart:math';

const playerSize = 5.0;

enum PlayerColor {
  pink,
  blue,
  green,
  yellow;

  String get fileName {
    return 'alien${toString().split('.').last.toUpperCase()}_round.png';
  }

  static PlayerColor get randomColor =>
      PlayerColor.values[Random().nextInt(PlayerColor.values.length)];
}
