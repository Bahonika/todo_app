import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/presentation/navigation/segments.dart';
import 'package:todo_app/presentation/navigation/todo_router_delegate.dart';

class NavigationProviders {
  static final routerDelegateProvider = Provider<RiverpodRouterDelegate>(
      (ref) => RiverpodRouterDelegate(ref, [TodosSegment()]));

  static final navigationStackProvider =
      StateProvider<TypedPath>((_) => [TodosSegment()]);
}
