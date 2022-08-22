import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/presentation/components/circle.dart';
import 'package:todo_app/presentation/providers/providers.dart';
import 'package:todo_app/presentation/providers/todos_notifier.dart';
import 'package:todo_app/presentation/theme/custom_colors.dart';
import 'package:todo_app/presentation/localization/s.dart';
import 'package:todo_app/presentation/theme/custom_text_theme.dart';

class MySliverPersistentHeader implements SliverPersistentHeaderDelegate {
  final TickerProvider thisVsync;

  MySliverPersistentHeader({required this.thisVsync});

  List<Offset> list = [];

  // функция, которая расчитвает, нарисовал ли пользователь круг или нет
  // есть еще пару идей, как сделать это красивее
  void check(WidgetRef ref, bool showCircle) {
    // тут пока просто принты для отслеживания расчетов
    // знаю, что нехорошо, удалю, когда буду уверен, что все ок
    // или перенесу в логгер

    List<double> listY = list.map((e) => e.dy).toList()..sort();
    List<double> listX = list.map((e) => e.dx).toList()..sort();

    // расчет крайних точек фигуры
    Offset maxX = list.firstWhere((element) => element.dx == listX.last); // 3
    Offset minX = list.firstWhere((element) => element.dx == listX.first); // 1
    Offset maxY = list.firstWhere((element) => element.dy == listY.last); // 4
    Offset minY = list.firstWhere((element) => element.dy == listY.first); // 2

    //расчет координат центра между крайними точками
    final centerX = (minX.dx + minY.dx + maxX.dx + maxY.dx) / 4;
    final centerY = (minX.dy + minY.dy + maxX.dy + maxY.dy) / 4;

    final centerOffset = Offset(centerX, centerY);

    // расчет максимального и минимального "радиусов"
    double minDistance = double.infinity;
    double maxDistance = 0;
    for (Offset offset in list) {
      final distance = sqrt(pow(offset.dx - centerOffset.dx, 2) +
          pow(offset.dy - centerOffset.dy, 2));
      if (distance < minDistance) {
        minDistance = distance;
      }
      if (distance > maxDistance) {
        maxDistance = distance;
      }
    }

    // похожа ли фигура на окружность
    // если разница между радиусами небольшая, то окружность
    final isCircle = maxDistance / minDistance < 1.7;

    // если близко к окружности, то поменять тему
    if (isCircle) {
      ref.read(DataProviders.isDarkProvider.notifier).toggle();
    } else if (showCircle) {
      ref.read(DataProviders.opacityProvider.notifier).toggle();
    }
  }

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final state = ref.watch(DataProviders.todosController);
        final stateNotifier = ref.watch(DataProviders.todosController.notifier);

        return Listener(
          // считываем движение пальца, пользователь должен нарисовать круг
          onPointerUp: (details) {
            if (list.length > 4) {
              check(ref, maxExtent - shrinkOffset == maxExtent);
            }
            list.clear();
          },
          onPointerMove: (details) {
            list.add(details.position);
          },
          child: Card(
            color: background(shrinkOffset, context),
            margin: EdgeInsets.zero,
            elevation: elevation(shrinkOffset),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Positioned(
                  bottom: bottomTitlePadding(shrinkOffset),
                  left: leftPadding(shrinkOffset),
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
                  left: leftPadding(shrinkOffset),
                  child: Opacity(
                    opacity: opacity(shrinkOffset),
                    child: Text(
                      "${S.of(context).done}"
                      "${stateNotifier.doneLength}",
                      style: CustomTextTheme.subtitle(context),
                    ),
                  ),
                ),
                Positioned(
                  bottom: bottomIconPadding(shrinkOffset),
                  right: rightPadding(shrinkOffset),
                  child: InkWell(
                    onTap: stateNotifier.toggleFilter,
                    child: state.showAll
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
                          ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Circle(
                    height: maxExtent - shrinkOffset,
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  double transition({
    required double from,
    required double to,
    required double shrinkOffset,
    double speed = 1, // Speed means how fast ratio is changing
  }) {
    final ratio = pow(shrinkOffset / maxExtent, 1 / speed); // from 0.0 to 1.0
    final difference = to - from;

    final result = from + difference * ratio;
    final double clampedResult = result.clamp(
      min(from, to),
      max(from, to),
    ); // to avoid getting out of the range of acceptable values
    return clampedResult;
  }

  Color background(double shrinkOffset, BuildContext context) {
    final temp = Color.lerp(
        Theme.of(context).extension<CustomColors>()!.backPrimary,
        Theme.of(context).extension<CustomColors>()!.backSecondaryForHeader,
        transition(from: 0, to: 1, shrinkOffset: shrinkOffset));
    return temp!;
  }

  double elevation(double shrinkOffset) {
    const min = 0.0;
    const max = 3.0;
    return transition(from: min, to: max, shrinkOffset: shrinkOffset);
  }

  double titleSize(double shrinkOffset, BuildContext context) {
    final min = Theme.of(context).textTheme.headline2!.fontSize!;
    final max = Theme.of(context).textTheme.headline1!.fontSize!;
    return transition(from: max, to: min, shrinkOffset: shrinkOffset);
  }

  titleHeight(double shrinkOffset, BuildContext context) {
    final max = Theme.of(context).textTheme.headline2!.height!;
    final min = Theme.of(context).textTheme.headline1!.height!;
    return transition(from: max, to: min, shrinkOffset: shrinkOffset);
  }

  double leftPadding(double shrinkOffset) {
    const min = 16.0;
    const max = 60.0;
    return transition(from: max, to: min, shrinkOffset: shrinkOffset);
  }

  double rightPadding(double shrinkOffset) {
    const min = 19.0;
    const max = 25.0;
    return transition(from: max, to: min, shrinkOffset: shrinkOffset);
  }

  double bottomTitlePadding(double shrinkOffset) {
    const min = 16.0;
    const max = 44.0;
    return transition(from: max, to: min, shrinkOffset: shrinkOffset);
  }

  double bottomIconPadding(double shrinkOffset) {
    const min = 16.0;
    const max = 18.0;
    return transition(from: max, to: min, shrinkOffset: shrinkOffset);
  }

  double opacity(double shrinkOffset) {
    const min = 0.0;
    const max = 1.0;
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
