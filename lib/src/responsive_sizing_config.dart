import 'package:responsive_builder/responsive_builder.dart';

/// Keeps the configuration that will determines the breakpoints for different device sizes
class ResponsiveSizingConfig {
  static ResponsiveSizingConfig _instance;
  static ResponsiveSizingConfig get instance {
    if (_instance == null) {
      _instance = ResponsiveSizingConfig();
    }

    return _instance;
  }

  static const ScreenBreakpoints _defaultBreakPoints = const ScreenBreakpoints(
    desktop: 950,
    tablet: 600,
    watch: 300,
  );

  ScreenBreakpoints _customBreakPoints;

  static const RefinedBreakpoints _defaultRefinedBreakPoints =
      const RefinedBreakpoints(
    // Desktop
    desktopExtraLarge: 4096,
    desktopLarge: 3840,
    desktopNormal: 1920,
    desktopSmall: 950,
    // Tablet
    tabletExtraLarge: 900,
    tabletLarge: 850,
    tabletNormal: 768,
    tabletSmall: 600,
    // Mobile
    mobileExtraLarge: 480,
    mobileLarge: 414,
    mobileNormal: 375,
    mobileSmall: 320,
  );

  RefinedBreakpoints _customRefinedBreakPoints;

  /// Set the breakPoints which will then be returned through the [breakpoints]
  void setCustomBreakpoints(ScreenBreakpoints customBreakpoints) {
    _customBreakPoints = customBreakpoints;
  }

  ScreenBreakpoints get breakpoints =>
      _customBreakPoints ?? _defaultBreakPoints;

  /// Set the refinedBreakPoints which will then be returned through the [refinedBreakpoints]
  void setCustomRefinedBreakpoints(
      RefinedBreakpoints customRefinedBreakpoints) {
    _customRefinedBreakPoints = customRefinedBreakpoints;
  }

  RefinedBreakpoints get refinedBreakpoints =>
      _customRefinedBreakPoints ?? _defaultRefinedBreakPoints;
}
