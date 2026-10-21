import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:pixel_adventure/components/components.dart';
import 'package:pixel_adventure/core/core.dart';
import 'package:pixel_adventure/flame/asset_gen_image.dart';
import 'package:pixel_adventure/gen/assets.gen.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

class Checkpoint({super.position, super.size})
    extends SpriteAnimationComponent
    with HasGameReference<PixelAdventure>, CollisionCallbacks {
  bool reachedCheckopint = false;

  @override
  FutureOr<void> onLoad() {
    add(
      RectangleHitbox(
        position: Vector2(18, 56),
        size: Vector2(12, 8),
        collisionType: .passive,
      ),
    );
    animation = game.images.createAnimation(
      Assets.images.items.checkpoints.checkpoint.checkpointNoFlag.flamePath,
      1,
      stepTime: 1,
      squareSize: 64,
    );

    return super.onLoad();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Player && !reachedCheckopint) _reachedCheckpoint();
    super.onCollision(intersectionPoints, other);
  }

  Future<void> _reachedCheckpoint() async {
    reachedCheckopint = true;

    animation = game.images.createAnimation(
      Assets
          .images
          .items
          .checkpoints
          .checkpoint
          .checkpointFlagOut64x64
          .flamePath,
      26,
      squareSize: 64,
      loop: false,
    );

    await animationTicker?.completed;

    animation = game.images.createAnimation(
      Assets
          .images
          .items
          .checkpoints
          .checkpoint
          .checkpointFlagIdle64x64
          .flamePath,
      10,
      squareSize: 64,
    );
  }
}
