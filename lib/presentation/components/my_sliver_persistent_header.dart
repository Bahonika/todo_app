import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/presentation/theme/custom_colors.dart';
import 'package:todo_app/presentation/localization/s.dart';
import 'package:todo_app/presentation/providers/todos_provider.dart';
import 'package:todo_app/presentation/theme/custom_text_theme.dart';

import '../../domain/models/todo.dart';

class MySliverPersistentHeader implements SliverPersistentHeaderDelegate {
  final TickerProvider thisVsync;

  MySliverPersistentHeader({required this.thisVsync});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Consumer<List<Todo>>(
      builder: (context, todos, _) => Card(
        color: background(shrinkOffset, context),
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
                    "${S.of(context).done}${todos.where((element) => element.done).length}",
                    style: CustomTextTheme.subtitle(context),
                  ),
                ),
              ),
              Positioned(
                bottom: bottomIconPadding(shrinkOffset),
                right: rightPadding(shrinkOffset),
                child: InkWell(
                    onTap: () {
                      context.read<TodosProvider>().showCompleted =
                          !context.read<TodosProvider>().showCompleted;
                    },
                    child: context.watch<TodosProvider>().showCompleted
                        ? Icon(
                            Icons.visibility_off,
                            size: 24,
                            color: Theme.of(context)
                                .extension<CustomColors>()!
                                .colorBlue,
                          )
                        : Icon(
                            Icons.visibility,
                            size: 24,
                            color: Theme.of(context)
                                .extension<CustomColors>()!
                                .colorBlue,
                          )),
              ),
            ],
          ),
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

  Color background(double shrinkOffset, BuildContext context) {
    Color? temp = Color.lerp(
        Theme.of(context).extension<CustomColors>()!.backPrimary,
        Theme.of(context).extension<CustomColors>()!.backSecondaryForHeader,
        transition(from: 0, to: 1, shrinkOffset: shrinkOffset));
    return temp!;
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
  TickerProvider? get vsync => thisVsync;
}
