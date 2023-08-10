import 'package:responsive_builder/responsive_builder.dart';

enum DeviceScreenType {
  @Deprecated('Use lowercase version')
  Mobile(1),
  @Deprecated('Use lowercase version')
  Tablet(2),
  @Deprecated('Use lowercase version')
  Desktop(3),
  @Deprecated('Use lowercase version')
  Watch(0),
  mobile(1),
  tablet(2),
  desktop(3),
  watch(0);

  const DeviceScreenType(this._ordinal);

  final int _ordinal;

  bool operator >(DeviceScreenType other) => _ordinal > other._ordinal;

  bool operator >=(DeviceScreenType other) => _ordinal >= other._ordinal;

  bool operator <(DeviceScreenType other) => _ordinal < other._ordinal;

  bool operator <=(DeviceScreenType other) => _ordinal <= other._ordinal;
}

enum RefinedSize {
  small,
  normal,
  large,
  extraLarge;

  bool operator >(RefinedSize other) => index > other.index;

  bool operator >=(RefinedSize other) => index >= other.index;

  bool operator <(RefinedSize other) => index < other.index;

  bool operator <=(RefinedSize other) => index <= other.index;
}
