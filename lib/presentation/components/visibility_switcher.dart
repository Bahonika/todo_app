import 'package:flutter/material.dart';
import 'package:todo_app/presentation/theme/custom_colors.dart';

class VisibilitySwitcher extends StatelessWidget {
  final bool isFilterOff;
  final VoidCallback? onToggle;

  const VisibilitySwitcher({required this.isFilterOff, this.onToggle, Key? key, })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onToggle?.call(),
      child: Icon(
        isFilterOff ? Icons.visibility_off : Icons.visibility,
        size: 24,
        color: Theme.of(context).extension<CustomColors>()!.colorBlue,
      ),
    );
  }
}
