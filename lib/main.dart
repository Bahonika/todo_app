import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/presentation/navigation/simple_navigation/delegate.dart';
import 'package:todo_app/presentation/navigation/simple_navigation/parser.dart';
import 'package:todo_app/presentation/navigation/simple_navigation/provider.dart';
import 'package:todo_app/presentation/providers/providers.dart';
import 'package:todo_app/presentation/theme/theme.dart';
import 'package:todo_app/presentation/localization/localizations_delegates.dart';
import 'package:todo_app/presentation/localization/s.dart';


import 'presentation/providers/services_providers.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // runZonedGuarded(() async {
  //   // AppMetrica connect
  //   AppMetrica.activate(
  //       const AppMetricaConfig("ff7f421f-c1c5-40bd-b5a5-126f517cdf75"));
  //
  //   await Firebase.initializeApp(
  //     options: DefaultFirebaseOptions.currentPlatform,
  //   );
  //
  //   //Crashlytics connect
  //   FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  // }, (error, stack) {
  //   FirebaseCrashlytics.instance.recordError(error, stack);
  // });

  runApp(
    ProviderScope(
      child: Consumer(
        builder: (context, WidgetRef ref, _) => FutureBuilder(
          //future provider
            future: ref
                .watch(ServicesProviders.serviceUtilProvider)
                .localService
                .init(),
            builder: (context, snapshot) {
              return snapshot.connectionState == ConnectionState.done
                  ? const MyApp()
                  : const Center(child: CircularProgressIndicator());
            }),
      ),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(DataProviders.isDarkProvider);
    return MaterialApp.router(
      // routerDelegate: ref.read(NavigationProviders.routerDelegateProvider),
      // routeInformationParser: TypedSegmentRouteInformationParser(),
      // debugShowCheckedModeBanner: false,
      routerDelegate: ref.watch(routerDelegateProvider),
      routeInformationParser: BooksShelfRouteInformationParser(),
      routeInformationProvider: DebugRouteInformationProvider(),

      // theme
      theme: CustomTheme.lightTheme,
      darkTheme: CustomTheme.darkTheme,
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,

      //localization
      localizationsDelegates: LocalizationsDelegates.delegates,
      supportedLocales: S.supportedLocales,
      // locale: S.current,
    );
  }
}
