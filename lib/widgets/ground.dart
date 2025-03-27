import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:forge2d_game/widgets/body_component.dart';

const groundSize = 7.0;

class Ground extends BodyComponentWithUserData {
  Ground(Vector2 position, Sprite sprite)
      : super(
          renderBody: false,
          bodyDef: BodyDef()
            ..position = position
            ..type = BodyType.static,
          fixtureDefs: [
            FixtureDef(
              PolygonShape()..setAsBoxXY(groundSize / 2, groundSize / 2),
              friction: 0.3,
            ),
          ],
          children: [
            SpriteComponent(
              sprite: sprite,
              size: Vector2.all(groundSize),
              anchor: Anchor.center,
              position: Vector2(0, 0),
            )
          ],
        );
}
