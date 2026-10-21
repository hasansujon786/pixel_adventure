import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:pixel_adventure/gen/assets.gen.dart';
import 'package:pixel_adventure/pixel_adventure.dart';
import 'package:pixel_adventure/flame/asset_gen_image.dart';

class Saw({
  final bool isVertical = false,
  final double offsetNeg = 0,
  final double offsetPos = 0,
  super.position,
  super.size,
}) extends SpriteAnimationComponent with HasGameReference<PixelAdventure> {
  static const sawSpeed = 0.03;
  static const moveSpeed = 50;
  static const tileSize = 16;

  double moveDirection = 1;
  double rangePos = 0;
  double rangeNeg = 0;

  @override
  FutureOr<void> onLoad() {
    priority = -1;
    debugMode = false;

    if (isVertical == true) {
      rangeNeg = position.y - offsetNeg * tileSize;
      rangePos = position.y + offsetPos * tileSize;
    } else {
      rangeNeg = position.x - offsetNeg * tileSize;
      rangePos = position.x + offsetPos * tileSize;
    }

    add(CircleHitbox());

    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache(Assets.images.traps.saw.on38x38.flamePath),
      SpriteAnimationData.sequenced(
        amount: 8,
        stepTime: sawSpeed,
        textureSize: Vector2.all(38),
      ),
    );
    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (isVertical == true) {
      _moveVertically(dt);
    } else {
      _moveHorizontally(dt);
    }

    super.update(dt);
  }

  void _moveHorizontally(double dt) {
    if (position.x >= rangePos) {
      moveDirection = -1;
    } else if (position.x <= rangeNeg) {
      moveDirection = 1;
    }
    position.x += moveSpeed * dt * moveDirection;
  }

  void _moveVertically(double dt) {
    if (position.y >= rangePos) {
      moveDirection = -1;
    } else if (position.y <= rangeNeg) {
      moveDirection = 1;
    }
    position.y += moveSpeed * dt * moveDirection;
  }
}
