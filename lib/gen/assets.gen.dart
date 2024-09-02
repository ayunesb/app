/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/Gym.png
  AssetGenImage get gym => const AssetGenImage('assets/images/Gym.png');

  /// File path: assets/images/Patio.png
  AssetGenImage get patio => const AssetGenImage('assets/images/Patio.png');

  /// File path: assets/images/Swimming Pool.png
  AssetGenImage get swimmingPool =>
      const AssetGenImage('assets/images/Swimming Pool.png');

  /// File path: assets/images/brand.png
  AssetGenImage get brand => const AssetGenImage('assets/images/brand.png');

  /// File path: assets/images/childrens_area.png
  AssetGenImage get childrensArea =>
      const AssetGenImage('assets/images/childrens_area.png');

  /// File path: assets/images/covered_parking.png
  AssetGenImage get coveredParking =>
      const AssetGenImage('assets/images/covered_parking.png');

  /// File path: assets/images/defaultProperty.png
  AssetGenImage get defaultProperty =>
      const AssetGenImage('assets/images/defaultProperty.png');

  /// File path: assets/images/elevator.png
  AssetGenImage get elevator =>
      const AssetGenImage('assets/images/elevator.png');

  /// File path: assets/images/events_area.png
  AssetGenImage get eventsArea =>
      const AssetGenImage('assets/images/events_area.png');

  /// File path: assets/images/google-play.png
  AssetGenImage get googlePlay =>
      const AssetGenImage('assets/images/google-play.png');

  /// File path: assets/images/icon.png
  AssetGenImage get icon => const AssetGenImage('assets/images/icon.png');

  /// File path: assets/images/jacuzzi.png
  AssetGenImage get jacuzzi => const AssetGenImage('assets/images/jacuzzi.png');

  /// File path: assets/images/lola.png
  AssetGenImage get lola => const AssetGenImage('assets/images/lola.png');

  /// File path: assets/images/parking_lot.png
  AssetGenImage get parkingLot =>
      const AssetGenImage('assets/images/parking_lot.png');

  /// File path: assets/images/pet_friendly.png
  AssetGenImage get petFriendly =>
      const AssetGenImage('assets/images/pet_friendly.png');

  /// File path: assets/images/security.png
  AssetGenImage get security =>
      const AssetGenImage('assets/images/security.png');

  /// File path: assets/images/splash.png
  AssetGenImage get splash => const AssetGenImage('assets/images/splash.png');

  /// List of all assets
  List<AssetGenImage> get values => [
        gym,
        patio,
        swimmingPool,
        brand,
        childrensArea,
        coveredParking,
        defaultProperty,
        elevator,
        eventsArea,
        googlePlay,
        icon,
        jacuzzi,
        lola,
        parkingLot,
        petFriendly,
        security,
        splash
      ];
}

class $AssetsSvgGen {
  const $AssetsSvgGen();

  /// File path: assets/svg/childrens_area.svg
  String get childrensArea => 'assets/svg/childrens_area.svg';

  /// File path: assets/svg/covered_parking.svg
  String get coveredParking => 'assets/svg/covered_parking.svg';

  /// File path: assets/svg/elevator.svg
  String get elevator => 'assets/svg/elevator.svg';

  /// File path: assets/svg/events_area.svg
  String get eventsArea => 'assets/svg/events_area.svg';

  /// File path: assets/svg/gym.svg
  String get gym => 'assets/svg/gym.svg';

  /// File path: assets/svg/jacuzzi.svg
  String get jacuzzi => 'assets/svg/jacuzzi.svg';

  /// File path: assets/svg/logo_shield.svg
  String get logoShield => 'assets/svg/logo_shield.svg';

  /// File path: assets/svg/multi-pin.svg
  String get multiPin => 'assets/svg/multi-pin.svg';

  /// File path: assets/svg/multi-pin_favorite.svg
  String get multiPinFavorite => 'assets/svg/multi-pin_favorite.svg';

  /// File path: assets/svg/multi-pin_promoted.svg
  String get multiPinPromoted => 'assets/svg/multi-pin_promoted.svg';

  /// File path: assets/svg/parking_lot.svg
  String get parkingLot => 'assets/svg/parking_lot.svg';

  /// File path: assets/svg/patio.svg
  String get patio => 'assets/svg/patio.svg';

  /// File path: assets/svg/pet_friendly.svg
  String get petFriendly => 'assets/svg/pet_friendly.svg';

  /// File path: assets/svg/pin.svg
  String get pin => 'assets/svg/pin.svg';

  /// File path: assets/svg/pin_favorite.svg
  String get pinFavorite => 'assets/svg/pin_favorite.svg';

  /// File path: assets/svg/pin_promoted.svg
  String get pinPromoted => 'assets/svg/pin_promoted.svg';

  /// File path: assets/svg/security.svg
  String get security => 'assets/svg/security.svg';

  /// File path: assets/svg/swimming_pool.svg
  String get swimmingPool => 'assets/svg/swimming_pool.svg';

  /// List of all assets
  List<String> get values => [
        childrensArea,
        coveredParking,
        elevator,
        eventsArea,
        gym,
        jacuzzi,
        logoShield,
        multiPin,
        multiPinFavorite,
        multiPinPromoted,
        parkingLot,
        patio,
        petFriendly,
        pin,
        pinFavorite,
        pinPromoted,
        security,
        swimmingPool
      ];
}

class Assets {
  Assets._();

  static const $AssetsImagesGen images = $AssetsImagesGen();
  static const $AssetsSvgGen svg = $AssetsSvgGen();
}

class AssetGenImage {
  const AssetGenImage(this._assetName);

  final String _assetName;

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
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
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

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
