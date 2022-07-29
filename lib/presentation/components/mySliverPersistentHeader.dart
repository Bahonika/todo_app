import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/presentation/providers/todos_provider.dart';
import 'package:todo_app/s.dart';
import 'package:todo_app/theme.dart';

class MySliverPersistentHeader implements SliverPersistentHeaderDelegate {
  final TickerProvider thisVsync;

  MySliverPersistentHeader({required this.thisVsync});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    var todosProvider = context.read<TodosProvider>();
    return Card(
      color: Theme.of(context).scaffoldBackgroundColor,
      margin: EdgeInsets.zero,
      elevation: elevation(shrinkOffset),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: leftPadding(shrinkOffset),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              bottom: bottomTitlePadding(shrinkOffset),
              child: Text(
                S.of(context).myTodos,
                style: CustomTextTheme.title(context).copyWith(
                  fontSize: titleSize(
                    shrinkOffset,
                    context,
                  ),
                  height: titleHeight(
                    shrinkOffset,
                    context,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 18,
              child: Opacity(
                opacity: opacity(shrinkOffset),
                child: Text(
                  "${S.of(context).done}${todosProvider.completedTodos.length}",
                  style: CustomTextTheme.subtitle(context),
                ),
              ),
            ),
            Positioned(
              bottom: bottomIconPadding(shrinkOffset),
              right: rightPadding(shrinkOffset),
              child: const Icon(Icons.remove_red_eye, size: 24),
            ),
          ],
        ),
      ),
    );
  }

  double transition({
    required double from,
    required double to,
    required double shrinkOffset,
    double speed = 1,
  }) {
    // Speed means how fast ratio is changing
    num ratio = pow(shrinkOffset / maxExtent, 1 / speed); // from 0.0 to 1.0
    double difference = to - from;

    double result = from + difference * ratio;
    double clampedResult = result.clamp(
        min(from, to),
        max(from,
            to)); // to avoid getting out of the range of acceptable values
    return clampedResult;
  }

  double elevation(double shrinkOffset) {
    double min = 0;
    double max = 3;
    return transition(from: min, to: max, shrinkOffset: shrinkOffset);
  }

  double titleSize(double shrinkOffset, BuildContext context) {
    double min = Theme.of(context).textTheme.headline2!.fontSize!;
    double max = Theme.of(context).textTheme.headline1!.fontSize!;
    return transition(from: max, to: min, shrinkOffset: shrinkOffset);
  }

  titleHeight(double shrinkOffset, BuildContext context) {
    double max = Theme.of(context).textTheme.headline2!.height!;
    double min = Theme.of(context).textTheme.headline1!.height!;
    return transition(from: max, to: min, shrinkOffset: shrinkOffset);
  }

  double leftPadding(double shrinkOffset) {
    const double min = 16;
    const double max = 60;
    return transition(from: max, to: min, shrinkOffset: shrinkOffset);
  }

  double rightPadding(double shrinkOffset) {
    const double min = 19;
    const double max = 25;
    return transition(from: max, to: min, shrinkOffset: shrinkOffset);
  }

  double bottomTitlePadding(double shrinkOffset) {
    const double min = 16;
    const double max = 44;
    return transition(from: max, to: min, shrinkOffset: shrinkOffset);
  }

  double bottomIconPadding(double shrinkOffset) {
    const double min = 16;
    const double max = 18;
    return transition(from: max, to: min, shrinkOffset: shrinkOffset);
  }

  double opacity(double shrinkOffset) {
    const double min = 0;
    const double max = 1;
    return transition(from: max, to: min, shrinkOffset: shrinkOffset, speed: 4);
  }

  @override
  double get maxExtent => 164;

  @override
  double get minExtent => 88 - 32;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }

  @override
  PersistentHeaderShowOnScreenConfiguration? get showOnScreenConfiguration =>
      const PersistentHeaderShowOnScreenConfiguration();

  @override
  FloatingHeaderSnapConfiguration? get snapConfiguration =>
      FloatingHeaderSnapConfiguration();

  @override
  OverScrollHeaderStretchConfiguration? get stretchConfiguration =>
      OverScrollHeaderStretchConfiguration();

  @override
  // TODO: implement vsync
  TickerProvider? get vsync => thisVsync;
}
