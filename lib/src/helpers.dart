import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/src/responsive_sizing_config.dart';
import 'package:responsive_builder/src/sizing_information.dart';

import 'device_screen_type.dart';

/// Returns the [DeviceScreenType] that the application is currently running on
DeviceScreenType getDeviceType(
  Size size, [
  ScreenBreakpoints breakpoint,
]) {
  double deviceWidth = size.shortestSide;

  if (kIsWeb) {
    deviceWidth = size.width;
  }

  // Replaces the defaults with the user defined definitions
  if (breakpoint != null) {
    if (deviceWidth > breakpoint.desktop) {
      return DeviceScreenType.desktop;
    }

    if (deviceWidth > breakpoint.tablet) {
      return DeviceScreenType.tablet;
    }

    if (deviceWidth < breakpoint.watch) {
      return DeviceScreenType.watch;
    }
  } else {
    // If no user defined definitions are passed through use the defaults
    if (deviceWidth >= ResponsiveSizingConfig.instance.breakpoints.desktop) {
      return DeviceScreenType.desktop;
    }

    if (deviceWidth >= ResponsiveSizingConfig.instance.breakpoints.tablet) {
      return DeviceScreenType.tablet;
    }

    if (deviceWidth < ResponsiveSizingConfig.instance.breakpoints.watch) {
      return DeviceScreenType.watch;
    }
  }

  return DeviceScreenType.mobile;
}

/// Will return one of the values passed in for the device it's running on
T getValueForScreenType<T>({
  BuildContext context,
  T mobile,
  T tablet,
  T desktop,
  T watch,
}) {
  var deviceScreenType = getDeviceType(MediaQuery.of(context).size);
  // If we're at desktop size
  if (deviceScreenType == DeviceScreenType.desktop) {
    // If we have supplied the desktop layout then display that
    if (desktop != null) return desktop;
    // If no desktop layout is supplied we want to check if we have the size below it and display that
    if (tablet != null) return tablet;
  }

  if (deviceScreenType == DeviceScreenType.tablet) {
    if (tablet != null) return tablet;
  }

  if (deviceScreenType == DeviceScreenType.watch && watch != null) {
    return watch;
  }

  // If none of the layouts above are supplied or we're on the mobile layout then we show the mobile layout
  return mobile;
}

class ScreenTypeValueBuilder<T> {
  @Deprecated('Use better named function getValueForScreenType')
  T getValueForType({
    BuildContext context,
    T mobile,
    T tablet,
    T desktop,
    T watch,
  }) {
    return getValueForScreenType(
        context: context,
        mobile: mobile,
        tablet: tablet,
        desktop: desktop,
        watch: watch);
  }
}
