import 'package:flutter/material.dart';
import 'package:todo_app/presentation/theme/custom_colors.dart';

class CustomTextTheme {
  static TextStyle title(BuildContext context) {
    return Theme.of(context).textTheme.headline1!.copyWith(
          color: Theme.of(context).extension<CustomColors>()!.labelPrimary,
        );
  }

  static TextStyle subtitle(BuildContext context) {
    return Theme.of(context).textTheme.bodyText1!.copyWith(
          color: Theme.of(context).extension<CustomColors>()!.labelTertiary,
        );
  }

  static TextStyle importanceSubtitle(BuildContext context) {
    return Theme.of(context).textTheme.subtitle1!.copyWith(
          color: Theme.of(context).extension<CustomColors>()!.labelTertiary,
        );
  }

  static TextStyle body(BuildContext context) {
    return Theme.of(context).textTheme.bodyText1!.copyWith(
          color: Theme.of(context).extension<CustomColors>()!.labelPrimary,
        );
  }

  static TextStyle bodyLineThrough(BuildContext context) {
    return Theme.of(context).textTheme.bodyText1!.copyWith(
          color: Theme.of(context).extension<CustomColors>()!.labelTertiary,
          decoration: TextDecoration.lineThrough,
          decorationColor:
              Theme.of(context).extension<CustomColors>()!.labelTertiary,
        );
  }

  static TextStyle error(BuildContext context) {
    return Theme.of(context)
        .textTheme
        .bodyText1!
        .copyWith(color: Theme.of(context).extension<CustomColors>()!.colorRed);
  }
}
