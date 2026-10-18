import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/widgets.dart';
import 'package:pixel_adventure/components/components.dart';
import 'package:pixel_adventure/core/core.dart';

class PixelAdventure extends FlameGame
    with HasKeyboardHandlerComponents, DragCallbacks {
  @override
  Color backgroundColor() => const Color(0xFF211F30);

  late CameraComponent cam;
  late JoystickComponent joyStick = setupJoystick(images);
  final showControlls = true;

  Player player = Player(character: PlayerCharacter.maskDude);

  @override
  FutureOr<void> onLoad() async {
    // Load all images into cache
    await images.loadAllImages();

    _loadLevel();

    return super.onLoad();
  }

  void _loadLevel() {
    Level world = Level(player: player);

    cam = CameraComponent.withFixedResolution(
      world: world,
      width: 640,
      height: 360,
    );
    cam.viewfinder.anchor = Anchor.topLeft;
    cam.priority = 0;

    addAll([cam, world]);

    if (showControlls) {
      add(joyStick);
    }
  }
}
