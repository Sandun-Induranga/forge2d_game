import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

const groundSize = 7.0;

class Ground extends BodyComponent {
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
        );
}
