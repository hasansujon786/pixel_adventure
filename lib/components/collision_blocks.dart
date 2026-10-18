import 'package:flame/components.dart';

class CollisionBlock extends PositionComponent {
  final bool isPlatform;
  CollisionBlock({
    super.position,
    super.size,
    super.key,
    this.isPlatform = false,
  }) {
    debugMode = true;
  }
}
