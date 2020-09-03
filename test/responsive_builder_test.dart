import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:responsive_builder/src/responsive_sizing_config.dart';

void main() {
  group('getDeviceType-Defaults', () {
    test('When on device with width between 600 and 300 should return mobile',
        () async {
      var screenType = getDeviceType(Size(599, 800));
      expect(screenType, DeviceScreenType.mobile);
    });

    test('When on device with width between 600 and 950 should return mobile',
        () async {
      var screenType = getDeviceType(Size(949, 1200));
      expect(screenType, DeviceScreenType.tablet);
    });

    test('When on device with width higher than 950 should return desktop',
        () async {
      var screenType = getDeviceType(Size(1000, 1200));
      expect(screenType, DeviceScreenType.desktop);
    });

    test('When on device with width lower than 300 should return watch',
        () async {
      var screenType = getDeviceType(Size(1000, 1200));
      expect(screenType, DeviceScreenType.desktop);
    });
  });

  group('getDeviceType-Custom Breakpoint', () {
    test(
        'given break point with desktop at 1200 and width at 1201 should return desktop',
        () {
      var breakPoint =
          ScreenBreakpoints(desktop: 1200, tablet: 550, watch: 300);
      var screenType = getDeviceType(Size(1201, 1400), breakPoint);
      expect(screenType, DeviceScreenType.desktop);
    });

    test(
        'given break point with tablet at 550 and width at 1199 should return tablet',
        () {
      var breakPoint =
          ScreenBreakpoints(desktop: 1200, tablet: 550, watch: 300);
      var screenType = getDeviceType(Size(1199, 1400), breakPoint);
      expect(screenType, DeviceScreenType.tablet);
    });

    test(
        'given break point with watch at 150 and width at 149 should return watch',
        () {
      var breakPoint =
          ScreenBreakpoints(desktop: 1200, tablet: 550, watch: 150);
      var screenType = getDeviceType(Size(149, 340), breakPoint);
      expect(screenType, DeviceScreenType.watch);
    });

    test(
        'given break point with desktop 1200, tablet 550, should return mobile if width is under 550 above 150',
        () {
      var breakPoint =
          ScreenBreakpoints(desktop: 1200, tablet: 550, watch: 150);
      var screenType = getDeviceType(Size(549, 800), breakPoint);
      expect(screenType, DeviceScreenType.mobile);
    });
  });

  group('getDeviceType-Config set', () {
    test(
        'When global config desktop set to 800, should return desktop when width is 801',
        () {
      ResponsiveSizingConfig.instance.setCustomBreakpoints(
          ScreenBreakpoints(desktop: 800, tablet: 550, watch: 200));

      var screenType = getDeviceType(Size(801, 1000));
      expect(screenType, DeviceScreenType.desktop);
    });
    test(
        'When global config tablet set to 550, should return tablet when width is 799',
        () {
      ResponsiveSizingConfig.instance.setCustomBreakpoints(
          ScreenBreakpoints(desktop: 800, tablet: 550, watch: 200));

      var screenType = getDeviceType(Size(799, 1000));
      expect(screenType, DeviceScreenType.tablet);
    });
    test(
        'When global config tablet set to 550, should return mobile when width is 799',
        () {
      ResponsiveSizingConfig.instance.setCustomBreakpoints(
          ScreenBreakpoints(desktop: 800, tablet: 550, watch: 200));

      var screenType = getDeviceType(Size(799, 1000));
      expect(screenType, DeviceScreenType.tablet);
    });

    test(
        'When global config watch set to 200, should return watch when width is 199',
        () {
      ResponsiveSizingConfig.instance.setCustomBreakpoints(
          ScreenBreakpoints(desktop: 800, tablet: 550, watch: 200));

      var screenType = getDeviceType(Size(799, 1000));
      expect(screenType, DeviceScreenType.tablet);
    });
  });

  group('getDeviceType-Config+Breakpoint', () {
    tearDown(() => ResponsiveSizingConfig.instance.setCustomBreakpoints(null));
    test(
        'When global config desktop set to 1000, should return desktop when custom breakpoint desktop is 800 and width is 801',
        () {
      ResponsiveSizingConfig.instance.setCustomBreakpoints(
          ScreenBreakpoints(desktop: 1000, tablet: 600, watch: 200));
      var breakPoint = ScreenBreakpoints(desktop: 800, tablet: 750, watch: 200);
      var screenType = getDeviceType(Size(801, 1000), breakPoint);
      expect(screenType, DeviceScreenType.desktop);
    });
    test(
        'When global config tablet set to 600, should return tablet when custom breakpoint tablet is 800 and width is 801',
        () {
      ResponsiveSizingConfig.instance.setCustomBreakpoints(
          ScreenBreakpoints(desktop: 800, tablet: 600, watch: 200));
      var breakPoint = ScreenBreakpoints(desktop: 950, tablet: 800, watch: 200);
      var screenType = getDeviceType(Size(801, 1000), breakPoint);
      expect(screenType, DeviceScreenType.tablet);
    });
    test(
        'When global config is set tablet 600, desktop 800, should return mobile if custom breakpoint has range of 200, 300 and width is 201',
        () {
      ResponsiveSizingConfig.instance.setCustomBreakpoints(
          ScreenBreakpoints(desktop: 800, tablet: 600, watch: 200));
      var breakPoint = ScreenBreakpoints(desktop: 950, tablet: 300, watch: 200);
      var screenType = getDeviceType(Size(201, 500), breakPoint);
      expect(screenType, DeviceScreenType.mobile);
    });
    test(
        'When global config watch set to 200, should return watch if custom breakpoint watch is 400 and width is 399',
        () {
      ResponsiveSizingConfig.instance.setCustomBreakpoints(
          ScreenBreakpoints(desktop: 800, tablet: 600, watch: 200));
      var breakPoint = ScreenBreakpoints(desktop: 950, tablet: 800, watch: 400);
      var screenType = getDeviceType(Size(399, 1000), breakPoint);
      expect(screenType, DeviceScreenType.watch);
    });
  });

  group('getRefinedSize - Custom break points -', () {
    test(
        'When called with desktop size in normal range, should return RefinedSize.normal',
        () {
      ResponsiveSizingConfig.instance.setCustomBreakpoints(
          ScreenBreakpoints(desktop: 800, tablet: 600, watch: 200));
      var breakPoint = RefinedBreakpoints(
          desktopSmall: 850,
          desktopNormal: 900,
          desktopLarge: 950,
          desktopExtraLarge: 1000);
      var refinedSize =
          getRefinedSize(Size(851, 1000), refinedBreakpoint: breakPoint);
      expect(refinedSize, RefinedSize.normal);
    });
  });

  group('getRefinedSize -', () {
    setUp(() => ResponsiveSizingConfig.instance.setCustomBreakpoints(null));
    test(
        'When called with desktop size in extra large range, should return RefinedSize.extraLarge',
        () {
      var refinedSize = getRefinedSize(Size(4097, 1000), isWebOrDesktop: true);
      expect(refinedSize, RefinedSize.extraLarge);
    });
    test(
        'When called with desktop size in large range, should return RefinedSize.large',
        () {
      var refinedSize = getRefinedSize(Size(3840, 1000), isWebOrDesktop: true);
      expect(refinedSize, RefinedSize.large);
    });
    test(
        'When called with desktop size in normal range, should return RefinedSize.normal',
        () {
      var refinedSize = getRefinedSize(Size(1921, 1000), isWebOrDesktop: true);
      expect(refinedSize, RefinedSize.normal);
    });

    test(
        'When called with tablet size in extra large range, should return RefinedSize.extraLarge',
        () {
      var refinedSize = getRefinedSize(Size(901, 1000));
      expect(refinedSize, RefinedSize.extraLarge);
    });
    test(
        'When called with tablet size in large range, should return RefinedSize.large',
        () {
      var refinedSize = getRefinedSize(Size(851, 1000));
      expect(refinedSize, RefinedSize.large);
    });
    test(
        'When called with tablet size in normal range, should return RefinedSize.normal',
        () {
      var refinedSize = getRefinedSize(Size(769, 1000));
      expect(refinedSize, RefinedSize.normal);
    });
  });
}
