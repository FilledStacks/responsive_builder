import 'package:flutter/material.dart';

import '../responsive_builder.dart';

typedef WidgetBuilder = Widget Function(BuildContext);

/// A widget with a builder that provides you with the sizingInformation
///
/// This widget is used by the ScreenTypeLayout to provide different widget builders
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(
    BuildContext context,
    SizingInformation sizingInformation,
  ) builder;

  final ScreenBreakpoints? breakpoints;
  final RefinedBreakpoints? refinedBreakpoints;

  const ResponsiveBuilder({
    Key? key,
    required this.builder,
    this.breakpoints,
    this.refinedBreakpoints,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, boxConstraints) {
      var size = MediaQuery.sizeOf(context);
      var sizingInformation = SizingInformation(
        deviceScreenType: getDeviceType(size, breakpoints),
        refinedSize: getRefinedSize(
          size,
          refinedBreakpoint: refinedBreakpoints,
        ),
        screenSize: size,
        localWidgetSize:
            Size(boxConstraints.maxWidth, boxConstraints.maxHeight),
      );
      return builder(context, sizingInformation);
    });
  }
}

enum OrientationLayoutBuilderMode {
  auto,
  landscape,
  portrait,
}

/// Provides a builder function for a landscape and portrait widget
class OrientationLayoutBuilder extends StatelessWidget {
  final WidgetBuilder? landscape;
  final WidgetBuilder portrait;
  final OrientationLayoutBuilderMode mode;

  const OrientationLayoutBuilder({
    Key? key,
    this.landscape,
    required this.portrait,
    this.mode = OrientationLayoutBuilderMode.auto,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        var orientation = MediaQuery.orientationOf(context);
        if (mode != OrientationLayoutBuilderMode.portrait &&
            (orientation == Orientation.landscape ||
                mode == OrientationLayoutBuilderMode.landscape)) {
          if (landscape != null) {
            return landscape!(context);
          }
        }

        return portrait(context);
      },
    );
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
  final ScreenBreakpoints? breakpoints;

  final WidgetBuilder? watch;
  final WidgetBuilder? mobile;
  final WidgetBuilder? tablet;
  final WidgetBuilder? desktop;

  @Deprecated(
    'Use ScreenTypeLayout.builder instead for performance improvements',
  )
  ScreenTypeLayout({
    Key? key,
    this.breakpoints,
    Widget? watch,
    required Widget mobile,
    Widget? tablet,
    Widget? desktop,
  })  : this.watch = _builderOrNull(watch),
        this.mobile = _builderOrNull(mobile)!,
        this.tablet = _builderOrNull(tablet),
        this.desktop = _builderOrNull(desktop),
        super(key: key) {
    _checkIfMobileOrDesktopIsSupplied();
  }

  ScreenTypeLayout.builder({
    Key? key,
    this.breakpoints,
    this.watch,
    this.mobile,
    this.tablet,
    this.desktop,
  }) : super(key: key) {
    _checkIfMobileOrDesktopIsSupplied();
  }

  void _checkIfMobileOrDesktopIsSupplied() {
    final hasMobileLayout = mobile != null;
    final hasDesktopLayout = desktop != null;

    assert(
      hasMobileLayout || hasDesktopLayout,
      'You should supply either a mobile layout or a desktop layout. If you don\'t need two layouts then remove this widget and use the widget you want to use directly. ',
    );
  }

  static WidgetBuilder? _builderOrNull(Widget? widget) {
    return widget == null ? null : ((_) => widget);
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      breakpoints: breakpoints,
      builder: (context, sizingInformation) {
        // If we're at desktop size
        if (sizingInformation.deviceScreenType == DeviceScreenType.desktop) {
          // If we have supplied the desktop layout then display that
          if (desktop != null) return desktop!(context);
          // If no desktop layout is supplied we want to check if we have the size below it and display that
          if (tablet != null) return tablet!(context);
        }

        if (sizingInformation.deviceScreenType == DeviceScreenType.tablet) {
          if (tablet != null) return tablet!(context);
        }

        if (sizingInformation.deviceScreenType == DeviceScreenType.watch &&
            watch != null) {
          return watch!(context);
        }

        if (sizingInformation.deviceScreenType == DeviceScreenType.mobile) {
          if (mobile != null) return mobile!(context);
        }

        // If none of the layouts above are supplied we use the prefered layout based on the flag
        final buildDesktopLayout =
            ResponsiveAppUtil.preferDesktop && desktop != null;

        return buildDesktopLayout ? desktop!(context) : mobile!(context);
      },
    );
  }
}

/// Provides a builder function for refined screen sizes to be used with [ScreenTypeLayout]
///
/// Each builder will get built based on the current device width.
/// [breakpoints] define your own custom device resolutions
/// [extraLarge] will be built if width is greater than 2160 on Desktops, 1280 on Tablets, and 600 on Mobiles
/// [large] will be built when width is greater than 1440 on Desktops, 1024 on Tablets, and 414 on Mobiles
/// [normal] will be built when width is greater than 1080 on Desktops, 768 on Tablets, and 375 on Mobiles
/// [small] will be built if width is less than 720 on Desktops, 600 on Tablets, and 320 on Mobiles
class RefinedLayoutBuilder extends StatelessWidget {
  final RefinedBreakpoints? refinedBreakpoints;

  final WidgetBuilder? extraLarge;
  final WidgetBuilder? large;
  final WidgetBuilder normal;
  final WidgetBuilder? small;

  const RefinedLayoutBuilder({
    Key? key,
    this.refinedBreakpoints,
    this.extraLarge,
    this.large,
    required this.normal,
    this.small,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      refinedBreakpoints: refinedBreakpoints,
      builder: (context, sizingInformation) {
        // If we're at extra large size
        if (sizingInformation.refinedSize == RefinedSize.extraLarge) {
          // If we have supplied the extra large layout then display that
          if (extraLarge != null) return extraLarge!(context);
          // If no extra large layout is supplied we want to check if we have the size below it and display that
          if (large != null) return large!(context);
        }

        if (sizingInformation.refinedSize == RefinedSize.large) {
          // If we have supplied the large layout then display that
          if (large != null) return large!(context);
          // If no large layout is supplied we want to check if we have the size below it and display that
          return normal(context);
        }

        if (sizingInformation.refinedSize == RefinedSize.small) {
          // If we have supplied the small layout then display that
          if (small != null) return small!(context);
        }

        // If none of the layouts above are supplied or we're on the small size layout then we show the small layout
        return normal(context);
      },
    );
  }
}
