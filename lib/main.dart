import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/presentation/navigation/navigation_controller.dart';
import 'package:todo_app/presentation/navigation/routes.dart';
import 'package:todo_app/presentation/providers/revision_provider.dart';
import 'package:todo_app/presentation/providers/todos_provider.dart';
import 'package:todo_app/presentation/todo_create_screen.dart';
import 'package:todo_app/presentation/todo_list_screen.dart';
import 'package:todo_app/s.dart';
import 'package:todo_app/theme.dart';
import 'presentation/providers/create_task_data_provider.dart';

void main()  {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => TodosProvider()),
      ChangeNotifierProvider(create: (_) => CreateTaskDataProvider()),
      ChangeNotifierProvider(create: (_) => RevisionProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // wont control manually
  // todo: will set the same as in system settings
  var _isDark = false;
  var _locale = S.en;

  boxer() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();

    Hive.init(appDocDir.path);
    await Hive.openBox("hello");
    var box = Hive.box("hello");
    await box.put("name", "david");
    box.close();
    Hive.close();
  }

  @override
  Widget build(BuildContext context) {

    final navigationController = NavigationController();
    
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Theme.of(context).scaffoldBackgroundColor,
        systemNavigationBarColor: Theme.of(context).scaffoldBackgroundColor,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark));
    return Provider<NavigationController>.value(
      value: navigationController,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Todo App',
        theme: CustomTheme.lightTheme,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: S.supportedLocales,
        locale: _locale,
        //Todo upgrade to navigator 2.0

        onUnknownRoute: (settings) => MaterialPageRoute(builder: (context) => Container()),

        initialRoute: Routes.todoList,
        onGenerateRoute: (settings) {
          switch (settings.name){
            case Routes.todoList:
              return MaterialPageRoute(
                  builder: (_) => const TodoListScreen());
            case Routes.createTodo:
              return MaterialPageRoute(
                  builder: (_) => const TodoCreateScreen());

          }
        },
        navigatorKey: navigationController.key,
        // home: Navigator(
        //   pages: const [
        //     MaterialPage(
        //       key: ValueKey('TodoListPage'),
        //       child: TodoListScreen(),
        //     )
        //   ],
        //   onPopPage: (route, result) => route.didPop(result),
        // ),
      ),
    );
  }
}
