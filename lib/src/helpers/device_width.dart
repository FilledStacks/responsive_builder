import 'dart:io';
import 'dart:ui';

double deviceWidth(Size size) {
  if (Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
    return size.width;
  }
  return size.shortestSide;
}
