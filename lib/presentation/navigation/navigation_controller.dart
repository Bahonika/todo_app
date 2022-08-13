import 'package:flutter/material.dart';
import 'package:todo_app/domain/models/todo.dart';
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

  void openCreateTodo({Todo? todoForEdit, bool isEdit = false}) {
    navigateTo(Routes.createTodo, arguments: {
      'isEdit': isEdit,
      "todoForEdit": todoForEdit,
    });
  }

  void openTodoList() {
    navigateTo(Routes.todoList);
  }

  toUnknownPage() {
    navigateTo(Routes.unknown);
  }

  onGenerateRoute(settings) {
    switch (settings.name) {
      case Routes.todoList:
        return MaterialPageRoute(builder: (_) => const TodoListScreen());
      case Routes.createTodo:
        return MaterialPageRoute(
            builder: (_) => TodoCreateScreen(
                  isEdit: settings.arguments["isEdit"],
                  todoForEdit: settings.arguments["todoForEdit"],
                ));
      case Routes.unknown:
        MaterialPageRoute(builder: (context) => const UnknownPage());
    }
  }
}
