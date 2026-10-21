import 'package:flame/cache.dart';
import 'package:flame/components.dart';

extension AnimationLoader on Images {
  SpriteAnimation createAnimation(
    String path,
    int amount, {
    double stepTime = 0.05,
    Vector2? textureSize,
    double? squareSize,
    bool loop = true,
  }) {
    return SpriteAnimation.fromFrameData(
      fromCache(path),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: stepTime,
        textureSize: textureSize ?? Vector2.all(squareSize ?? 32),
        loop: loop,
      ),
    );
  }
}
