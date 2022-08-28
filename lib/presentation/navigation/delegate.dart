import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/presentation/navigation/models.dart';
import 'package:todo_app/presentation/navigation/state.dart';
import 'package:todo_app/presentation/navigation/transition.dart';
import 'package:todo_app/presentation/screens/todo_create_screen.dart';
import 'package:todo_app/presentation/screens/todo_list_screen.dart';

final routerDelegateProvider = Provider<TodoRouterDelegate>((ref) {
  return TodoRouterDelegate();
});

class TodoRouterDelegate extends RouterDelegate<NavigationStateDTO>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<NavigationStateDTO> {
  NavigationState state = NavigationState(false, null);

  bool get isWelcome => state.isTodos;

  bool get isBooksList => !state.isTodos && state.todoUuid == null;

  bool get isBookDetails => !state.isTodos && state.todoUuid != null;

  void gotoList() {
    state
      ..isTodos = false
      ..todoUuid = null;
    AppMetrica.reportEvent("open_todo_list");
    notifyListeners();
  }

  void gotoTodo(String? id) {
    state
      ..isTodos = true
      ..todoUuid = id;
    AppMetrica.reportEvent("open_create_screen");
    notifyListeners();
  }

  bool _onPopPage(Route route, dynamic result) {
    if (!route.didPop(result)) return false;
    popRoute();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onPopPage: _onPopPage,
      transitionDelegate: TodoTransitionDelegate(),
      key: navigatorKey,
      pages: [
        const MaterialPage(
          child: TodoListScreen(),
        ),
        if (state.isTodos && state.todoUuid == null)
          const MaterialPage(
            child: TodoCreateScreen(
              todoUuid: null,
            ),
          ),
        if (state.isTodos && state.todoUuid != null)
          MaterialPage(
            child: TodoCreateScreen(
              todoUuid: state.todoUuid,
            ),
          ),
      ],
    );
  }

  @override
  NavigationStateDTO? get currentConfiguration {
    return NavigationStateDTO(state.isTodos, state.todoUuid);
  }

  @override
  GlobalKey<NavigatorState>? get navigatorKey => GlobalKey();

  @override
  Future<void> setNewRoutePath(NavigationStateDTO configuration) {
    state.todoUuid = configuration.todoUuid;
    state.isTodos = configuration.isTodos;
    return Future.value();
  }
}
