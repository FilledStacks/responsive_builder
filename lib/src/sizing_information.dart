import 'package:flutter/material.dart';
import 'device_screen_type.dart';

/// Contains sizing information to make responsive choices for the current screen
class SizingInformation {
  final DeviceScreenType deviceScreenType;
  final RefinedSize refinedSize;
  final Size screenSize;
  final Size localWidgetSize;

  bool get isMobile => deviceScreenType == DeviceScreenType.mobile;

  bool get isTablet => deviceScreenType == DeviceScreenType.tablet;

  bool get isDesktop => deviceScreenType == DeviceScreenType.desktop;

  bool get isWatch => deviceScreenType == DeviceScreenType.watch;

  // Refined

  bool get isExtraLarge => refinedSize == RefinedSize.extraLarge;

  bool get isLarge => refinedSize == RefinedSize.large;

  bool get isNormal => refinedSize == RefinedSize.normal;

  bool get isSmall => refinedSize == RefinedSize.small;

  SizingInformation({
    this.deviceScreenType,
    this.refinedSize,
    this.screenSize,
    this.localWidgetSize,
  });

  @override
  String toString() {
    return 'DeviceType:$deviceScreenType RefinedSize:$refinedSize ScreenSize:$screenSize LocalWidgetSize:$localWidgetSize';
  }
}

/// Manually define screen resolution breakpoints
///
/// Overrides the defaults
class ScreenBreakpoints {
  final double watch;
  final double tablet;
  final double desktop;

  const ScreenBreakpoints({
    @required this.desktop,
    @required this.tablet,
    @required this.watch,
  });

  @override
  String toString() {
    return "Desktop: $desktop, Tablet: $tablet, Watch: $watch";
  }
}

/// Manually define refined breakpoints
///
/// Overrides the defaults
class RefinedBreakpoints {
  final double mobileSmall;
  final double mobileNormal;
  final double mobileLarge;
  final double mobileExtraLarge;

  final double tabletSmall;
  final double tabletNormal;
  final double tabletLarge;
  final double tabletExtraLarge;

  final double desktopSmall;
  final double desktopNormal;
  final double desktopLarge;
  final double desktopExtraLarge;

  const RefinedBreakpoints({
    @required this.mobileSmall,
    @required this.mobileNormal,
    @required this.mobileLarge,
    @required this.mobileExtraLarge,

    @required this.tabletSmall,
    @required this.tabletNormal,
    @required this.tabletLarge,
    @required this.tabletExtraLarge,

    @required this.desktopSmall,
    @required this.desktopNormal,
    @required this.desktopLarge,
    @required this.desktopExtraLarge,
  });

  @override
  String toString() {
    return "Desktop: Small - $desktopSmall Normal - $desktopNormal Large - $desktoplarge ExtraLarge - $desktopExtraLarge
    \nTablet: Small - $tabletSmall Normal - $tabletNormal Large - $tabletlarge ExtraLarge - $tabletExtraLarge 
    \nMobile: Small - $mobileSmall Normal - $mobileNormal Large - $mobilelarge ExtraLarge - $mobileExtraLarge";
  }
}
