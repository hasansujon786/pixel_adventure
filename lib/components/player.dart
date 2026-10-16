import 'package:flame/components.dart';
import 'package:pixel_adventure/flame/asset_gen_image.dart';
import 'package:pixel_adventure/gen/assets.gen.dart';

class Player extends SpriteAnimationGroupComponent {
  Player({super.position})
    : super(size: Vector2.all(32), anchor: Anchor.center);

  late SpriteAnimation idleAnimation;

  @override
  Future<void> onLoad() async {
    await _loadAllAniamittons();
  }

  Future<void> _loadAllAniamittons() async {
    idleAnimation = await Assets.images.mainCharacters.maskDude.jump32x32
        .loadSpriteAnimationFromFrameData(
          SpriteAnimationData.sequenced(
            amount: 12,
            stepTime: 0.05,
            textureSize: Vector2.all(32),
          ),
        );
    animations = {};
  }
}
