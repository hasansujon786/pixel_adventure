import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:pixel_adventure/components/components.dart';
import 'package:pixel_adventure/flame/asset_gen_image.dart';
import 'package:pixel_adventure/gen/assets.gen.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

class Level({
  required final Player player,
  super.children,
  super.priority,
  super.key,
}) extends World with HasGameReference<PixelAdventure> {
  late TiledComponent level;
  final List<CollisionBlock> collisionBlocks = [];

  @override
  Future<void> onLoad() async {
    level = await TiledComponent.load(
      Assets.tiles.flamePath(Assets.tiles.level01),
      Vector2.all(16),
    );
    add(level);

    _scrollingBackground();
    _addCollisions();
    _spwaningObjects();

    super.onLoad();
  }

  void _scrollingBackground() async {
    final bgLayer = level.tileMap.getLayer('Background');
    final tileSize = 64;
    if (bgLayer != null) {
      final backgroundColor = bgLayer.properties.getValue('BackgroundColor');
      final tilesNumY = (game.size.y / tileSize).floor();
      final tilesNumX = (game.size.x / tileSize).floor();

      for (double y = 0; y <= tilesNumY; y++) {
        for (double x = 0; x < tilesNumX; x++) {
          final bg = BackgroundTile(
            color: backgroundColor,
            position: Vector2(x * tileSize, y * tileSize - tileSize),
          );
          add(bg);
        }
      }
    }
  }

  void _addCollisions() {
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
  }

  void _spwaningObjects() {
    final spwanPointLayer = level.tileMap.getLayer<ObjectGroup>('Spwanpoints');
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
  }
}
