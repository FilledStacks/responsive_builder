import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScrollTransformItem extends StatelessWidget {
  final Offset Function(double scrollOffset)? offsetBuilder;
  final double Function(double scrollOffset)? scaleBuilder;
  final Widget Function(double scrollOffset) builder;
  final bool logOffset;
  const ScrollTransformItem({
    Key? key,
    required this.builder,
    this.offsetBuilder,
    this.scaleBuilder,
    this.logOffset = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ScrollController>(
      builder: (context, value, child) {
        final builtOffset = offsetBuilder?.call(value.offset);
        return Transform.scale(
          scale: scaleBuilder?.call(value.offset) ?? 1,
          child: Transform.translate(
            offset: builtOffset ?? Offset.zero,
            child: builder(value.offset),
          ),
        );
      },
    );
  }
}
