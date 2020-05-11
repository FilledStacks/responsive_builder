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

  /// Set the breakPoints which will then be returned through the [breakpoints]
  void setCustomBreakpoints(ScreenBreakpoints customBreakpoints) {
    _customBreakPoints = customBreakpoints;
  }

  ScreenBreakpoints get breakpoints =>
      _customBreakPoints ?? _defaultBreakPoints;
}
