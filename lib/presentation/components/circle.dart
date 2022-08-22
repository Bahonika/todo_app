import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/presentation/providers/providers.dart';
import 'package:todo_app/presentation/theme/custom_colors.dart';

class Circle extends ConsumerStatefulWidget {
  final double height;

  const Circle({required this.height, Key? key}) : super(key: key);

  @override
  ConsumerState<Circle> createState() => _CircleState();
}

class _CircleState extends ConsumerState<Circle> {
  @override
  Widget build(BuildContext context) {
    final height = widget.height - 25;
    final opacity = ref.watch(DataProviders.opacityProvider);
    final isDark = ref.watch(DataProviders.isDarkProvider);
    final darkColor = Theme.of(context).extension<CustomColors>()!.colorWhite;
    const lightColor = Colors.yellow;
    final currentColor = isDark ? darkColor : lightColor;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 500),
      opacity: opacity,
      child: Container(
        height: height,
        width: height,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(200),
          border: Border.all(color: currentColor, width: 5),
        ),
        child: isDark
            ? Image.asset(
                "assets/moon.png",
                color: currentColor,
              )
            : Image.asset(
                "assets/sun.png",
                color: currentColor,
              ),
      ),
    );
  }
}
