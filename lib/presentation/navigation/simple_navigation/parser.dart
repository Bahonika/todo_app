import 'package:flutter/widgets.dart';
import 'package:todo_app/presentation/navigation/simple_navigation/models.dart';
import 'package:todo_app/presentation/navigation/simple_navigation/paths.dart';


//Transform state <-> URL
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
      case Paths.books:
        return Future.value(NavigationStateDTO.create());
      case Paths.book:
        return Future.value(
            NavigationStateDTO.todo(uri.pathSegments[1]));
      default:
        return Future.value(NavigationStateDTO.todos());
    }
  }

  @override
  RouteInformation? restoreRouteInformation(NavigationStateDTO configuration) {
    if (configuration.isTodos) {
      return const RouteInformation(location: Paths.welcome);
    }
    if (configuration.todoUuid == null) {
      return const RouteInformation(location: "/${Paths.books}");
    }
    return RouteInformation(location: "/${Paths.book}/${configuration.todoUuid}");
  }
}