import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_builder/responsive_builder.dart';

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

  group('getDeviceType-Breakpoint', () {
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
}
