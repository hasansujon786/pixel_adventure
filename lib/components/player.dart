import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:pixel_adventure/components/components.dart';
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
  late SpriteAnimation jumpAnimation;
  late SpriteAnimation fallAnimation;
  late SpriteAnimation hitAnimatin;
  late SpriteAnimation appearingAnimating;
  late SpriteAnimation disappearingAnimating;

  List<CollisionBlock> collisionBlocks = [];
  final hitbox = CustomHitBox(offsetX: 10, offsetY: 4, width: 14, height: 28);

  PlayerState playerState = PlayerState.idle;

  final _gravity = 9.8;
  final _jumpForce = 350.0;
  final _terminalVelocity = 300.0;
  var _startingPosition = Vector2.zero();

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
  bool hasJumped = false;
  bool gotHit = false;
  bool reachedCheckopint = false;

  @override
  Future<void> onLoad() async {
    debugMode = false;

    await _loadAllAniamittons();
    _startingPosition = Vector2(position.x, position.y);
    add(
      RectangleHitbox(
        position: Vector2(hitbox.offsetX, hitbox.offsetY),
        size: Vector2(hitbox.width, hitbox.height),
      ),
    );
    _setupButtons();
    super.onLoad();
  }

  @override
  void update(dt) {
    if (game.showControlls) {
      _updateJoyStick();
    }
    if (!gotHit && !reachedCheckopint) {
      _updatePlayerMovement(dt);
      _updatePlayerState(dt);
      _checkHorizontalCollisions();
      _checkGravity(dt);
      _checkVerticalCollisions();
    }
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

    hasJumped = keysPressed.contains(LogicalKeyboardKey.space);

    return super.onKeyEvent(event, keysPressed);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (!reachedCheckopint) {
      if (other is Fruit) other.collidedWithPlayer();
      if (other is Saw) if (!gotHit) _respawn();
      if (other is Checkpoint) _reachedCheckpoint();
    }

    super.onCollision(intersectionPoints, other);
  }

  Future<void> _reachedCheckpoint() async {
    final originalSize = size.clone();
    size = Vector2.all(96);

    if (scale.x > 0) {
      position = position - originalSize;
    } else if (scale.x < 0) {
      position = position - Vector2(-originalSize.x, originalSize.y);
    }

    current = PlayerState.disappearing;
    reachedCheckopint = true;
    // Wait for the 'disappearing' animation to finish
    await animationTicker?.completed;

    size = originalSize;
    position = Vector2.all(-640);
    reachedCheckopint = false;

    game.loadNextLevel();
  }

  Future<void> _respawn() async {
    current = PlayerState.hit;
    gotHit = true;
    // Wait for the 'hit' animation to finish
    await animationTicker?.completed;

    scale.x = 1;
    final originalSize = size.clone();
    size = Vector2.all(96);
    position = _startingPosition - originalSize;
    current = PlayerState.appearing;

    // Reset the ticker and wait for 'appearing' to finish
    animationTicker?.reset();
    await animationTicker?.completed;

    // Restore baseline state and unfreeze controls
    position = _startingPosition.clone();
    size = originalSize;
    current = PlayerState.idle;
    velocity = Vector2.zero();
    gotHit = false; // Re-enables player input and physics updates
  }

  void _setupButtons() {
    game.jumpButton.onPressed = () => hasJumped = true;
    game.jumpButton.onReleased = () => hasJumped = false;
    game.jumpButton.onCancelled = () => hasJumped = false;
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
    idleAnimation = game.images.createAnimation(character.idle.flamePath, 11);
    runAnimation = game.images.createAnimation(character.run.flamePath, 12);
    jumpAnimation = game.images.createAnimation(character.jumped.flamePath, 1);
    fallAnimation = game.images.createAnimation(character.fall.flamePath, 1);
    hitAnimatin = game.images.createAnimation(
      character.hit.flamePath,
      7,
      loop: false,
    );
    appearingAnimating = game.images.createAnimation(
      Assets.images.mainCharacters.appearing96x96.flamePath,
      7,
      squareSize: 96,
      loop: false,
    );
    disappearingAnimating = game.images.createAnimation(
      Assets.images.mainCharacters.desappearing96x96.flamePath,
      7,
      squareSize: 96,
      loop: false,
    );

    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.running: runAnimation,
      PlayerState.jumping: jumpAnimation,
      PlayerState.falling: fallAnimation,
      PlayerState.hit: hitAnimatin,
      PlayerState.appearing: appearingAnimating,
      PlayerState.disappearing: disappearingAnimating,
    };

    current = PlayerState.idle;
  }

  void _updatePlayerMovement(double dt) {
    if (hasJumped && isOnGround) _playerJump(dt);

    // if (velocity.x > _gravity) isOnGround = false;

    velocity.x = horizontalMovement * moveSpeed;
    position.x += velocity.x * dt;
  }

  void _playerJump(double dt) {
    velocity.y = -_jumpForce;
    position.y += velocity.y * dt;
    isOnGround = false;
    hasJumped = false;
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

    if (velocity.y > 0) playerState = .falling;
    if (velocity.y < 0) playerState = .jumping;

    current = playerState;
  }

  void _checkHorizontalCollisions() {
    for (final block in collisionBlocks) {
      if (!block.isPlatform) {
        if (checkCollision(this, block)) {
          if (velocity.x > 0) {
            velocity.x = 0;
            position.x = block.x - hitbox.offsetX - hitbox.width;
            break;
          }
          if (velocity.x < 0) {
            velocity.x = 0;
            position.x = block.x + block.width + hitbox.width + hitbox.offsetX;
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

  void _checkVerticalCollisions() {
    for (final block in collisionBlocks) {
      if (block.isPlatform) {
        if (checkCollision(this, block)) {
          if (velocity.y > 0) {
            velocity.y = 0;
            position.y = block.y - hitbox.height - hitbox.offsetY;
            isOnGround = true;
            break;
          }
        }
      } else {
        if (checkCollision(this, block)) {
          if (velocity.y > 0) {
            velocity.y = 0;
            position.y = block.y - hitbox.height - hitbox.offsetY;
            isOnGround = true;
            break;
          }
          if (velocity.y < 0) {
            velocity.y = 0;
            position.y = block.y + block.height - hitbox.offsetY;
          }
        }
      }
    }
  }
}

enum PlayerState {
  idle,
  running,
  falling,
  jumping,
  hit,
  appearing,
  disappearing,
}

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

  AssetGenImage get fall => switch (this) {
    ninja => Assets.images.mainCharacters.ninjaFrog.fall32x32,
    maskDude => Assets.images.mainCharacters.maskDude.fall32x32,
  };

  AssetGenImage get jumped => switch (this) {
    ninja => Assets.images.mainCharacters.ninjaFrog.jump32x32,
    maskDude => Assets.images.mainCharacters.maskDude.jump32x32,
  };

  AssetGenImage get doubleJumped => switch (this) {
    ninja => Assets.images.mainCharacters.ninjaFrog.doubleJump32x32,
    maskDude => Assets.images.mainCharacters.maskDude.doubleJump32x32,
  };

  AssetGenImage get hit => switch (this) {
    ninja => Assets.images.mainCharacters.ninjaFrog.hit32x32,
    maskDude => Assets.images.mainCharacters.maskDude.hit32x32,
  };

  AssetGenImage get walljump => switch (this) {
    ninja => Assets.images.mainCharacters.ninjaFrog.wallJump32x32,
    maskDude => Assets.images.mainCharacters.maskDude.wallJump32x32,
  };
}
