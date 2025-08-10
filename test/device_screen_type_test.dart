import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_builder/responsive_builder.dart';

main() {
  group('DeviceScreenType', () {
    test('index', () {
      final list = [
        DeviceScreenType.watch,
        DeviceScreenType.mobile,
        DeviceScreenType.tablet,
        DeviceScreenType.desktop,
      ];
      for (var i = 1; i < list.length; i++) {
        final pre = list[i - 1];
        final cur = list[i];
        expect(pre.index < cur.index, true);
      }
    });
  });
}
