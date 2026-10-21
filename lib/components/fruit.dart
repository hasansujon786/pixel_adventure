import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:pixel_adventure/components/components.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

enum FruitInfo(final String path, final String displayName) {
  apple('Items/Fruits/Apple.png', 'Apple'),
  bananas('Items/Fruits/Bananas.png', 'Bananas'),
  cherries('Items/Fruits/Cherries.png', 'Cherries'),
  kiwi('Items/Fruits/Kiwi.png', 'Kiwi'),
  melon('Items/Fruits/Melon.png', 'Melon'),
  orange('Items/Fruits/Orange.png', 'Orange'),
  pineapple('Items/Fruits/Pineapple.png', 'Pineapple'),
  strawberry('Items/Fruits/Strawberry.png', 'Strawberry'),
  collected('Items/Fruits/Collected.png', 'Collected');

  static FruitInfo fromName(String name) {
    return FruitInfo.values.firstWhere(
      (tile) => tile.displayName.toLowerCase() == name.trim().toLowerCase(),
      orElse: () => FruitInfo.apple, // Default fallback
    );
  }
}

class Fruit({final String name = 'Apple', super.position, super.size})
    extends SpriteAnimationComponent
    with HasGameReference<PixelAdventure>, CollisionCallbacks {
  late final FruitInfo fruit = FruitInfo.fromName(name);

  var _collected = false;

  late final hitbox = CustomHitBox(
    offsetX: 10,
    offsetY: 10,
    width: 12,
    height: 12,
  );

  @override
  FutureOr<void> onLoad() {
    priority = -1;
    debugMode = true;

    add(
      RectangleHitbox(
        position: Vector2(hitbox.offsetX, hitbox.offsetY),
        size: Vector2(hitbox.width, hitbox.height),
        collisionType: .passive,
      ),
    );
    animation = _loadAnim(fruit.path, 17);
    return super.onLoad();
  }

  Future<void> collidedWithPlayer() async {
    if (!_collected) {
      animation = SpriteAnimation.fromFrameData(
        game.images.fromCache(FruitInfo.collected.path),
        SpriteAnimationData.sequenced(
          amount: 6,
          stepTime: 0.05,
          textureSize: size,
          loop: false,
        ),
      );
      _collected = true;

      // Await the completion ticker future
      await animationTicker?.completed;

      removeFromParent();
    }
  }

  SpriteAnimation _loadAnim(String path, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache(path),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: 0.05,
        textureSize: size,
      ),
    );
  }
}
