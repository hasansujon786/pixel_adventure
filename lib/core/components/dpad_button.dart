import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:pixel_adventure/flame/asset_gen_image.dart';
import 'package:pixel_adventure/gen/assets.gen.dart';

class JumpButton extends HudButtonComponent {
  JumpButton({super.margin, super.size, super.position});

  @override
  FutureOr<void> onLoad() {
    // Normal / unpressed state
    button = SpriteComponent(
      sprite: Sprite(
        game.images.fromCache(
          Assets.images.hub.smallHandleFilledGrey.flamePath,
        ),
      ),
      size: size,
    );

    // Optional: visual feedback when button is pressed
    buttonDown = SpriteComponent(
      sprite: Sprite(
        game.images.fromCache(
          Assets.images.hub.smallHandleFilledGrey.flamePath,
        ),
      ),
      size: size - Vector2(10, 10),
    );

    return super.onLoad();
  }
}
