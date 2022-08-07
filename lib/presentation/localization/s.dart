import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
export 'package:flutter_gen/gen_l10n/app_localizations.dart';

class S {
  static const en = Locale('en');
  static const ru = Locale('ru');

  static final current = Locale(Platform.localeName.substring(0, 2));

  static const supportedLocales = [en, ru];

  static LocalizationsDelegate<AppLocalizations> get delegate =>
      AppLocalizations.delegate;

  static AppLocalizations of(BuildContext context) =>
      AppLocalizations.of(context)!;

  static bool isEn(Locale locale) => locale == en;

  const S._();
}