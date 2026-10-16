// dart format width=80

/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use,directives_ordering,implicit_dynamic_list_literal,unnecessary_import

import 'package:flutter/widgets.dart';

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/20 Enemies.png
  AssetGenImage get a20Enemies =>
      const AssetGenImage('assets/images/20 Enemies.png');

  /// Directory path: assets/images/Background
  $AssetsImagesBackgroundGen get background =>
      const $AssetsImagesBackgroundGen();

  /// File path: assets/images/Hello.png
  AssetGenImage get hello => const AssetGenImage('assets/images/Hello.png');

  /// Directory path: assets/images/Main Characters
  $AssetsImagesMainCharactersGen get mainCharacters =>
      const $AssetsImagesMainCharactersGen();

  /// Directory path: assets/images/Other
  $AssetsImagesOtherGen get other => const $AssetsImagesOtherGen();

  /// Directory path: assets/images/Terrain
  $AssetsImagesTerrainGen get terrain => const $AssetsImagesTerrainGen();

  /// List of all assets
  List<AssetGenImage> get values => [a20Enemies, hello];
}

class $AssetsImagesBackgroundGen {
  const $AssetsImagesBackgroundGen();

  /// File path: assets/images/Background/Blue.png
  AssetGenImage get blue =>
      const AssetGenImage('assets/images/Background/Blue.png');

  /// File path: assets/images/Background/Brown.png
  AssetGenImage get brown =>
      const AssetGenImage('assets/images/Background/Brown.png');

  /// File path: assets/images/Background/Gray.png
  AssetGenImage get gray =>
      const AssetGenImage('assets/images/Background/Gray.png');

  /// File path: assets/images/Background/Green.png
  AssetGenImage get green =>
      const AssetGenImage('assets/images/Background/Green.png');

  /// File path: assets/images/Background/Pink.png
  AssetGenImage get pink =>
      const AssetGenImage('assets/images/Background/Pink.png');

  /// File path: assets/images/Background/Purple.png
  AssetGenImage get purple =>
      const AssetGenImage('assets/images/Background/Purple.png');

  /// File path: assets/images/Background/Yellow.png
  AssetGenImage get yellow =>
      const AssetGenImage('assets/images/Background/Yellow.png');

  /// List of all assets
  List<AssetGenImage> get values => [
    blue,
    brown,
    gray,
    green,
    pink,
    purple,
    yellow,
  ];
}

class $AssetsImagesMainCharactersGen {
  const $AssetsImagesMainCharactersGen();

  /// File path: assets/images/Main Characters/Appearing (96x96).png
  AssetGenImage get appearing96x96 => const AssetGenImage(
    'assets/images/Main Characters/Appearing (96x96).png',
  );

  /// File path: assets/images/Main Characters/Desappearing (96x96).png
  AssetGenImage get desappearing96x96 => const AssetGenImage(
    'assets/images/Main Characters/Desappearing (96x96).png',
  );

  /// List of all assets
  List<AssetGenImage> get values => [appearing96x96, desappearing96x96];
}

class $AssetsImagesOtherGen {
  const $AssetsImagesOtherGen();

  /// File path: assets/images/Other/Confetti (16x16).png
  AssetGenImage get confetti16x16 =>
      const AssetGenImage('assets/images/Other/Confetti (16x16).png');

  /// File path: assets/images/Other/Dust Particle.png
  AssetGenImage get dustParticle =>
      const AssetGenImage('assets/images/Other/Dust Particle.png');

  /// File path: assets/images/Other/Shadow.png
  AssetGenImage get shadow =>
      const AssetGenImage('assets/images/Other/Shadow.png');

  /// File path: assets/images/Other/Transition.png
  AssetGenImage get transition =>
      const AssetGenImage('assets/images/Other/Transition.png');

  /// List of all assets
  List<AssetGenImage> get values => [
    confetti16x16,
    dustParticle,
    shadow,
    transition,
  ];
}

class $AssetsImagesTerrainGen {
  const $AssetsImagesTerrainGen();

  /// File path: assets/images/Terrain/Terrain (16x16).png
  AssetGenImage get terrain16x16 =>
      const AssetGenImage('assets/images/Terrain/Terrain (16x16).png');

  /// List of all assets
  List<AssetGenImage> get values => [terrain16x16];
}

abstract final class Assets {
  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
    this.animation,
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;
  final AssetGenImageAnimation? animation;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({AssetBundle? bundle, String? package}) {
    return AssetImage(_assetName, bundle: bundle, package: package);
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class AssetGenImageAnimation {
  const AssetGenImageAnimation({
    required this.isAnimation,
    required this.duration,
    required this.frames,
  });

  final bool isAnimation;
  final Duration duration;
  final int frames;
}
