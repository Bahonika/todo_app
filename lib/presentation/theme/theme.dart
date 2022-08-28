import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todo_app/presentation/theme/custom_colors.dart';

class CustomTheme {
  static bool isImportanceRed = true;

  static const TextTheme textTheme = TextTheme(
    // Large title — 32/38
    headline1: TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 32,
      height: 38 / 32,
    ),
    // Title 20/32
    headline2: TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 20,
      height: 32 / 20,
    ),
    // Button 14/24
    button: TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 14,
      height: 24 / 14,
    ),
    // Body 16/20
    bodyText1: TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 16,
      height: 20 / 16,
    ),
    // Subhead 14/20
    subtitle1: TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 14,
      height: 20 / 14,
    ),
  );

  static ThemeData get lightTheme {
    return ThemeData.light().copyWith(
      extensions: [CustomColors.light],
      textTheme: textTheme,
      scaffoldBackgroundColor: CustomColors.light.backPrimary,
      backgroundColor: CustomColors.light.backPrimary,
      appBarTheme: AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle(
          systemNavigationBarColor: CustomColors.light.backPrimary,
          statusBarColor: CustomColors.light.backPrimary,
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.dark,
        ),
      ),
      switchTheme: SwitchThemeData(
        trackColor: MaterialStateColor.resolveWith(
          (states) => CustomColors.light.supportOverlay,
        ),
        thumbColor: MaterialStateColor.resolveWith(
          (states) => CustomColors.light.backElevated,
        ),
      ),
      unselectedWidgetColor: CustomColors.light.supportSeparator,
      dividerColor: CustomColors.light.supportSeparator,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData.dark().copyWith(
      extensions: [CustomColors.dark],
      textTheme: textTheme,
      scaffoldBackgroundColor: CustomColors.dark.backPrimary,
      appBarTheme: AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle(
          systemNavigationBarColor: CustomColors.dark.backPrimary,
          statusBarColor: CustomColors.dark.backPrimary,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.light,
        ),
      ),
      switchTheme: SwitchThemeData(
          trackColor: MaterialStateColor.resolveWith(
              (states) => CustomColors.dark.supportOverlay),
          thumbColor: MaterialStateColor.resolveWith(
              (states) => CustomColors.dark.backElevated)),
      unselectedWidgetColor: CustomColors.dark.supportSeparator,
      dividerColor: CustomColors.dark.supportSeparator,
    );
  }
}
