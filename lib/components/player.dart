import 'package:flame/components.dart';
import 'package:pixel_adventure/flame/asset_gen_image.dart';
import 'package:pixel_adventure/gen/assets.gen.dart';

class Player extends SpriteComponent {
  Player({super.position})
    : super(size: Vector2.all(32), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    sprite = await Assets.images.mainCharacters.maskDude.jump32x32.loadSprite();
  }
}
