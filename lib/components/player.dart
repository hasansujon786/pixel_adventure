import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:pixel_adventure/components/collision_blocks.dart';
import 'package:pixel_adventure/core/core.dart';
import 'package:pixel_adventure/flame/asset_gen_image.dart';
import 'package:pixel_adventure/gen/assets.gen.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

class Player extends SpriteAnimationGroupComponent
    with HasGameReference<PixelAdventure>, KeyboardHandler, CollisionCallbacks {
  final PlayerCharacter character;

  Player({this.character = .ninja, super.position, super.anchor})
    : super(size: Vector2.all(32));

  late SpriteAnimation idleAnimation;
  late SpriteAnimation runAnimation;
  List<CollisionBlock> collisionBlocks = [];

  PlayerState playerState = PlayerState.idle;

  final _gravity = 9.8;
  final _jumpForce = 460.0;
  final _terminalVelocity = 300.0;

  int _keyboardMovement = 0;
  int _joystickMovement = 0;
  int get horizontalMovement =>
      (_keyboardMovement + _joystickMovement).clamp(-1, 1);
  set horizontalMovement(int value) {
    _joystickMovement = value;
  }

  double moveSpeed = 100;
  Vector2 velocity = Vector2.zero();
  bool isFacingRight = true;
  bool isOnGround = false;

  @override
  Future<void> onLoad() async {
    await _loadAllAniamittons();
    debugMode = true;
    super.onLoad();
  }

  @override
  void update(dt) {
    if (game.showControlls) {
      _updateJoyStick();
    }
    _updatePlayerMovement(dt);
    _updatePlayerState(dt);
    _checkHorizontalCollision();
    _checkGravity(dt);
    _checkVerticalCollision();
    super.update(dt);
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    _keyboardMovement = 0;
    final isLeftKeyPressed =
        keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    final isRightKeyPressed =
        keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight);

    _keyboardMovement += isLeftKeyPressed ? -1 : 0;
    _keyboardMovement += isRightKeyPressed ? 1 : 0;

    return super.onKeyEvent(event, keysPressed);
  }

  void _updateJoyStick() {
    switch (game.joyStick.direction) {
      case JoystickDirection.upLeft:
      case JoystickDirection.downLeft:
      case JoystickDirection.left:
        _joystickMovement = -1;
        break;
      case JoystickDirection.upRight:
      case JoystickDirection.downRight:
      case JoystickDirection.right:
        _joystickMovement = 1;
        break;
      default:
        _joystickMovement = 0;
        break;
    }
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
    velocity.x = horizontalMovement * moveSpeed;
    position.x += velocity.x * dt;
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

  void _updatePlayerState(double dt) {
    playerState = .idle;

    if (velocity.x < 0 && scale.x > 0) {
      flipHorizontallyAroundCenter();
    } else if (velocity.x > 0 && scale.x < 0) {
      flipHorizontallyAroundCenter();
    }

    // Check if moving, set running
    if (velocity.x > 0 || velocity.x < 0) playerState = .running;

    current = playerState;
  }

  void _checkHorizontalCollision() {
    for (final block in collisionBlocks) {
      if (!block.isPlatform) {
        if (checkCollision(this, block)) {
          if (velocity.x > 0) {
            // handle right collision
            velocity.x = 0;
            position.x = block.x - width;
            break;
          } else if (velocity.x < 0) {
            // handle left collision
            velocity.x = 0;
            position.x = block.x + block.width + width;
            break;
          }
        }
      }
    }
  }

  void _checkGravity(double dt) {
    velocity.y += _gravity;
    velocity.y = velocity.y.clamp(-_jumpForce, _terminalVelocity);
    position.y += velocity.y * dt;
  }

  void _checkVerticalCollision() {
    for (final block in collisionBlocks) {
      if (block.isPlatform) {
      } else {
        if (checkCollision(this, block)) {
          // if falling
          if (velocity.y > 0) {
            velocity.y = 0;
            position.y = block.y - height;
            isOnGround = true;
            break;
          }

          // if going up
          if (velocity.y < 0) {
            velocity.y = 0;
            position.y = block.y + height;
          }
        }
      }
    }
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
