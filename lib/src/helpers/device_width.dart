import 'dart:ui';

import 'package:flutter/foundation.dart';

/// Width used for device-type / breakpoint classification.
///
/// Uses [Size.width] on web (CanvasKit and Wasm) and desktop OS targets;
/// uses [Size.shortestSide] on mobile so orientation does not flip the type.
double deviceWidth(Size size) {
  if (kIsWeb) {
    return size.width;
  }

  switch (defaultTargetPlatform) {
    case TargetPlatform.macOS:
    case TargetPlatform.windows:
    case TargetPlatform.linux:
      return size.width;
    case TargetPlatform.android:
    case TargetPlatform.iOS:
    case TargetPlatform.fuchsia:
      return size.shortestSide;
  }
}
