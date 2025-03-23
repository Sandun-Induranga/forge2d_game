import 'dart:ui' as ui;
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame/extensions.dart';
import 'package:flame/components.dart';
import 'package:flame_kenney_xml/flame_kenney_xml.dart';
import 'package:flutter/services.dart';
import 'package:forge2d_game/widgets/background.dart';

class MyPhysicsGame extends Forge2DGame {
  MyPhysicsGame()
      : super(
          gravity: Vector2(0, 10),
          camera: CameraComponent.withFixedResolution(
            width: 800,
            height: 600,
          ),
        );

  late final XmlSpriteSheet aliens;
  late final XmlSpriteSheet elements;
  late final XmlSpriteSheet tiles;

  @override
  Future<void> onLoad() async {
    final [backgroundImage, aliensImage, elementsImage, tilesImage] = await [
      images.load('colored_grass.png'),
      images.load('spritesheet_aliens.png'),
      images.load('spritesheet_elements.png'),
      images.load('spritesheet_tiles.png'),
    ].wait;

    aliens = XmlSpriteSheet(
      image: aliensImage,
      xml: await rootBundle.loadString('assets/spritesheet_aliens.xml'),
    );

    elements = XmlSpriteSheet(
      image: elementsImage,
      xml: await rootBundle.loadString('assets/spritesheet_elements.xml'),
    );

    tiles = XmlSpriteSheet(
      image: tilesImage,
      xml: await rootBundle.loadString('assets/spritesheet_tiles.xml'),
    );

    await world.add(Background(sprite: Sprite(backgroundImage as ui.Image)));

    return super.onLoad();
  }
}
