import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:responsive_builder/src/helpers/device_width.dart';

void main() {
  tearDown(() {
    debugDefaultTargetPlatformOverride = null;
  });

  group('deviceWidth', () {
    test('desktop platforms use size.width (not shortestSide)', () {
      for (final platform in [
        TargetPlatform.macOS,
        TargetPlatform.windows,
        TargetPlatform.linux,
      ]) {
        debugDefaultTargetPlatformOverride = platform;
        // Landscape-like size: width > height
        expect(
          deviceWidth(const Size(800, 400)),
          800,
          reason: '$platform should use width',
        );
      }
    });

    test('mobile platforms use size.shortestSide', () {
      for (final platform in [
        TargetPlatform.iOS,
        TargetPlatform.android,
        TargetPlatform.fuchsia,
      ]) {
        debugDefaultTargetPlatformOverride = platform;
        // Landscape phone: shortestSide is height
        expect(
          deviceWidth(const Size(800, 400)),
          400,
          reason: '$platform should use shortestSide',
        );
        // Portrait phone: shortestSide is width
        expect(
          deviceWidth(const Size(400, 800)),
          400,
          reason: '$platform portrait should use shortestSide',
        );
      }
    });
  });

  group('getDeviceType orientation stability on mobile', () {
    test('phone stays mobile in landscape when using shortestSide', () {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

      // ~iPhone landscape logical size; width alone would look like tablet
      final portrait = getDeviceType(const Size(390, 844));
      final landscape = getDeviceType(const Size(844, 390));

      expect(portrait, DeviceScreenType.mobile);
      expect(landscape, DeviceScreenType.mobile);
    });

    test('same landscape size on desktop is classified by width', () {
      debugDefaultTargetPlatformOverride = TargetPlatform.macOS;

      final type = getDeviceType(const Size(844, 390));
      expect(type, DeviceScreenType.tablet);
    });
  });
}
