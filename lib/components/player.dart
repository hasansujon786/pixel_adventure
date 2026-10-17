import 'package:flame/components.dart';
import 'package:pixel_adventure/flame/asset_gen_image.dart';
import 'package:pixel_adventure/gen/assets.gen.dart';

class Player extends SpriteAnimationGroupComponent {
  final PlayerCharacter playerCharacter;

  Player(this.playerCharacter, {super.position, super.anchor})
    : super(size: Vector2.all(32));

  late SpriteAnimation idleAnimation;
  late SpriteAnimation runAnimation;

  @override
  Future<void> onLoad() async {
    await _loadAllAniamittons();
  }

  Future<void> _loadAllAniamittons() async {
    idleAnimation = await _loadAnim(playerCharacter.idle, 11);
    runAnimation = await _loadAnim(playerCharacter.run, 12);

    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.running: runAnimation,
    };

    current = PlayerState.running;
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
