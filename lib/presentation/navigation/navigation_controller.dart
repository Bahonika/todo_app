import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/presentation/components/unknown_page.dart';
import 'package:todo_app/presentation/navigation/routes.dart';
import 'package:todo_app/presentation/screens/todo_create_screen.dart';
import 'package:todo_app/presentation/screens/todo_list_screen.dart';

class NavigationController {
  final GlobalKey<NavigatorState> _key = GlobalKey();

  GlobalKey<NavigatorState> get key => _key;

  void navigateTo(String page, {Object? arguments}) {
    _key.currentState?.pushNamed(page, arguments: arguments);
  }

  void pop([Object? result]) {
    _key.currentState?.pop(result);
  }

  Future<T> pushDialog<T>(RawDialogRoute<T> route) async {
    return _key.currentState?.push<T>(route) as Future<T>;
  }

  String get initialRoute => Routes.todoList;

  void openCreateTodo() {
    navigateTo(Routes.createTodo);
    AppMetrica.reportEvent("open_create_screen");
  }

  void openTodoList() {
    navigateTo(Routes.todoList);
    AppMetrica.reportEvent("open_todo_list_screen");
  }

  toUnknownPage() {
    navigateTo(Routes.unknown);
    AppMetrica.reportEvent("open_error_screen");
  }

  MaterialPageRoute onGenerateRoute(settings) {
    switch (settings.name) {
      case Routes.todoList:
        return MaterialPageRoute(builder: (_) => const TodoListScreen());
      case Routes.createTodo:
        return MaterialPageRoute(builder: (_) => const TodoCreateScreen());
      case Routes.unknown:
      default:
        return MaterialPageRoute(builder: (_) => const UnknownPage());
    }
  }
}
