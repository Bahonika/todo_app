import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NavigationStateNotifier extends StateNotifier<NavigationState> {
  NavigationStateNotifier() : super(NavigationState.todos());
}

final navigationStateProvider =
    StateNotifierProvider<NavigationStateNotifier, NavigationState>((ref) {
  return NavigationStateNotifier();
});

class NavigationState {
  bool isTodos;
  String? todoUuid;

  NavigationState(this.isTodos, this.todoUuid);

  NavigationState.todos() : isTodos = true;

  NavigationState.todoCreate(String? uuid)
      : isTodos = false,
        todoUuid = uuid;
}


//*********************************************
//*********************************************
//
//  How to easily connect riverpod provider (navigationStackProvider)
//  with Flutter Navigator 2.0 RouterDelegate.
//
//*********************************************
//*********************************************

//*********************************************
// PROVIDERS
//*********************************************

final routerDelegateProvider =
Provider<RRouterDelegate>((ref) => RRouterDelegate(ref, [HomeSegment()]));

final navigationStackProvider =
StateProvider<TypedPath>((_) => [HomeSegment()]);

//*********************************************
// MODEL
// typed-path and typed-path segments
//*********************************************

typedef JsonMap = Map<String, dynamic>;

/// Ancestor for typed segments.
///
/// Instead of ```navigate('home/book;id=3')``` we can use
/// ```navigate([HomeSegment(), BookSegment(id: 3)]);```
abstract class TypedSegment {
  factory TypedSegment.fromJson(JsonMap json) =>
      json['runtimeType'] == 'BookSegment'
          ? BookSegment(id: json['id'])
          : HomeSegment();

  JsonMap toJson() => <String, dynamic>{'runtimeType': runtimeType.toString()};
  @override
  String toString() => jsonEncode(toJson());
}

/// Typed variant of whole url path (which consists of [TypedSegment]s)
typedef TypedPath = List<TypedSegment>;

//**** app specific segments

class HomeSegment with TypedSegment {}

class BookSegment with TypedSegment {
  BookSegment({required this.id});
  final int id;
  @override
  JsonMap toJson() => super.toJson()..['id'] = id;
}

//*********************************************
// App root
//*********************************************

//*********************************************
// RouterDelegate
//*********************************************

class RRouterDelegate extends RouterDelegate<TypedPath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<TypedPath> {
  RRouterDelegate(this.ref, this.homePath) {
    final unListen =
    ref.listen(navigationStackProvider, (_, __) => notifyListeners());
    ref.onDispose(unListen);
  }

  final Ref ref;
  final TypedPath homePath;

  @override
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  TypedPath get currentConfiguration => ref.read(navigationStackProvider);

  @override
  Widget build(BuildContext context) {
    final navigationStack = currentConfiguration;
    if (navigationStack.isEmpty) return const SizedBox();

    Widget screenBuilder(TypedSegment segment) {
      if (segment is HomeSegment) return HomeScreen(segment);
      if (segment is BookSegment) return BookScreen(segment);
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
          final notifier = ref.read(navigationStackProvider.notifier);
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
      ref.read(navigationStackProvider.notifier).state = newPath;
}

