import 'package:flutter/material.dart';

class CustomTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      // Back Primary
      scaffoldBackgroundColor: const Color(0xFFF7F6F2),
      colorScheme: ColorScheme.fromSwatch().copyWith(
        //Back Secondary
        secondary: const Color(0xFFFFFFFF),
        // Color Blue
        tertiary: const Color(0xFF007AFF),
        // Color Red
        errorContainer: const Color(0xFFFF3B30),
        // Color Green
        primaryContainer: const Color(0xFF34C759),
        // Color Gray
        inversePrimary: const Color(0xFF8E8E93),
        // Color Gray light
        onInverseSurface: const Color(0xFFD1D1D6),
        //Color White
        surface: const Color(0xFFFFFFFF),
        // Label Primary
        onPrimary: const Color(0xFF000000),
        // Label Secondary
        onSecondary: const Color(0x99999999),
        // Label Tertiary
        onTertiary:  const Color(0x4D000000),
        // Label Disabled
        secondaryContainer: const Color(0x26000000),
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
