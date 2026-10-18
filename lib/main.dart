import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();

  runApp(MyGameApp());
}

class MyGameApp extends StatelessWidget {
  const MyGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    PixelAdventure game = PixelAdventure();
    return GameWidget(game: kDebugMode ? PixelAdventure() : game);
  }
}
