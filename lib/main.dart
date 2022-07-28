import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/presentation/providers/revision_provider.dart';
import 'package:todo_app/presentation/providers/todos_provider.dart';
import 'package:todo_app/presentation/todo_list_screen.dart';
import 'package:todo_app/s.dart';
import 'package:todo_app/theme.dart';
import 'presentation/providers/create_task_data_provider.dart';

void main() {
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
  var _locale = S.ru;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Theme.of(context).scaffoldBackgroundColor,
        systemNavigationBarColor: Theme.of(context).scaffoldBackgroundColor,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark));
    return MaterialApp(
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
      home: Navigator(
        pages: const [
          MaterialPage(
            key: ValueKey('TodoListPage'),
            child: TodoListScreen(),
          )
        ],
        onPopPage: (route, result) => route.didPop(result),
      ),
    );
  }
}
