import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/extensions.dart' as ui;
import 'package:flame_forge2d/flame_forge2d.dart';

import 'body_component.dart';

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

Map<BrickDamage, String> brickFileNames(BrickType type, BrickSize size) {
  final baseName = switch (type) {
    BrickType.explosive => 'elementExplosive',
    BrickType.glass => 'elementGlass',
    BrickType.metal => 'elementMetal',
    BrickType.stone => 'elementStone',
    BrickType.wood => 'elementWood',
  };

  return switch (size) {
    BrickSize.size70x70 => {
      BrickDamage.none: '${baseName}001.png',
      BrickDamage.some: '${baseName}010.png',
      BrickDamage.lots: '${baseName}020.png',
    },
    BrickSize.size140x70 => {
      BrickDamage.none: '${baseName}000.png',
      BrickDamage.some: '${baseName}007.png',
      BrickDamage.lots: '${baseName}013.png',
    },
    BrickSize.size220x70 => {
      BrickDamage.none: '${baseName}013.png',
      BrickDamage.some: '${baseName}016.png',
      BrickDamage.lots: '${baseName}029.png',
    },
    BrickSize.size70x140 => {
      BrickDamage.none: '${baseName}017.png',
      BrickDamage.some: '${baseName}033.png',
      BrickDamage.lots: '${baseName}038.png',
    },
    BrickSize.size140x140 => {
      BrickDamage.none: '${baseName}018.png',
      BrickDamage.some: '${baseName}034.png',
      BrickDamage.lots: '${baseName}039.png',
    },
    BrickSize.size220x140 => {
      BrickDamage.none: '${baseName}019.png',
      BrickDamage.some: '${baseName}035.png',
      BrickDamage.lots: '${baseName}040.png',
    },
    BrickSize.size70x220 => {
      BrickDamage.none: '${baseName}020.png',
      BrickDamage.some: '${baseName}036.png',
      BrickDamage.lots: '${baseName}041.png',
    },
    BrickSize.size140x220 => {
      BrickDamage.none: '${baseName}021.png',
      BrickDamage.some: '${baseName}037.png',
      BrickDamage.lots: '${baseName}042.png',
    },
  };
}

class Brick extends BodyComponentWithUserData {
  Brick({
    required this.type,
    required this.size,
    required BrickDamage damage,
    required Vector2 position,
    required Map<BrickDamage, Sprite> sprites,
  })  : _damage = damage,
        _sprites = sprites,
        super(
          renderBody: false,
          bodyDef: BodyDef()
            ..position = position
            ..type = BodyType.dynamic,
          fixtureDefs: [
            FixtureDef(
              PolygonShape()
                ..setAsBoxXY(
                  size.size.width * brickScale / 20,
                  size.size.height * brickScale / 20,
                ),
            )
              ..restitution = 0.4
              ..density = type.density
              ..friction = type.friction,
          ],
        );

  late final SpriteComponent _spriteComponent;

  final BrickType type;
  final BrickSize size;
  final Map<BrickDamage, Sprite> _sprites;
  BrickDamage _damage;

  BrickDamage get damage => _damage;

  set damage(BrickDamage value) {
    _damage = value;
    _spriteComponent.sprite = _sprites[value]!;
  }

  @override
  Future<void> onLoad() {
    _spriteComponent = SpriteComponent(
      sprite: _sprites[_damage],
      size: size.size.toVector2() / 10 * brickScale,
      anchor: Anchor.center,
      scale: Vector2.all(1),
      position: Vector2(0, 0),
    );
    add(_spriteComponent);
    return super.onLoad();
  }
}
