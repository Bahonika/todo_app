
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/presentation/navigation/simple_navigation/state.dart';
import 'package:todo_app/presentation/navigation/simple_navigation/transition.dart';
import 'package:todo_app/presentation/screens/todo_create_screen.dart';
import 'package:todo_app/presentation/screens/todo_list_screen.dart';

import 'models.dart';

final routerDelegateProvider = Provider<BookshelfRouterDelegate>((ref) {
  return BookshelfRouterDelegate();
});

class BookshelfRouterDelegate extends RouterDelegate<NavigationStateDTO>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<NavigationStateDTO> {
  NavigationState state = NavigationState(true, null);

  bool get isWelcome => state.isTodos;

  bool get isBooksList => !state.isTodos && state.todoUuid == null;

  bool get isBookDetails => !state.isTodos && state.todoUuid != null;

  void gotoList() {
    print("hey");
    state
      ..isTodos = true
      ..todoUuid = null;
    notifyListeners();
  }

  void gotoTodo(String? id) {
    state
      ..isTodos = false
      ..todoUuid = id;
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
      transitionDelegate: BookshelfTransitionDelegate(),
      key: navigatorKey,
      pages: [
        if (state.isTodos)
          const MaterialPage(
            child: TodoListScreen(),
          ),
        if (!state.isTodos && state.todoUuid == null)
          const MaterialPage(
            child: TodoCreateScreen(),
          ),
        if (state.todoUuid != null)
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
