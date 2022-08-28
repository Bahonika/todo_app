import 'package:flutter/widgets.dart';
import 'package:todo_app/presentation/navigation/paths.dart';

import 'models.dart';

class BooksShelfRouteInformationParser
    extends RouteInformationParser<NavigationStateDTO> {
  @override
  Future<NavigationStateDTO> parseRouteInformation(
      RouteInformation routeInformation) {
    final uri = Uri.parse(routeInformation.location ?? '');
    if (uri.pathSegments.isEmpty) {
      return Future.value(NavigationStateDTO.todos());
    }
    switch (uri.pathSegments[0]) {
      case Paths.create:
        return Future.value(NavigationStateDTO.create());
      case Paths.todo:
        return Future.value(NavigationStateDTO.todo(uri.pathSegments[1]));
      default:
        return Future.value(NavigationStateDTO.todos());
    }
  }

  @override
  RouteInformation? restoreRouteInformation(NavigationStateDTO configuration) {
    if (configuration.isTodos) {
      return const RouteInformation(location: "/${Paths.todos}");
    }
    if (configuration.todoUuid == null) {
      return const RouteInformation(location: "/${Paths.create}");
    }
    return RouteInformation(
        location: "/${Paths.todo}/${configuration.todoUuid}");
  }
}
