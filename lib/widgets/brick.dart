import 'dart:math';

import 'package:flame/extensions.dart' as ui;

const brickScale = 0.5;

enum BrickType {
  explosive(density: 1, friction: 0.5),
  glass(density: 0.5, friction: 0.2),
  metal(density: 1, friction: 0.4),
  stone(density: 2, friction: 1),
  wood(density: 0.25, friction: 0.6);

  final double density;
  final double friction;

  const BrickType({required this.density, required this.friction});

  static BrickType get randomType => values[Random().nextInt(values.length)];
}

enum BrickSize {
  size70x70(ui.Size(70, 70)),
  size140x70(ui.Size(140, 70)),
  size220x70(ui.Size(220, 70)),
  size70x140(ui.Size(70, 140)),
  size140x140(ui.Size(140, 140)),
  size220x140(ui.Size(220, 140)),
  size70x220(ui.Size(70, 220)),
  size140x220(ui.Size(140, 220));

  final ui.Size size;

  const BrickSize(this.size);

  static BrickSize get randomSize => values[Random().nextInt(values.length)];
}

enum BrickDamage { none, some, lots }
