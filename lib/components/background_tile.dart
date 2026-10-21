import 'dart:async';

import 'package:flame/components.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

enum GameBgTile(final String path, final String name) {
  blue('Background/Blue.png', 'blue'),
  brown('Background/Brown.png', 'brown'),
  gray('Background/Gray.png', 'gray'),
  green('Background/Green.png', 'green'),
  pink('Background/Pink.png', 'pink'),
  purple('Background/Purple.png', 'purple'),
  yellow('Background/Yellow.png', 'yellow');

  static GameBgTile fromColor(String colorName) {
    return GameBgTile.values.firstWhere(
      (tile) => tile.name == colorName.trim().toLowerCase(),
      orElse: () => GameBgTile.blue, // Default fallback
    );
  }
}

class BackgroundTile({final String color = 'Blue', super.position})
    extends SpriteComponent
    with HasGameReference<PixelAdventure> {
  final scrollSpeed = 0.4;

  @override
  FutureOr<void> onLoad() {
    size = Vector2.all(64.6);
    late GameBgTile tile = GameBgTile.fromColor(color);
    priority = -1;
    sprite = Sprite(game.images.fromCache(tile.path));
    return super.onLoad();
  }

  @override
  void update(double dt) {
    position.y += scrollSpeed;
    final tileSize = 64.0;
    final scrollHeight = (game.size.y / tileSize).floor();
    if (position.y > scrollHeight * tileSize) {
      position.y = -tileSize;
    }
    super.update(dt);
  }
}

// void _mannualParalaxEffect() async {
//   final bgLayer = level.tileMap.getLayer('Background');
//   final tileSize = 64;
//   if (bgLayer != null) {
//     final backgroundColor = bgLayer.properties.getValue('BackgroundColor');
//     final tilesNumY = (game.size.y / tileSize).floor();
//     final tilesNumX = (game.size.x / tileSize).floor();
//
//     for (double y = 0; y <= tilesNumY; y++) {
//       for (double x = 0; x < tilesNumX; x++) {
//         final bg = BackgroundTile(
//           color: backgroundColor,
//           position: Vector2(x * tileSize, y * tileSize - tileSize),
//         );
//         add(bg);
//       }
//     }
//   }
// }
