import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

const enemySize = 5.0;

enum EnemyColor {
  pink(color: 'pink', boss: false),
  blue(color: 'blue', boss: false),
  green(color: 'green', boss: false),
  yellow(color: 'yellow', boss: false),
  pinkBoss(color: 'pink', boss: true),
  blueBoss(color: 'blue', boss: true),
  greenBoss(color: 'green', boss: true),
  yellowBoss(color: 'yellow', boss: true);

  final String color;
  final bool boss;

  const EnemyColor({
    required this.color,
    required this.boss,
  });

  static EnemyColor get randomColor =>
      EnemyColor.values[Random().nextInt(EnemyColor.values.length)];

  String get fileName =>
      'alien${color.capitalize}${boss ? '_suit' : '_square'}.png';
}

class Enemy extends BodyComponent with ContactCallbacks {
  Enemy(Vector2 position, Sprite sprite)
      : super(
          renderBody: false,
          bodyDef: BodyDef()
            ..position = position
            ..type = BodyType.dynamic,
          fixtureDefs: [
            FixtureDef(
              PolygonShape()..setAsBoxXY(enemySize / 2, enemySize / 2),
              friction: 0.3,
            ),
          ],
          children: [
            SpriteComponent(
              sprite: sprite,
              size: Vector2.all(enemySize),
              anchor: Anchor.center,
              position: Vector2(0, 0),
            ),
          ],
        );

  @override
  void beginContact(
    Object other,
    Contact contact,
  ) {
    var interceptVelocity =
        (contact.bodyA.linearVelocity - contact.bodyB.linearVelocity)
            .length
            .abs();
    if (interceptVelocity > 35) {
      removeFromParent();
    }
    super.beginContact(other, contact);
  }

  @override
  update(double dt) {
    super.update(dt);
    if (position.x > camera.visibleWorldRect.right + 10 ||
        position.x < camera.visibleWorldRect.left - 10) {
      removeFromParent();
    }
  }
}

extension on String {
  String get capitalize => characters.first.toUpperCase() + characters.skip(1).toLowerCase().join();
  // String capitalize() => this[0].toUpperCase() + substring(1).toLowerCase();
}
