import 'package:flutter/material.dart';
import 'package:todo_app/presentation/navigation/navigation_state.dart';
import 'package:todo_app/presentation/navigation/routes.dart';

class RouteInformationParserImpl implements RouteInformationParser<NavigationState> {
  @override
  Future<NavigationState> parseRouteInformation(
      RouteInformation routeInformation) {
    final uri = Uri.parse(routeInformation.location ?? '');
    if (uri.pathSegments.isEmpty) {
      return Future.value(NavigationState.todos());
    }
    switch (uri.pathSegments[0]) {
      case Routes.todoList:
        return Future.value(NavigationState.todos());
      case Routes.createTodo:
        return Future.value(
            NavigationState.todoCreate(uri.pathSegments[1]));
      default:
        return Future.value(NavigationState.todos());
    }
  }

  @override
  RouteInformation? restoreRouteInformation(NavigationState configuration) {
    if (configuration.isTodos) {
      return const RouteInformation(location: Routes.todoList);
    }
    if (configuration.todoUuid == null && !configuration.isTodos) {
      return const RouteInformation(location: "/${Routes.createTodo}");
    }
    return RouteInformation(location: "/${Routes.createTodo}/${configuration.todoUuid}");
  }

}