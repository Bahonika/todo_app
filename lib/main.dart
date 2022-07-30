import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/data/api/services/local.dart';
import 'package:todo_app/presentation/components/theme.dart';
import 'package:todo_app/presentation/navigation/localozations_delegates.dart';
import 'package:todo_app/presentation/navigation/navigation_controller.dart';
import 'package:todo_app/presentation/providers/create_task_data_provider.dart';
import 'package:todo_app/presentation/providers/revision_provider.dart';
import 'package:todo_app/presentation/providers/todos_provider.dart';
import 'package:todo_app/presentation/components/s.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //init hive storage
  LocalService localService = LocalService.localService();
  await localService.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TodosProvider()),
        ChangeNotifierProvider(create: (_) => CreateTaskDataProvider()),
        ChangeNotifierProvider(create: (_) => RevisionProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // wont control manually
  // todo: will set the same as in system settings
  // final _isDark = false;
  final _locale = S.ru;

  // late final Box todos;

  @override
  Widget build(BuildContext context) {
    final navigationController = NavigationController();

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Theme.of(context).scaffoldBackgroundColor,
        systemNavigationBarColor: Theme.of(context).scaffoldBackgroundColor,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark));
    return
      // ValueListenableBuilder(
      // valueListenable: todos.listenable(),
      // builder: (context, Box box, _) =>
      Provider<NavigationController>.value(
        value: navigationController,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Todo App',
          theme: CustomTheme.lightTheme,
          localizationsDelegates: LocalizationsDelegates.delegates,
          supportedLocales: S.supportedLocales,
          locale: _locale,

          //Todo upgrade to navigator 2.0
          onUnknownRoute: (settings) =>
              MaterialPageRoute(builder: (context) => Container()),
          initialRoute: navigationController.initialRoute,
          onGenerateRoute: (settings) =>
              navigationController.onGenerateRoute(settings),
          navigatorKey: navigationController.key,
        ),
      // ),
    );
  }
}
