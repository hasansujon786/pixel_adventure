import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/widgets.dart';
import 'package:pixel_adventure/components/components.dart';
import 'package:pixel_adventure/core/core.dart';

import 'gen/assets.gen.dart';

class PixelAdventure extends FlameGame
    with HasKeyboardHandlerComponents, DragCallbacks, HasCollisionDetection {
  @override
  Color backgroundColor() => const Color(0xFF211F30);

  int currentLevel = 0;
  static final levels = [Assets.tiles.level01, Assets.tiles.level01];

  late CameraComponent cam;
  late JoystickComponent joyStick = setupJoystick(images);
  late final jumpButton = JumpButton(
    size: Vector2.all(70),
    margin: const EdgeInsets.only(right: 64, bottom: 64),
  );
  final showControlls = true;

  Player player = Player(character: PlayerCharacter.maskDude);

  @override
  FutureOr<void> onLoad() async {
    // Load all images into cache
    await images.loadAllImages();

    _loadLevel();

    return super.onLoad();
  }

  void loadNextLevel({int delay = 0}) {
    if (currentLevel < levels.length - 1) {
      currentLevel++;
      _loadLevel(delay: delay);
    }
  }

  void loadPrevLevel() {
    if (currentLevel > 0) {
      currentLevel--;
      _loadLevel();
    }
  }

  void _loadLevel({int delay = 0}) async {
    if (delay > 0) {
      await Future.delayed(Duration(milliseconds: delay));
    }

    Level world = Level(player: player, levelName: levels[currentLevel]);

    cam = CameraComponent.withFixedResolution(
      world: world,
      width: 640,
      height: 360,
    );
    cam.viewfinder.anchor = Anchor.topLeft;
    cam.priority = 0;

    addAll([cam, world]);

    if (showControlls) {
      addAll([joyStick, jumpButton]);
    }
  }
}
