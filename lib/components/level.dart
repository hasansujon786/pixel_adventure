import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/painting.dart';
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
    final backgroundColor = bgLayer?.properties.getValue<String?>(
      'BackgroundColor',
    );
    final background = ParallaxComponent(
      priority: -1,
      parallax: Parallax([
        ParallaxLayer(
          ParallaxImage(
            game.images.fromCache(
              GameBgTile.fromColor(backgroundColor ?? 'Blue').path,
            ),
            repeat: ImageRepeat.repeat,
            fill: LayerFill.none,
          ),
        ),
      ], baseVelocity: Vector2(0, -50)),
    );
    add(background);
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
          case 'Fruit':
            final fruit = Fruit(
              name: spwanPoint.name,
              position: Vector2(spwanPoint.x, spwanPoint.y),
              size: Vector2(spwanPoint.width, spwanPoint.height),
            );
            add(fruit);
            break;
          case 'Saw':
            final isVertical = spwanPoint.properties.getValue<bool>(
              'isVertical',
            );
            final offsetNeg = spwanPoint.properties.getValue<double>(
              'offsetNeg',
            );
            final offsetPos = spwanPoint.properties.getValue<double>(
              'offsetPos',
            );

            final saw = Saw(
              position: Vector2(spwanPoint.x, spwanPoint.y),
              size: Vector2(spwanPoint.width, spwanPoint.height),
              isVertical: isVertical ?? false,
              offsetNeg: offsetNeg ?? 0,
              offsetPos: offsetPos ?? 0,
            );
            add(saw);
            break;
          case 'Checkpoint':
            final checpoint = Checkpoint(
              position: Vector2(spwanPoint.x, spwanPoint.y),
              size: Vector2(spwanPoint.width, spwanPoint.height),
            );
            add(checpoint);

            break;
          default:
        }
      }
    }
  }
}
