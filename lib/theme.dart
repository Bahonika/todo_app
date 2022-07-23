import 'package:flutter/material.dart';

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
    return const TextStyle(
      color: Color(0xFF000000),
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle subtitle(BuildContext context) {
    return const TextStyle(
      color: Color(0x4D000000),
      fontSize: 10,
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
