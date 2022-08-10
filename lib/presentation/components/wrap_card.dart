import 'package:flutter/material.dart';
import 'package:todo_app/presentation/theme/custom_colors.dart';

class WrapCard extends StatelessWidget {
  final Widget child;

  const WrapCard({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      color: Theme.of(context).extension<CustomColors>()!.backSecondary,
      child: child,
    );
  }
}
