library responsive_builder;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

typedef WidgetBuilder = Widget Function(BuildContext);

enum DeviceScreenType {
  MobileSmall,
  MobileTabletNormal,
  TabletLarge,
  MonitorSmall,
  MonitorLarge,
  MonitorExtraLarge,
  Watch,
}

/// Contains sizing information to make responsive choices for the current screen
class SizingInformation {
  final DeviceScreenType deviceScreenType;
  final Size screenSize;
  final Size localWidgetSize;

  bool get isMobileSmall => deviceScreenType == DeviceScreenType.MobileSmall;

  bool get isMobileTabletNormal =>
      deviceScreenType == DeviceScreenType.MobileTabletNormal;

  bool get isTabletLarge => deviceScreenType == DeviceScreenType.TabletLarge;

  bool get isMonitorSmall => deviceScreenType == DeviceScreenType.MonitorSmall;

  bool get isMonitorLarge => deviceScreenType == DeviceScreenType.MonitorLarge;

  bool get isMonitorExtraLarge =>
      deviceScreenType == DeviceScreenType.MonitorExtraLarge;

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
  final double mobileSmall;
  final double mobileTabletNormal;
  final double tabletLarge;
  final double monitorSmall;
  final double monitorLarge;
  final double monitorExtraLarge;

  ScreenBreakpoints({
    @required this.watch,
    @required this.mobileSmall,
    @required this.mobileTabletNormal,
    @required this.tabletLarge,
    @required this.monitorSmall,
    @required this.monitorLarge,
    @required this.monitorExtraLarge,
  });

  @override
  String toString() {
    return ''' 
    Watch: $watch,
    MobileSmall: $mobileSmall,
    MobileTabletNormal: $mobileTabletNormal,
    TabletLarge: $tabletLarge,
    MonitorSmall: $monitorSmall,
    MonitorLarge: $monitorLarge,
    MonitorExtraLarge: $monitorExtraLarge, 
      ''';
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
/// [mobile_small] will be built when width greater than 300 and less than 480
/// [mobile_tablet_normal] will be built when width greater than 480 and less than 767
/// [tablet_large] will be built when width is greater than 767 and less than 1024
/// [monitor_small] will be built when width is greater than 1025 and less than 1280
/// [monitor_large] will be built when width is greater than 1280 and less than 1650
/// [monitor_extra_large] will be built when width id greater than 1650
class ScreenTypeLayout extends StatelessWidget {
  final ScreenBreakpoints breakpoints;

  final WidgetBuilder watch;
  final WidgetBuilder mobileSmall;
  final WidgetBuilder mobileTabletNormal;
  final WidgetBuilder tabletLarge;
  final WidgetBuilder monitorSmall;
  final WidgetBuilder monitorLarge;
  final WidgetBuilder monitorExtraLarge;

  ScreenTypeLayout({
    Key key,
    this.breakpoints,
    Widget watch,
    Widget mobileSmall,
    Widget mobileTabletNormal,
    Widget tabletLarge,
    Widget monitorSmall,
    Widget monitorLarge,
    Widget monitorExtraLarge,
  })  : this.watch = _builderOrNull(watch),
        this.mobileSmall = _builderOrNull(mobileSmall),
        this.mobileTabletNormal = _builderOrNull(mobileTabletNormal),
        this.tabletLarge = _builderOrNull(tabletLarge),
        this.monitorSmall = _builderOrNull(monitorSmall),
        this.monitorLarge = _builderOrNull(monitorLarge),
        this.monitorExtraLarge = _builderOrNull(monitorExtraLarge),
        super(key: key);

  const ScreenTypeLayout.builder({
    Key key,
    this.breakpoints,
    this.watch,
    this.mobileSmall,
    this.mobileTabletNormal,
    this.tabletLarge,
    this.monitorSmall,
    this.monitorLarge,
    this.monitorExtraLarge,
  }) : super(key: key);

  static WidgetBuilder _builderOrNull(Widget widget) {
    return widget == null ? null : ((_) => widget);
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      breakpoints: breakpoints,
      builder: (context, sizingInformation) {
        //If we are at watch layout
        if (sizingInformation.deviceScreenType == DeviceScreenType.Watch &&
            watch != null) {
          return watch(context);
        }

        //If we are at mobile small layout
        if (sizingInformation.deviceScreenType ==
            DeviceScreenType.MobileSmall) {
          //If mobile small layout supplied
          if (mobileSmall != null) return mobileSmall(context);
          //If mobile small layout not supplied then go to next layout
          if (mobileTabletNormal != null) return mobileTabletNormal(context);
        }

        //If we are at low res tablet size or normal phone size
        if (sizingInformation.deviceScreenType ==
            DeviceScreenType.MobileTabletNormal) {
          //If tablet low res or mobile layout supplied
          if (mobileTabletNormal != null) return mobileTabletNormal(context);
          //If tablet low res not supplied then go mobile small layout
          if (mobileSmall != null) return mobileSmall(context);
        }

        //If we are at high res tablet size
        if (sizingInformation.deviceScreenType ==
            DeviceScreenType.TabletLarge) {
          //If tablet high res layout is supplied
          if (tabletLarge != null) return tabletLarge(context);
          //If table high res layout is not supllied then we go to tablet low res
          if (mobileTabletNormal != null) return mobileTabletNormal(context);
        }

        //If we are at small monitor size
        if (sizingInformation.deviceScreenType ==
            DeviceScreenType.MonitorSmall) {
          //If small monitor layout is supplied
          if (monitorSmall != null) return monitorSmall(context);
          //If monitor small layout is not supplied then we go to monitor large
          if (monitorLarge != null) return monitorLarge(context);
          //If monitor large layout is not supplied then we go to monitor XL
          if (monitorExtraLarge != null) return monitorExtraLarge(context);
        }

        //If we are at large monitor size
        if (sizingInformation.deviceScreenType ==
            DeviceScreenType.MonitorLarge) {
          //If Large monitor layout is supplied
          if (monitorLarge != null) return monitorLarge(context);
          //If monitor large layout is not supplied then we go to monitor XL
          if (monitorExtraLarge != null) return monitorExtraLarge(context);
          //If monitor XL layout is not supplied then we go to monitor small
          if (monitorSmall != null) return monitorSmall(context);
        }

        //If we are at XL monitor size
        if (sizingInformation.deviceScreenType ==
            DeviceScreenType.MonitorExtraLarge) {
          //If XL monitor layout is supplied
          if (monitorExtraLarge != null) return monitorExtraLarge(context);
          //If monitor XL layout is not supplied then we go to monitor large
          if (monitorLarge != null) return monitorLarge(context);
          //If monitor large layout is not supplied then we go to monitor small
          if (monitorSmall != null) return monitorSmall(context);
        }

        //If none of the above layouts are supplied then default to MobileTabletLayout
        return mobileTabletNormal(context);
      },
    );
  }
}

/// Provides a builder function for a landscape and portrait widget
class OrientationLayoutBuilder extends StatelessWidget {
  final WidgetBuilder landscape;
  final WidgetBuilder portrait;
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

DeviceScreenType _getDeviceType(
    MediaQueryData mediaQuery, ScreenBreakpoints breakpoint) {
  double deviceWidth = mediaQuery.size.shortestSide;

  if (kIsWeb) {
    deviceWidth = mediaQuery.size.width;
  }

  // Replaces the defaults with the user defined definitions
  if (breakpoint != null) {
    if (deviceWidth < breakpoint.watch) {
      return DeviceScreenType.Watch;
    }
    if (deviceWidth >= breakpoint.watch &&
        deviceWidth <= breakpoint.mobileSmall) {
      return DeviceScreenType.MobileSmall;
    }
    if (deviceWidth > breakpoint.mobileSmall &&
        deviceWidth <= breakpoint.mobileTabletNormal) {
      return DeviceScreenType.MobileTabletNormal;
    }
    if (deviceWidth > breakpoint.mobileTabletNormal &&
        deviceWidth <= breakpoint.tabletLarge) {
      return DeviceScreenType.TabletLarge;
    }
    if (deviceWidth > breakpoint.tabletLarge &&
        deviceWidth <= breakpoint.monitorSmall) {
      return DeviceScreenType.MonitorSmall;
    }
    if (deviceWidth > breakpoint.monitorSmall &&
        deviceWidth <= breakpoint.monitorLarge) {
      return DeviceScreenType.MonitorLarge;
    }
    if (deviceWidth > breakpoint.monitorLarge) {
      return DeviceScreenType.MonitorExtraLarge;
    }
  }

  // If no user defined definitions are passed through use the defaults
  if (deviceWidth < 300) {
    return DeviceScreenType.Watch;
  }
  if (deviceWidth >= 300 && deviceWidth <= 480) {
    return DeviceScreenType.MobileSmall;
  }
  if (deviceWidth > 480 && deviceWidth <= 767) {
    return DeviceScreenType.MobileTabletNormal;
  }
  if (deviceWidth > 767 && deviceWidth <= 1024) {
    return DeviceScreenType.TabletLarge;
  }
  if (deviceWidth > 1024 && deviceWidth <= 1280) {
    return DeviceScreenType.MonitorSmall;
  }
  if (deviceWidth > 1280 && deviceWidth <= 1650) {
    return DeviceScreenType.MonitorLarge;
  }
  if (deviceWidth > 1650) {
    return DeviceScreenType.MonitorExtraLarge;
  }

  return DeviceScreenType.MobileTabletNormal;
}
