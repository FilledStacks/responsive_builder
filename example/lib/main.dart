import 'package:example/views/home/home_view.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ResponsiveApp(
      builder: (context) {
        return MaterialApp(
          title: 'Flutter Demo',
          home: HomeView(),
        );
      },
    );
  }
}
