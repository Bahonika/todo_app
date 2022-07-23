import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/providers/create_task_data_provider.dart';
import 'package:todo_app/s.dart';
import 'package:todo_app/theme.dart';
import 'package:todo_app/todo_list_screen.dart';
import 'package:todo_app/providers/todos_provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => TodosProvider()),
      ChangeNotifierProvider(
        create: (_) => CreateTaskDataProvider(),
      ),
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
  var _isDark = false;
  var _locale = S.en;

  @override
  Widget build(BuildContext context) {
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
      // builder: (context, child) => SafeArea(
      //   child: Material(
      //     child: Stack(
      //       children: [
      //         Align(
      //           alignment: Alignment.topLeft,
      //           child: Row(
      //             crossAxisAlignment: CrossAxisAlignment.center,
      //             mainAxisSize: MainAxisSize.min,
      //             children: [
      //               Padding(
      //                 padding: const EdgeInsets.all(12.0),
      //                 child: IconButton(
      //                   onPressed: () {
      //                     final newMode = !_isDark;
      //                     setState(() => _isDark = newMode);
      //                   },
      //                   icon: Icon(
      //                     _isDark ? Icons.sunny : Icons.nightlight_round,
      //                   ),
      //                 ),
      //               ),
      //               Padding(
      //                 padding: const EdgeInsets.all(12.0),
      //                 child: InkResponse(
      //                   child: Text(_locale.languageCode.toUpperCase()),
      //                   onTap: () {
      //                     final newLocale = S.isEn(_locale) ? S.ru : S.en;
      //                     setState(() => _locale = newLocale);
      //                   },
      //                 ),
      //               ),
      //             ],
      //           ),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),

      home: const Navigator(
        pages: [
          MaterialPage(
            child: TodoListScreen(),
          ),
        ],
      ),
    );
  }
}
