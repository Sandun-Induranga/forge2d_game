import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame/extensions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forge2d_game/widgets/background.dart';
import 'package:forge2d_game/widgets/enemy.dart';
import 'package:forge2d_game/widgets/player.dart';
import 'package:xml/xml.dart';
import 'package:xml/xpath.dart';

import 'brick.dart';
import 'ground.dart';

class MyPhysicsGame extends Forge2DGame {
  MyPhysicsGame()
      : super(
          gravity: Vector2(0, 10),
        );

  late final XmlSpriteSheet aliens;
  late final XmlSpriteSheet elements;
  late final XmlSpriteSheet tiles;

  @override
  Future<void> onLoad() async {
    final cameraComponent = CameraComponent.withFixedResolution(
      width: 800,
      height: 600,
    );
    camera = cameraComponent;
    await add(cameraComponent);
    cameraComponent.viewfinder.zoom = 10.0;

    final [backgroundImage, aliensImage, elementsImage, tilesImage] = await [
      images.load('colored_grass.png'),
      images.load('spritesheet_aliens.png'),
      images.load('spritesheet_elements.png'),
      images.load('spritesheet_tiles.png'),
    ].wait;

    aliens = XmlSpriteSheet(
      aliensImage,
      await rootBundle.loadString('assets/spritesheet_aliens.xml'),
    );

    elements = XmlSpriteSheet(
      elementsImage,
      await rootBundle.loadString('assets/spritesheet_elements.xml'),
    );

    tiles = XmlSpriteSheet(
      tilesImage,
      await rootBundle.loadString('assets/spritesheet_tiles.xml'),
    );
    await world.add(Ground(Vector2(0, 0), tiles.getSprite('grass.png')));
    await world.add(Background(sprite: Sprite(backgroundImage)));
    await addGround();
    unawaited(addBricks().then((_) => addEnemies()));
    await addPlayer();

    return super.onLoad();
  }

  Future<void> addGround() async {
    final groundY = camera.visibleWorldRect.height / 2 - groundSize / 2;
    final visibleWidth = camera.visibleWorldRect.width; // 80.0
    final startX = -visibleWidth / 2; // -40.0
    final endX = visibleWidth / 2; // 40.0

    return world.addAll([
      for (var i = startX; i <= endX; i += groundSize)
        Ground(
          Vector2(i, groundY),
          tiles.getSprite('grass.png'),
        ),
    ]);
  }

  final _random = Random();

  Future<void> addBricks() async {
    for (var i = 0; i < 5; i++) {
      final type = BrickType.randomType;
      final size = BrickSize.randomSize;
      final brick = Brick(
        type: type,
        size: size,
        damage: BrickDamage.some,
        position: Vector2(
            camera.visibleWorldRect.right / 3 +
                (_random.nextDouble() * 5 - 2.5),
            0),
        sprites: brickFileNames(type, size).map(
          (key, value) => MapEntry(
            key,
            elements.getSprite(value),
          ),
        ),
      );
      await world.add(brick);
      await Future.delayed(const Duration(milliseconds: 500));
    }
  }

  Future<void> addPlayer() async {
    final player = Player(
      Vector2(camera.visibleWorldRect.left * 2 / 3, 0),
      aliens.getSprite(PlayerColor.randomColor.fileName),
    );
    await world.add(player);
  }

  // Future<void> addEnemies() async {
  //   for (var i = 0; i < 5; i++) {
  //     final enemy = Enemy(
  //       Vector2(
  //         camera.visibleWorldRect.right / 3 + (_random.nextDouble() * 5 - 2.5),
  //         0,
  //       ),
  //       aliens.getSprite(EnemyColor.randomColor.fileName),
  //     );
  //     await world.add(enemy);
  //     await Future.delayed(const Duration(milliseconds: 500));
  //   }
  // }

  @override
  update(double dt) {
    super.update(dt);
    if (isMounted &&
        world.children.whereType<Player>().isEmpty &&
        world.children.whereType<Enemy>().isNotEmpty) {
      addPlayer();
    }
    if (isMounted &&
        enemiesFullyAdded &&
        world.children.whereType<Enemy>().isEmpty &&
        world.children.whereType<TextComponent>().isEmpty) {
      {
        world.addAll(
          [
            (position: Vector2(0.5, 0.5), color: Colors.white),
            (position: Vector2.zero(), color: Colors.orangeAccent),
          ].map(
            (data) => TextComponent(
              text: 'You win!',
              textRenderer: TextPaint(
                style: TextStyle(
                  color: data.color,
                  fontSize: 16.0,
                ),
              ),
              position: data.position,
              anchor: Anchor.center,
            ),
          ),
        );
      }
    }
  }

  var enemiesFullyAdded = false;

  Future<void> addEnemies() async {
    await Future.delayed(const Duration(seconds: 2));
    for (var i = 0; i < 3; i++) {
      await world.add(Enemy(
        Vector2(
          camera.visibleWorldRect.right / 3 + (_random.nextDouble() * 7 - 3.5),
          (_random.nextDouble() * 3),
        ),
        aliens.getSprite(EnemyColor.randomColor.fileName),
      ));
      await Future.delayed(const Duration(seconds: 1));
    }
    enemiesFullyAdded = true;
  }
}

class XmlSpriteSheet {
  XmlSpriteSheet(this.image, String xml) {
    final document = XmlDocument.parse(xml);
    for (final node in document.xpath('//TextureAtlas/SubTexture')) {
      final name = node.getAttribute('name')!;
      final x = double.parse(node.getAttribute('x')!);
      final y = double.parse(node.getAttribute('y')!);
      final width = double.parse(node.getAttribute('width')!);
      final height = double.parse(node.getAttribute('height')!);
      _rects[name] = Rect.fromLTWH(x, y, width, height);
    }
  }

  final ui.Image image;
  final _rects = <String, Rect>{};

  Sprite getSprite(String name) {
    final rect = _rects[name];
    if (rect == null) {
      throw ArgumentError('Sprite $name not found');
    }
    return Sprite(
      image,
      srcPosition: rect.topLeft.toVector2(),
      srcSize: rect.size.toVector2(),
    );
  }
}
