import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/presentation/navigation/segments.dart';
import 'package:todo_app/presentation/navigation/navigation_providers.dart';
import 'package:todo_app/presentation/screens/todo_create_screen.dart';
import 'package:todo_app/presentation/screens/todo_list_screen.dart';

class RiverpodRouterDelegate extends RouterDelegate<TypedPath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<TypedPath> {
  RiverpodRouterDelegate(this.ref, this.homePath) {
    final unListen = ref.listen(NavigationProviders.navigationStackProvider,
        (_, __) => notifyListeners());
    ref.onDispose(unListen);
  }

  final Ref ref;
  final TypedPath homePath;

  @override
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  TypedPath get currentConfiguration =>
      ref.read(NavigationProviders.navigationStackProvider);

  @override
  Widget build(BuildContext context) {
    final navigationStack = currentConfiguration;
    if (navigationStack.isEmpty) return const SizedBox();

    Widget screenBuilder(TypedSegment segment) {
      if (segment is TodosSegment) return const TodoListScreen();
      if (segment is CreateSegment) return const TodoCreateScreen();
      throw UnimplementedError();
    }

    return Navigator(
        key: navigatorKey,
        pages: navigationStack
            .map((segment) => MaterialPage(
                  key: ValueKey(segment.toString()),
                  child: screenBuilder(segment),
                ))
            .toList(),
        onPopPage: (route, result) {
          if (!route.didPop(result)) return false;
          final notifier =
              ref.read(NavigationProviders.navigationStackProvider.notifier);
          if (notifier.state.length <= 1) return false;
          notifier.state = [
            for (var i = 0; i < notifier.state.length - 1; i++)
              notifier.state[i]
          ];
          return true;
        });
  }

  @override
  Future<void> setNewRoutePath(TypedPath configuration) {
    if (configuration.isEmpty) configuration = homePath;
    navigate(configuration);
    return SynchronousFuture(null);
  }

  void navigate(TypedPath newPath) =>
      ref.read(NavigationProviders.navigationStackProvider.notifier).state =
          newPath;
}
