import 'package:example/views/home/home_view_mobile.dart';
import 'package:example/views/home/home_view_tablet.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      breakpoints: ScreenBreakpoints(
          watch: 300,
          mobileSmall: 480,
          mobileTabletNormal: 767,
          tabletLarge: 1024,
          monitorSmall: 1280,
          monitorLarge: 1650,
          monitorExtraLarge: 1650),
      mobileTabletNormal: OrientationLayoutBuilder(
        portrait: (context) => HomeMobilePortrait(),
        landscape: (context) => HomeMobileLandscape(),
      ),
      tabletLarge: HomeViewTablet(),
    );
  }
}
