import 'package:flame/flame.dart';
import 'package:flame/extensions.dart';
import 'package:flame/sprite.dart';
import 'package:pixel_adventure/gen/assets.gen.dart';

const _flameImagesPrefix = 'assets/images/';

extension FlameAssetGenImage on AssetGenImage {
  String get flamePath {
    return path.startsWith(_flameImagesPrefix)
        ? path.substring(_flameImagesPrefix.length)
        : path;
  }

  Future<Sprite> loadSprite({Vector2? srcPosition, Vector2? srcSize}) {
    return Sprite.load(flamePath, srcPosition: srcPosition, srcSize: srcSize);
  }

  Future<SpriteAnimation> loadSpriteAnimation(SpriteAnimationData data) {
    return SpriteAnimation.load(flamePath, data);
  }

  Future<SpriteAnimation> loadSpriteAnimationFromFrameData(
    SpriteAnimationData data,
  ) async {
    final image = await Flame.images.load(flamePath);
    return SpriteAnimation.fromFrameData(image, data);
  }
}
