import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/extensions.dart' as ui;
import 'package:flame_forge2d/flame_forge2d.dart';

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
  return switch ((type, size)) {
    (BrickType.explosive, BrickSize.size70x70) => {
        BrickDamage.none: 'elementExplosive009.png',
        BrickDamage.some: 'elementExplosive012.png',
        BrickDamage.lots: 'elementExplosive050.png',
      },
    (BrickType.glass, BrickSize.size140x70) => {
        BrickDamage.none: 'elementGlass010.png',
        BrickDamage.some: 'elementGlass013.png',
        BrickDamage.lots: 'elementGlass48.png',
      },
    (BrickType.metal, BrickSize.size140x220) => {
        BrickDamage.none: 'elementMetal009.png',
        BrickDamage.some: 'elementMetal012.png',
        BrickDamage.lots: 'elementMetal047.png',
      },
    (BrickType.stone, BrickSize.size140x220) => {
        BrickDamage.none: 'elementStone011.png',
        BrickDamage.some: 'elementStone014.png',
        BrickDamage.lots: 'elementStone054.png',
      },
    (BrickType.wood, BrickSize.size140x220) => {
        BrickDamage.none: 'elementWood020.png',
        BrickDamage.some: 'elementWood025.png',
        BrickDamage.lots: 'elementWood052.png',
      },
    (_, _) => throw ArgumentError('Invalid brick type and size'),
  };
}

class Brick extends BodyComponent {
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
