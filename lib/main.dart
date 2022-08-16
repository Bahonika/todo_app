import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/presentation/providers/services_providers.dart';
import 'package:todo_app/presentation/theme/theme.dart';
import 'package:todo_app/presentation/localization/localizations_delegates.dart';
import 'package:todo_app/presentation/navigation/navigation_controller.dart';
import 'package:todo_app/presentation/localization/s.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //Crashlytics connect
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

final navigationProvider = Provider<NavigationController>((ref) {
  return NavigationController();
});

class MyApp extends ConsumerStatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void dispose() {
    ref.read(ServicesProviders.localServiceProvider).dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Theme.of(context).scaffoldBackgroundColor,
        systemNavigationBarColor: Theme.of(context).scaffoldBackgroundColor,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return Consumer(builder: (BuildContext context, WidgetRef ref, _) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,

        // theme
        theme: CustomTheme.lightTheme,
        darkTheme: CustomTheme.darkTheme,
        themeMode: ThemeMode.light,

        //localization
        localizationsDelegates: LocalizationsDelegates.delegates,
        supportedLocales: S.supportedLocales,
        locale: S.current,

        // navigation
        onUnknownRoute: (settings) =>
            ref.read(navigationProvider).toUnknownPage(),
        initialRoute: ref.read(navigationProvider).initialRoute,
        onGenerateRoute: (settings) =>
            ref.read(navigationProvider).onGenerateRoute(settings),
        navigatorKey: ref.read(navigationProvider).key,
      );
    });
  }
}
