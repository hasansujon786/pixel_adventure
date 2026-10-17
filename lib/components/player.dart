import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:pixel_adventure/flame/asset_gen_image.dart';
import 'package:pixel_adventure/gen/assets.gen.dart';

class Player extends SpriteAnimationGroupComponent with KeyboardHandler {
  final PlayerCharacter character;

  Player({this.character = .ninja, super.position, super.anchor})
    : super(size: Vector2.all(32));

  late SpriteAnimation idleAnimation;
  late SpriteAnimation runAnimation;

  PlayerDirection playerDirection = PlayerDirection.none;
  double moveSpeed = 100;
  Vector2 velocity = Vector2.zero();
  bool isFacingRight = true;

  @override
  Future<void> onLoad() async {
    await _loadAllAniamittons();
    super.onLoad();
  }

  @override
  void update(dt) {
    _updatePlayerMovement(dt);
    super.update(dt);
  }

  @override
  bool onKeyEvent(event, keysPressed) {
    final isLeftKeyPressed =
        keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    final isRightKeyPressed =
        keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight);

    if (isLeftKeyPressed && isRightKeyPressed) {
      playerDirection = .none;
    } else if (isLeftKeyPressed) {
      playerDirection = .left;
    } else if (isRightKeyPressed) {
      playerDirection = .right;
    } else {
      playerDirection = .none;
    }

    return onKeyEvent(event, keysPressed);
  }

  Future<void> _loadAllAniamittons() async {
    idleAnimation = await _loadAnim(character.idle, 11);
    runAnimation = await _loadAnim(character.run, 12);

    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.running: runAnimation,
    };

    current = PlayerState.idle;
  }

  void _updatePlayerMovement(double dt) {
    double dirX = 0.0;
    switch (playerDirection) {
      case .left:
        dirX -= moveSpeed;
        if (isFacingRight) {
          flipHorizontallyAroundCenter();
          isFacingRight = false;
        }
        current = PlayerState.running;
        break;
      case .right:
        dirX += moveSpeed;
        if (!isFacingRight) {
          flipHorizontallyAroundCenter();
          isFacingRight = true;
        }
        current = PlayerState.running;
        break;
      case PlayerDirection.none:
        current = PlayerState.idle;
        break;
    }

    velocity = Vector2(dirX, 0.0);
    position += velocity * dt;
  }

  Future<SpriteAnimation> _loadAnim(AssetGenImage player, int amount) {
    return player.loadSpriteAnimationFromFrameData(
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: 0.05,
        textureSize: Vector2.all(32),
      ),
    );
  }
}

enum PlayerState { idle, running }

enum PlayerDirection { left, right, none }

enum PlayerCharacter {
  ninja,
  maskDude;

  AssetGenImage get idle => switch (this) {
    ninja => Assets.images.mainCharacters.ninjaFrog.idle32x32,
    maskDude => Assets.images.mainCharacters.maskDude.idle32x32,
  };

  AssetGenImage get run => switch (this) {
    ninja => Assets.images.mainCharacters.ninjaFrog.run32x32,
    maskDude => Assets.images.mainCharacters.maskDude.run32x32,
  };
}
