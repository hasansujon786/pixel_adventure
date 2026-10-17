import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:pixel_adventure/components/player.dart';

class Level({
  required final Player player,
  super.children,
  super.priority,
  super.key,
}) extends World {
  late TiledComponent level;

  @override
  Future<void> onLoad() async {
    level = await TiledComponent.load('level_01.tmx', Vector2.all(16));

    final spwanPointLayer = level.tileMap.getLayer<ObjectGroup>('Spwanpoints');

    add(level);

    for (final spwanPoint in spwanPointLayer!.objects) {
      switch (spwanPoint.class_) {
        case 'Player':
          player.position = Vector2(spwanPoint.x, spwanPoint.y);
          add(player);
          break;
        default:
          add(player);
      }
    }

    super.onLoad();
  }
}
