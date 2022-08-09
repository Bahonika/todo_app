import 'package:flutter/material.dart';

extension CustomColorScheme on ColorScheme {
  Color get supportSeparator => const Color(0x33000000);

  Color get supportOverlay => const Color(0x0F000000);

  Color get labelPrimary => const Color(0xFF000000);

  Color get labelSecondary => const Color(0x99000000);

  Color get labelTertiary => const Color(0x4D000000);

  Color get labelDisable => const Color(0x26000000);

  Color get colorRed => const Color(0xFFFF3B30);

  Color get colorGreen => const Color(0xFF34C759);

  Color get colorBlue => const Color(0xFF007AFF);

  Color get colorGray => const Color(0xFF8E8E93);

  Color get colorGrayLight => const Color(0xFFD1D1D6);

  Color get colorWhite => const Color(0xFFFFFFFF);

  Color get backPrimary => const Color(0xFFF7F6F2);

  Color get backSecondary => const Color(0xFFFFFFFF);

  Color get backElevated => const Color(0xFFFFFFFF);
}

class CustomColors extends ThemeExtension<CustomColors> {
  CustomColors({
    required this.supportSeparator,
    required this.supportOverlay,
    required this.labelPrimary,
    required this.labelSecondary,
    required this.labelTertiary,
    required this.labelDisable,
    required this.colorRed,
    required this.colorGreen,
    required this.colorBlue,
    required this.colorGray,
    required this.colorGrayLight,
    required this.colorWhite,
    required this.backPrimary,
    required this.backSecondary,
    required this.backElevated,
  });

  final Color supportSeparator;
  final Color supportOverlay;
  final Color labelPrimary;
  final Color labelSecondary;
  final Color labelTertiary;
  final Color labelDisable;
  final Color colorRed;
  final Color colorGreen;
  final Color colorBlue;
  final Color colorGray;
  final Color colorGrayLight;
  final Color colorWhite;
  final Color backPrimary;
  final Color backSecondary;
  final Color backElevated;

  @override
  CustomColors copyWith({
    Color? supportSeparator,
    Color? supportOverlay,
    Color? labelPrimary,
    Color? labelSecondary,
    Color? labelTertiary,
    Color? labelDisable,
    Color? colorRed,
    Color? colorGreen,
    Color? colorBlue,
    Color? colorGray,
    Color? colorGrayLight,
    Color? colorWhite,
    Color? backPrimary,
    Color? backSecondary,
    Color? backElevated,
  }) {
    return CustomColors(
      supportSeparator: supportSeparator ?? this.supportSeparator,
      supportOverlay: supportOverlay ?? this.supportOverlay,
      labelPrimary: labelPrimary ?? this.labelPrimary,
      labelSecondary: labelSecondary ?? this.labelSecondary,
      labelTertiary: labelTertiary ?? this.labelTertiary,
      labelDisable: labelDisable ?? this.labelDisable,
      colorRed: colorRed ?? this.colorRed,
      colorGreen: colorGreen ?? this.colorGreen,
      colorBlue: colorBlue ?? this.colorBlue,
      colorGray: colorGray ?? this.colorGray,
      colorGrayLight: colorGrayLight ?? this.colorGrayLight,
      colorWhite: colorWhite ?? this.colorWhite,
      backPrimary: backPrimary ?? this.backPrimary,
      backSecondary: backSecondary ?? this.backSecondary,
      backElevated: backElevated ?? this.backElevated,
    );
  }

  @override
  ThemeExtension<CustomColors> lerp(
      ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) {
      return this;
    }
    return CustomColors(
      supportSeparator:
          Color.lerp(supportSeparator, other.supportSeparator, t)!,
      supportOverlay: Color.lerp(supportOverlay, other.supportOverlay, t)!,
      labelPrimary: Color.lerp(labelPrimary, other.labelPrimary, t)!,
      labelSecondary: Color.lerp(labelSecondary, other.labelSecondary, t)!,
      labelTertiary: Color.lerp(labelTertiary, other.labelTertiary, t)!,
      labelDisable: Color.lerp(labelDisable, other.labelDisable, t)!,
      colorRed: Color.lerp(colorRed, other.colorRed, t)!,
      colorGreen: Color.lerp(colorGreen, other.colorGreen, t)!,
      colorBlue: Color.lerp(colorBlue, other.colorBlue, t)!,
      colorGray: Color.lerp(colorGray, other.colorGray, t)!,
      colorGrayLight: Color.lerp(colorGrayLight, other.colorGrayLight, t)!,
      colorWhite: Color.lerp(colorWhite, other.colorWhite, t)!,
      backPrimary: Color.lerp(backPrimary, other.backPrimary, t)!,
      backSecondary: Color.lerp(backSecondary, other.backSecondary, t)!,
      backElevated: Color.lerp(backElevated, other.backElevated, t)!,
    );
  }

  static final light = CustomColors(
    supportSeparator: const Color(0x33000000),
    supportOverlay: const Color(0x0F000000),
    labelPrimary: const Color(0xFF000000),
    labelSecondary: const Color(0x99000000),
    labelTertiary: const Color(0x4D000000),
    labelDisable: const Color(0x26000000),
    colorRed: const Color(0xFFFF3B30),
    colorGreen: const Color(0xFF34C759),
    colorBlue: const Color(0xFF007AFF),
    colorGray: const Color(0xFF8E8E93),
    colorGrayLight: const Color(0xFFD1D1D6),
    colorWhite: const Color(0xFFFFFFFF),
    backPrimary: const Color(0xFFF7F6F2),
    backSecondary: const Color(0xFFFFFFFF),
    backElevated: const Color(0xFFFFFFFF),
  );

  static final dark = CustomColors(
    supportSeparator: const Color(0x33FFFFFF),
    supportOverlay: const Color(0x52000000),
    labelPrimary: const Color(0xFFFFFFFF),
    labelSecondary: const Color(0x99FFFFFF),
    labelTertiary: const Color(0x66FFFFFF),
    labelDisable: const Color(0x26FFFFFF),
    colorRed: const Color(0xFFFF453A),
    colorGreen: const Color(0xFF32D74B),
    colorBlue: const Color(0xFF0A84FF),
    colorGray: const Color(0xFF8E8E93),
    colorGrayLight: const Color(0xFF48484A),
    colorWhite: const Color(0xFFFFFFFF),
    backPrimary: const Color(0xFF161618),
    backSecondary: const Color(0xFF252528),
    backElevated: const Color(0xFF3C3C3F),
  );
}
