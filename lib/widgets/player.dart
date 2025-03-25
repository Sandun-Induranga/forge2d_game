import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

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

class Player extends BodyComponent with DragCallbacks {
  Player(Vector2 position, Sprite sprite)
      : _sprite = sprite,
        super(
          renderBody: false,
          bodyDef: BodyDef()
            ..position = position
            ..type = BodyType.static
            ..angularDamping = 0.1
            ..linearDamping = 0.1,
          fixtureDefs: [
            FixtureDef(CircleShape()..radius = playerSize / 2)
              ..restitution = 0.4
              ..density = 0.75
              ..friction = 0.5,
          ],
        );

  final Sprite _sprite;

  @override
  Future<void> onLoad() {
    addAll([
      CustomPainterComponent(
        size: Vector2.all(playerSize),
        anchor: Anchor.center,
        painter: _DragPainter(this),
        position: Vector2(0, 0),
      ),
      SpriteComponent(
        sprite: _sprite,
        size: Vector2.all(playerSize),
        anchor: Anchor.center,
        position: Vector2(0, 0),
      ),
    ]);
    return super.onLoad();
  }

  @override
  update(double dt) {
    super.update(dt);
    if (!body.isAwake) {
      removeFromParent();
    }

    if (position.x > camera.visibleWorldRect.right + 10 ||
        position.x < camera.visibleWorldRect.left - 10) {
      removeFromParent();
    }
  }

  Vector2 _dragStart = Vector2.zero();
  Vector2 _dragDelta = Vector2.zero();
  Vector2 get dragDelta => _dragDelta;

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    if(body.bodyType == BodyType.static) {
      _dragStart = event.localPosition;
    }
  }
}
