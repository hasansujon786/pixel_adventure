import 'package:flame/cache.dart';
import 'package:flame/components.dart';
import 'package:flutter/widgets.dart';
import 'package:pixel_adventure/flame/asset_gen_image.dart';
import 'package:pixel_adventure/gen/assets.gen.dart';

JoystickComponent setupJoystick(Images images) {
  const double backgroundSize = 140.0;
  const double knobSize = 64.0;

  return JoystickComponent(
    priority: 10,
    knob: SpriteComponent(
      sprite: Sprite(
        images.fromCache(Assets.images.hub.smallHandleFilledGrey.flamePath),
      ),
      size: Vector2.all(knobSize),
    ),
    background: SpriteComponent(
      sprite: Sprite(
        images.fromCache(Assets.images.hub.joystickSplitted.flamePath),
      ),
      size: Vector2.all(backgroundSize),
    ),
    margin: const EdgeInsets.only(left: 32, bottom: 32),
  );
}
