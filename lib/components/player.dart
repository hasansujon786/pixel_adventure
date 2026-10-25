import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:pixel_adventure/components/components.dart';
import 'package:pixel_adventure/core/core.dart';
import 'package:pixel_adventure/flame/asset_gen_image.dart';
import 'package:pixel_adventure/gen/assets.gen.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

class Player({final PlayerCharacter character = .ninja, super.position, super.anchor})
    extends SpriteAnimationGroupComponent<PlayerState>
    with HasGameReference<PixelAdventure>, KeyboardHandler, CollisionCallbacks {
  this : super(size: Vector2.all(32));

  // --- Collision & Hitbox Config ---
  List<CollisionBlock> collisionBlocks = []; // Active solid blocks and platforms in level
  final hitbox = CustomHitBox(offsetX: 10, offsetY: 4, width: 14, height: 28); // Inner character body bounds

  // --- Physics Constants (Kinematic Units) ---
  static const double _jumpForce = 350.0; // Instant upward impulse speed (px/s)
  static const double _moveSpeed = 100.0; // Horizontal running speed (px/s)
  static const double _gravity = 980.0; // Downward gravity acceleration (px/s²)
  static const double _terminalVelocity = 300.0; // Terminal downward falling cap (px/s)

  // --- State & Position Tracking ---
  var _startingPosition = Vector2.zero(); // Respawn coordinate snapshot
  Vector2 velocity = Vector2.zero(); // Current movement vector (px/s)
  PlayerState playerState = .idle; // Active animation state key

  // --- Directional Input Accumulators ---
  int _keyboardMovement = 0; // Key input (-1: left, 1: right)
  int _joystickMovement = 0; // Stick input (-1: left, 1: right)
  int get horizontalMovement => (_keyboardMovement + _joystickMovement).clamp(-1, 1);
  set horizontalMovement(int value) => _joystickMovement = value;

  // --- Status Flags ---
  bool isFacingRight = true; // Horizontal sprite flip orientation
  bool isOnGround = false; // Ground/platform contact indicator
  bool hasJumped = false; // Jump trigger flag for physics tick
  bool gotHit = false; // Hit/death animation lockout flag
  bool reachedCheckpoint = false; // Level-exit animation lockout flag

  @override
  Future<void> onLoad() async {
    debugMode = false;

    await _loadAllAnimations();
    _startingPosition = Vector2(position.x, position.y);

    add(RectangleHitbox(position: Vector2(hitbox.offsetX, hitbox.offsetY), size: Vector2(hitbox.width, hitbox.height)));

    _setupButtons();
    super.onLoad();
  }

  /// Variable-time loop: input polling, HUD sync, and animation updates.
  @override
  void update(double dt) {
    if (game.showControlls) {
      _updateJoyStick();
    }

    if (!gotHit && !reachedCheckpoint) {
      _updatePlayerVisualState();
    }

    super.update(dt);
  }

  /// Fixed 60Hz physics tick called from PixelAdventure._fixedPhysicsUpdate.
  void physicsUpdate(double step) {
    if (gotHit || reachedCheckpoint) return;

    _updatePlayerHorizontalMovement(step);
    _checkHorizontalCollisions();
    _applyGravityAndVerticalMovement(step);
    _checkVerticalCollisions();
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    _keyboardMovement = 0;
    final isLeftKeyPressed =
        keysPressed.contains(LogicalKeyboardKey.keyA) || keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    final isRightKeyPressed =
        keysPressed.contains(LogicalKeyboardKey.keyD) || keysPressed.contains(LogicalKeyboardKey.arrowRight);

    _keyboardMovement += isLeftKeyPressed ? -1 : 0;
    _keyboardMovement += isRightKeyPressed ? 1 : 0;

    if (keysPressed.contains(LogicalKeyboardKey.space)) {
      hasJumped = true;
    }

    return super.onKeyEvent(event, keysPressed);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (!reachedCheckpoint) {
      if (other is Fruit) other.collidedWithPlayer();
      if (other is Saw && !gotHit) _respawn();
      if (other is Checkpoint) _reachedCheckpoint();
    }
    super.onCollision(intersectionPoints, other);
  }

  void _updatePlayerHorizontalMovement(double step) {
    if (hasJumped && isOnGround) {
      _playerJump();
    }

    velocity.x = horizontalMovement * _moveSpeed;
    position.x += velocity.x * step;
  }

  void _playerJump() {
    velocity.y = -_jumpForce;
    isOnGround = false;
    hasJumped = false;
  }

  void _applyGravityAndVerticalMovement(double step) {
    velocity.y += _gravity * step;
    velocity.y = velocity.y.clamp(-_jumpForce, _terminalVelocity);
    position.y += velocity.y * step;
  }

  void _updatePlayerVisualState() {
    playerState = .idle;

    if (velocity.x < 0 && scale.x > 0) {
      flipHorizontallyAroundCenter();
      isFacingRight = false;
    } else if (velocity.x > 0 && scale.x < 0) {
      flipHorizontallyAroundCenter();
      isFacingRight = true;
    }

    if (velocity.x != 0) playerState = .running;
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

  Future<void> _reachedCheckpoint() async {
    velocity = Vector2.zero();
    final originalSize = size.clone();
    size = Vector2.all(96);

    if (scale.x > 0) {
      position = position - originalSize;
    } else if (scale.x < 0) {
      position = position - Vector2(-originalSize.x, originalSize.y);
    }

    current = .disappearing;
    reachedCheckpoint = true;

    await animationTicker?.completed;

    size = originalSize;
    position = Vector2.all(-640);
    reachedCheckpoint = false;

    game.loadNextLevel();
  }

  Future<void> _respawn() async {
    gotHit = true;
    velocity = Vector2.zero();

    current = .hit;
    animationTicker?.reset();
    await animationTicker?.completed;

    scale.x = 1;
    isFacingRight = true;
    final originalSize = size.clone();

    size = Vector2.all(96);
    position = _startingPosition - (Vector2.all(96) - originalSize) / 2;
    current = .appearing;

    animationTicker?.reset();
    await animationTicker?.completed;

    position = _startingPosition.clone();
    size = originalSize;
    current = .idle;
    velocity = Vector2.zero();
    gotHit = false;
  }

  void _setupButtons() {
    game.jumpButton.onPressed = () => hasJumped = true;
    game.jumpButton.onReleased = () => hasJumped = false;
    game.jumpButton.onCancelled = () => hasJumped = false;
  }

  void _updateJoyStick() {
    switch (game.joyStick.direction) {
      case .upLeft:
      case .downLeft:
      case .left:
        _joystickMovement = -1;
        break;
      case .upRight:
      case .downRight:
      case .right:
        _joystickMovement = 1;
        break;
      default:
        _joystickMovement = 0;
        break;
    }
  }

  Future<void> _loadAllAnimations() async {
    // dart format off
    animations = {
      .idle: game.images.createAnimation(character.idle.flamePath, 11),
      .running: game.images.createAnimation(character.run.flamePath, 12),
      .jumping: game.images.createAnimation(character.jumped.flamePath, 1),
      .falling: game.images.createAnimation(character.fall.flamePath, 1),
      .hit: game.images.createAnimation(character.hit.flamePath, 7, loop: false),
      .appearing: game.images.createAnimation(PlayerCharacter.appearing.flamePath, 7, squareSize: 96, loop: false),
      .disappearing: game.images.createAnimation(PlayerCharacter.desappearing.flamePath, 7, squareSize: 96, loop: false),
    };
    // dart format on

    current = .idle;
  }
}

enum PlayerState { idle, running, falling, jumping, hit, appearing, disappearing }

enum PlayerDirection { left, right, none }

enum PlayerCharacter {
  ninja,
  maskDude;

  static final appearing = Assets.images.mainCharacters.appearing96x96;
  static final desappearing = Assets.images.mainCharacters.desappearing96x96;

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
