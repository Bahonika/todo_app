import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/presentation/providers/providers.dart';
import 'package:todo_app/presentation/theme/theme.dart';
import 'package:todo_app/presentation/localization/localizations_delegates.dart';
import 'package:todo_app/presentation/localization/s.dart';

import 'firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runZonedGuarded(() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    //Crashlytics connect
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  }, (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack);
  });

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navigator = ref.watch(DataProviders.navigationProvider);
    final isDark = ref.watch(DataProviders.isDarkProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // theme
      theme: CustomTheme.lightTheme,
      darkTheme: CustomTheme.darkTheme,
      themeMode: isDark
          ? ThemeMode.dark
          : ThemeMode.light,

      //localization
      localizationsDelegates: LocalizationsDelegates.delegates,
      supportedLocales: S.supportedLocales,
      locale: S.current,

      // navigation
      onUnknownRoute: (settings) => navigator.toUnknownPage(),
      initialRoute: navigator.initialRoute,
      onGenerateRoute: (settings) => navigator.onGenerateRoute(settings),
      navigatorKey: navigator.key,
    );
  }
}
