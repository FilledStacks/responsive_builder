import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'drawer_option_mobile.dart';
import 'drawer_option_tablet.dart';

class DrawerOption extends StatelessWidget {
  final String? title;
  final IconData? iconData;
  const DrawerOption({
    Key? key,
    this.title,
    this.iconData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: OrientationLayoutBuilder(
        landscape: (context) => DrawerOptionMobileLandscape(
          iconData: iconData,
        ),
        portrait: (context) => DrawerOptionMobilePortrait(
          title: title,
          iconData: iconData,
        ),
      ),
      tablet: OrientationLayoutBuilder(
        portrait: (context) => DrawerOptionTabletPortrait(
          iconData: iconData,
          title: title,
        ),
        landscape: (context) => DrawerOptionMobilePortrait(
          iconData: iconData,
          title: title,
        ),
      ),
    );
  }
}
