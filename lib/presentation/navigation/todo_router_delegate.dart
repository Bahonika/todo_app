import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/presentation/navigation/navigation_state.dart';

class TodoRouterDelegate extends RouterDelegate<NavigationState>{
  final Ref ref;

  @override
  void addListener(VoidCallback listener) {
    // TODO: implement addListener
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onPopPage: (route, result) => route.didPop(result),
      transitionDelegate: BookshelfTransitionDelegate(),
      key: navigatorKey,
      pages: [
        if (state.isWelcome)
          const MaterialPage(
            child: WelcomeScreen(),
          ),
        if (!state.isWelcome)
          const MaterialPage(
            child: BooksScreen(),
          ),
        if (state.bookId != null)
          MaterialPage(
            child: DetailsScreen(
              BookId(state.bookId!),
            ),
          ),
      ],
    );  }

  @override
  Future<bool> popRoute() {
    // TODO: implement popRoute
    throw UnimplementedError();
  }

  @override
  void removeListener(VoidCallback listener) {
    // TODO: implement removeListener
  }

  @override
  Future<void> setNewRoutePath(NavigationState configuration) {
    // TODO: implement setNewRoutePath
    throw UnimplementedError();
  }

}