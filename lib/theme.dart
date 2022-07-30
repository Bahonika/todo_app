import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      scaffoldBackgroundColor: const Color(0xFFF7F6F2),
      colorScheme: ColorScheme.fromSwatch().copyWith(
        secondary: const Color(0xFFFFFFFF),
        tertiary: const Color(0xFF007AFF),
        errorContainer: const Color(0xFFFF3B30),
        primaryContainer: const Color(0xFF34C759),
        onPrimary: const Color(0xFF000000),
      ),
      textTheme: const TextTheme(
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
      ),
      switchTheme: SwitchThemeData(
        trackColor:
            MaterialStateColor.resolveWith((states) => const Color(0x0F000000)),
      ),
      dividerColor: const Color(0x33000000),
    );
  }
}

class CustomTextTheme {
  static TextStyle title(BuildContext context) {
    return Theme.of(context).textTheme.headline1!.copyWith(
          color: const Color(0xFF000000),
        );
  }

  static TextStyle subtitle(BuildContext context) {
    return Theme.of(context).textTheme.bodyText1!.copyWith(
          color: const Color(0x4D000000),
        );
  }

  static TextStyle importanceSubtitle(BuildContext context) {
    return const TextStyle(
      color: Color(0x4D000000),
    );
  }

  static TextStyle todoText(BuildContext context) {
    return const TextStyle(
      color: Color(0xFF000000),
    );
  }

  static TextStyle todoTextDone(BuildContext context) {
    return const TextStyle(
      color: Color(0x4D000000),
      decoration: TextDecoration.lineThrough,
    );
  }
}
