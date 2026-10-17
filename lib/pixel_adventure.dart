import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/widgets.dart';
import 'package:pixel_adventure/components/components.dart';

class PixelAdventure extends FlameGame
    with HasKeyboardHandlerComponents, DragCallbacks {
  @override
  Color backgroundColor() => const Color(0xFF211F30);
  late CameraComponent cam;
  late JoystickComponent joyStick = JoystickComponent(
    priority: 10,
    knob: SpriteComponent(
      sprite: Sprite(images.fromCache('HUB/SmallHandleFilledGrey.png')),
    ),
    background: SpriteComponent(
      sprite: Sprite(images.fromCache('HUB/JoystickSplitted.png')),
    ),
    margin: EdgeInsets.only(left: 32, bottom: 32),
  );

  Player player = Player(character: .maskDude);

  @override
  FutureOr<void> onLoad() async {
    // Load all images into cache
    await images.loadAllImages();

    _loadLevel();

    return super.onLoad();
  }

  @override
  void update(dt) {
    _updateJoyStick();
    return super.update(dt);
  }

  void _loadLevel() {
    Level world = Level(
      player: player,
      // levelName: levelNames[currentLevelIndex],
    );

    cam = CameraComponent.withFixedResolution(
      world: world,
      width: 640,
      height: 360,
    );
    cam.viewfinder.anchor = Anchor.topLeft;
    cam.priority = 0;

    addAll([cam, world, joyStick]);
  }

  void _updateJoyStick() {
    switch (joyStick.direction) {
      // case JoystickDirection.up:
      //   // TODO: Handle this case.
      //   throw UnimplementedError();
      // case JoystickDirection.upLeft:
      //   // TODO: Handle this case.
      //   throw UnimplementedError();
      // case JoystickDirection.upRight:
      //   // TODO: Handle this case.
      //   throw UnimplementedError();
      // case JoystickDirection.down:
      //   // TODO: Handle this case.
      //   throw UnimplementedError();
      // case JoystickDirection.downRight:
      //   // TODO: Handle this case.
      //   throw UnimplementedError();
      // case JoystickDirection.downLeft:
      //   // TODO: Handle this case.
      //   throw UnimplementedError();
      case JoystickDirection.upLeft:
      case JoystickDirection.downLeft:
      case JoystickDirection.left:
        player.playerDirection = .left;
        break;
      case JoystickDirection.upRight:
      case JoystickDirection.downRight:
      case JoystickDirection.right:
        player.playerDirection = .right;
        break;
      case JoystickDirection.idle:
      default:
        player.playerDirection = .none;
        break;
    }
  }
}
