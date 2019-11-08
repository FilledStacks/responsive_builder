library responsive_builder;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum DeviceScreenType { Mobile, Tablet, Desktop, Watch }

/// Contains sizing information to make responsive choices for the current screen
class SizingInformation {
  final DeviceScreenType deviceScreenType;
  final Size screenSize;
  final Size localWidgetSize;

  bool get isMobile => deviceScreenType == DeviceScreenType.Mobile;

  bool get isTablet => deviceScreenType == DeviceScreenType.Tablet;

  bool get isDesktop => deviceScreenType == DeviceScreenType.Desktop;

  bool get isWatch => deviceScreenType == DeviceScreenType.Watch;

  SizingInformation({
    this.deviceScreenType,
    this.screenSize,
    this.localWidgetSize,
  });

  @override
  String toString() {
    return 'DeviceType:$deviceScreenType ScreenSize:$screenSize LocalWidgetSize:$localWidgetSize';
  }
}

/// Manually define screen resolution breakpoints
///
/// Overrides the defaults
class ScreenDefinitions {
  final double watch;
  final double tablet;
  final double desktop;

  ScreenDefinitions({
    @required this.desktop,
    @required this.tablet,
    @required this.watch
  });

  @override
  String toString() {
    return "Desktop: $desktop, Tablet: $tablet, Watch: $watch";
  }
}

/// A widget with a builder that provides you with the sizingInformation
///
/// This widget is used by the ScreenTypeLayout to provide different widget builders
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(
    BuildContext context,
    SizingInformation sizingInformation,
  ) builder;

  const ResponsiveBuilder({
    Key key,
    this.builder,
    this.definitions
  }) : super(key: key);

  final ScreenDefinitions definitions;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, boxConstraints) {
      var mediaQuery = MediaQuery.of(context);
      var sizingInformation = SizingInformation(
        deviceScreenType: _getDeviceType(mediaQuery, definitions),
        screenSize: mediaQuery.size,
        localWidgetSize:
            Size(boxConstraints.maxWidth, boxConstraints.maxHeight),
      );
      return builder(context, sizingInformation);
    });
  }
}

/// Provides a builder function for different screen types
///
/// Each builder will get built based on the current device width.
/// [definitions] defines your own custom device resolutions
/// [watch] will be built and shown when width is less than 300
/// [mobile] will be built when width greater than 300
/// [tablet] will be built when width is greater than 600
/// [desktop] will be built if width is greater than 950
class ScreenTypeLayout extends StatelessWidget {
  
  final ScreenDefinitions definitions;
  
  final Widget watch;
  final Widget mobile;
  final Widget tablet;
  final Widget desktop;
  const ScreenTypeLayout(
      {Key key, this.definitions, this.watch, this.mobile, this.tablet, this.desktop})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      definitions: definitions,
      builder: (context, sizingInformation) {
        // If we're at desktop size
        if (sizingInformation.deviceScreenType == DeviceScreenType.Desktop) {
          // If we have supplied the desktop layout then display that
          if (desktop != null) return desktop;
          // If no desktop layout is supplied we want to check if we have the size below it and display that
          if (tablet != null) return tablet;
        }

        if (sizingInformation.deviceScreenType == DeviceScreenType.Tablet) {
          if (tablet != null) return tablet;
        }

        if (sizingInformation.deviceScreenType == DeviceScreenType.Watch &&
            watch != null) {
          return watch;
        }

        // If none of the layouts above are supplied or we're on the mobile layout then we show the mobile layout
        return mobile;
      },
    );
  }
}

/// Provides a builder function for a landscape and portrait widget
class OrientationLayoutBuilder extends StatelessWidget {
  final Widget Function(BuildContext) landscape;
  final Widget Function(BuildContext) portrait;
  const OrientationLayoutBuilder({
    Key key,
    this.landscape,
    this.portrait,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        var orientation = MediaQuery.of(context).orientation;
        if (orientation == Orientation.landscape) {
          if (landscape != null) {
            return landscape(context);
          }
        }

        return portrait(context);
      },
    );
  }
}

DeviceScreenType _getDeviceType(MediaQueryData mediaQuery, ScreenDefinitions definitions) {
  double deviceWidth = mediaQuery.size.shortestSide;

  if (kIsWeb) {
    deviceWidth = mediaQuery.size.width;
  }

  // Replaces the defaults with the user defined definitions 
  if(definitions != null) {
    if(deviceWidth > definitions.desktop) {
      return DeviceScreenType.Desktop;
    }

    if(deviceWidth > definitions.tablet) {
      return DeviceScreenType.Tablet;
    }

    if(deviceWidth < definitions.watch) {
      return DeviceScreenType.Watch;
    }
  }

  // If no user defined definitions are passed through use the defaults
  if (deviceWidth > 950) {
    return DeviceScreenType.Desktop;
  }

  if (deviceWidth > 600) {
    return DeviceScreenType.Tablet;
  }

  if (deviceWidth < 300) {
    return DeviceScreenType.Watch;
  }

  return DeviceScreenType.Mobile;   
}



