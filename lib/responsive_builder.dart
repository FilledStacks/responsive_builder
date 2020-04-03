library responsive_builder;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef WidgetBuilder = Widget Function(BuildContext);

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
class ScreenBreakpoints {
  final double watch;
  final double tablet;
  final double desktop;

  ScreenBreakpoints(
      {@required this.desktop, @required this.tablet, @required this.watch});

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

  final ScreenBreakpoints breakpoints;

  const ResponsiveBuilder({Key key, this.builder, this.breakpoints})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, boxConstraints) {
      var mediaQuery = MediaQuery.of(context);
      var sizingInformation = SizingInformation(
        deviceScreenType: _getDeviceType(mediaQuery, breakpoints),
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
/// [breakpoints] define your own custom device resolutions
/// [watch] will be built and shown when width is less than 300
/// [mobile] will be built when width greater than 300
/// [tablet] will be built when width is greater than 600
/// [desktop] will be built if width is greater than 950
class ScreenTypeLayout extends StatelessWidget {
  final ScreenBreakpoints breakpoints;

  final WidgetBuilder watch;
  final WidgetBuilder mobile;
  final WidgetBuilder tablet;
  final WidgetBuilder desktop;

  ScreenTypeLayout(
      {Key key,
      this.breakpoints,
      Widget watch,
      Widget mobile,
      Widget tablet,
      Widget desktop})
      : this.watch = _builderOrNull(watch),
        this.mobile = _builderOrNull(mobile),
        this.tablet = _builderOrNull(tablet),
        this.desktop = _builderOrNull(desktop),
        super(key: key);

  const ScreenTypeLayout.builder(
      {Key key,
      this.breakpoints,
      this.watch,
      this.mobile,
      this.tablet,
      this.desktop})
      : super(key: key);

  static WidgetBuilder _builderOrNull(Widget widget) {
    return widget == null ? null : ((_) => widget);
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      breakpoints: breakpoints,
      builder: (context, sizingInformation) {
        // If we're at desktop size
        if (sizingInformation.deviceScreenType == DeviceScreenType.Desktop) {
          // If we have supplied the desktop layout then display that
          if (desktop != null) return desktop(context);
          // If no desktop layout is supplied we want to check if we have the size below it and display that
          if (tablet != null) return tablet(context);
        }

        if (sizingInformation.deviceScreenType == DeviceScreenType.Tablet) {
          if (tablet != null) return tablet(context);
        }

        if (sizingInformation.deviceScreenType == DeviceScreenType.Watch &&
            watch != null) {
          return watch(context);
        }

        // If none of the layouts above are supplied or we're on the mobile layout then we show the mobile layout
        return mobile(context);
      },
    );
  }
}

/// Provides a builder function for a landscape and portrait widget
/// [landscape] widget to render when device in landscape
/// [portrait] widget to render when device in portrait
/// [enforcePortrait] disables screenrotation and enforces device to portrait
/// [enforceLandscape] disables screenrotation and enforces device to landscape
class OrientationLayoutBuilder extends StatelessWidget {
  final WidgetBuilder landscape;
  final WidgetBuilder portrait;
  final bool enforcePortrait;
  final bool enforceLandscape;
  const OrientationLayoutBuilder(
      {Key key,
      this.landscape,
      this.portrait,
      this.enforcePortrait = false,
      this.enforceLandscape = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (enforcePortrait && enforceLandscape) {
      throw new Exception(
          'Choose either enforcing both orientations is not an option');
    }

    // forces device to portrait
    if (enforcePortrait) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);

      if (portrait == null) {
        throw new Exception('variable portrait required');
      }
    }

    // forces device to landscape
    if (enforceLandscape) {
      SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);

      if (landscape == null) {
        throw new Exception('variable landscape required');
      }
    }

    return Builder(
      builder: (context) {
        if (!enforcePortrait) {
          var orientation = MediaQuery.of(context).orientation;
          if (orientation == Orientation.landscape || enforceLandscape) {
            if (landscape != null) {
              return landscape(context);
            }
          }
        }

        return portrait(context);
      },
    );
  }
}

DeviceScreenType _getDeviceType(
    MediaQueryData mediaQuery, ScreenBreakpoints breakpoint) {
  double deviceWidth = mediaQuery.size.shortestSide;

  if (kIsWeb) {
    deviceWidth = mediaQuery.size.width;
  }

  // Replaces the defaults with the user defined definitions
  if (breakpoint != null) {
    if (deviceWidth > breakpoint.desktop) {
      return DeviceScreenType.Desktop;
    }

    if (deviceWidth > breakpoint.tablet) {
      return DeviceScreenType.Tablet;
    }

    if (deviceWidth < breakpoint.watch) {
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
