// dart format width=80

/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use,directives_ordering,implicit_dynamic_list_literal,unnecessary_import

import 'package:flutter/widgets.dart';

abstract final class Assets {
  static const AssetGenImage logo = AssetGenImage('assets/logo.png');
  static const AssetGenImage logoSecond = AssetGenImage(
    'assets/logo_second.png',
  );
  static const AssetGenImage logoSplash = AssetGenImage(
    'assets/logo_splash.png',
  );
  static const String uilBasketball = 'assets/uil_basketball.svg';
  static const String uilBookOpen = 'assets/uil_book-open.svg';
  static const String uilCarSideview = 'assets/uil_car-sideview.svg';
  static const String uilClapperBoard = 'assets/uil_clapper-board.svg';
  static const String uilGift = 'assets/uil_gift.svg';
  static const String uilHome = 'assets/uil_home.svg';
  static const String uilPizzaSlice = 'assets/uil_pizza-slice.svg';
  static const String uilRssAlt = 'assets/uil_rss-alt.svg';
  static const String uilShoppingCart = 'assets/uil_shopping-cart.svg';

  /// List of all assets
  static List<dynamic> get values => [
    logo,
    logoSecond,
    logoSplash,
    uilBasketball,
    uilBookOpen,
    uilCarSideview,
    uilClapperBoard,
    uilGift,
    uilHome,
    uilPizzaSlice,
    uilRssAlt,
    uilShoppingCart,
  ];
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
