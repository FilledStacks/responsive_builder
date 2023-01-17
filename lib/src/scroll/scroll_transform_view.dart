import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/src/scroll/scroll_transform_item.dart';

class ScrollTransformView extends StatefulWidget {
  final List<ScrollTransformItem> children;
  const ScrollTransformView({
    Key? key,
    required this.children,
  }) : super(key: key);

  @override
  State<ScrollTransformView> createState() => _ScrollTransformViewState();
}

class _ScrollTransformViewState extends State<ScrollTransformView> {
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: scrollController,
      child: ChangeNotifierProvider(
        create: (context) => scrollController,
        child: Column(
          children: widget.children,
        ),
      ),
    );
  }
}
