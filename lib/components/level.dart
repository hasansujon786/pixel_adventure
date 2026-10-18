import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:pixel_adventure/components/components.dart';
import 'package:pixel_adventure/components/player.dart';

class Level({
  required final Player player,
  super.children,
  super.priority,
  super.key,
}) extends World {
  late TiledComponent level;
  final List<CollisionBlock> collisionBlocks = [];

  @override
  Future<void> onLoad() async {
    level = await TiledComponent.load('level_01.tmx', Vector2.all(16));

    final spwanPointLayer = level.tileMap.getLayer<ObjectGroup>('Spwanpoints');

    add(level);

    if (spwanPointLayer != null) {
      for (final spwanPoint in spwanPointLayer.objects) {
        switch (spwanPoint.class_) {
          case 'Player':
            player.position = Vector2(spwanPoint.x, spwanPoint.y);
            add(player);
            break;
          default:
            add(player);
        }
      }
    }

    final collisionLayer = level.tileMap.getLayer<ObjectGroup>('Collisions');
    if (collisionLayer != null) {
      for (final collision in collisionLayer.objects) {
        switch (collision.class_) {
          case 'Platform':
            final platform = CollisionBlock(
              position: Vector2(collision.x, collision.y),
              size: Vector2(collision.width, collision.height),
              isPlatform: true,
            );

            collisionBlocks.add(platform);
            add(platform);
            break;
          default:
            final platform = CollisionBlock(
              position: Vector2(collision.x, collision.y),
              size: Vector2(collision.width, collision.height),
            );

            collisionBlocks.add(platform);
            add(platform);
        }
      }
    }

    player.collisionBlocks = collisionBlocks;
    super.onLoad();
  }
}
