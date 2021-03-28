import 'package:example/views/home/home_view_mobile.dart';
import 'package:example/views/home/home_view_tablet.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      breakpoints: ScreenBreakpoints(desktop: 900, tablet: 650, watch: 250),
      mobile: OrientationLayoutBuilder(
        portrait: (context) => HomeMobilePortrait(),
        landscape: (context) => HomeMobileLandscape(),
      ),
      tablet: HomeViewTablet(),
    );
  }
}
