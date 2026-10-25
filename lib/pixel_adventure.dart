import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/widgets.dart';
import 'package:pixel_adventure/components/components.dart';
import 'package:pixel_adventure/core/core.dart';

import 'gen/assets.gen.dart';

class PixelAdventure() extends FlameGame with HasKeyboardHandlerComponents, DragCallbacks, HasCollisionDetection {
  @override
  Color backgroundColor() => const Color(0xFF211F30);

  // --- Fixed Timestep Physics Constants ---
  static const double fixedTimeStep = 1.0 / 60.0; // 60 ticks per second (16.6ms)
  double _accumulator = 0.0; // Accumulated frame delta time

  int currentLevel = 0;
  static final levels = [Assets.tiles.level01, Assets.tiles.level01];

  late CameraComponent cam;
  Level? _currentWorld;

  late JoystickComponent joyStick = setupJoystick(images);
  late final jumpButton = JumpButton(size: Vector2.all(70), margin: const EdgeInsets.only(right: 64, bottom: 64));

  final showControlls = true;
  Player player = Player(character: .maskDude);

  @override
  FutureOr<void> onLoad() async {
    await images.loadAllImages();
    await _loadLevel();
    return super.onLoad();
  }

  /// Variable-time game loop: drives fixed physics sub-stepping, animations, and rendering.
  @override
  void update(double dt) {
    // Clamp to 100ms to prevent spiral of death during heavy lag or tab switching
    _accumulator += dt.clamp(0.0, 0.1);

    // Run deterministic physics updates at 60 Hz
    while (_accumulator >= fixedTimeStep) {
      _fixedPhysicsUpdate(fixedTimeStep);
      _accumulator -= fixedTimeStep;
    }

    super.update(dt); // Flame default update: ticks animations, tickers, and standard components
  }

  /// Dispatches the fixed physics step to the player and physics entities.
  void _fixedPhysicsUpdate(double step) {
    player.physicsUpdate(step);
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

  Future<void> _loadLevel({int delay = 0}) async {
    if (delay > 0) {
      await Future<void>.delayed(Duration(milliseconds: delay));
    }

    // Remove old world and camera before loading next level
    if (_currentWorld != null) {
      removeWhere((component) => component == _currentWorld || component == cam);
    }

    final world = Level(player: player, levelName: levels[currentLevel]);
    _currentWorld = world;

    cam = CameraComponent.withFixedResolution(world: world, width: 640, height: 360);
    cam.viewfinder.anchor = .topLeft;
    cam.priority = 0;

    await addAll([cam, world]);

    // Attach HUD controls to the viewport so they stick to the screen
    if (showControlls) {
      // cam.viewport.removeWhere((c) => c == joyStick || c == jumpButton);
      await addAll([joyStick, jumpButton]);
    }
  }
}
