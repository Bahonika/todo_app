import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/domain/models/todo.dart';
import 'package:todo_app/domain/models/todo_list_state.dart';
import 'package:todo_app/presentation/providers/notifiers/is_dark_notifier.dart';
import 'package:todo_app/domain/models/create_screen_parameters.dart';
import 'package:todo_app/presentation/providers/notifiers/create_screen_parameters_notifier.dart';
import 'package:todo_app/presentation/providers/notifiers/opacity_notifier.dart';
import 'package:todo_app/presentation/providers/notifiers/todo_notifier.dart';
import 'package:todo_app/presentation/providers/services_providers.dart';
import 'package:todo_app/presentation/providers/notifiers/todo_list_state_notifier.dart';


class DataProviders {
  static final todoProvider = StateNotifierProvider.autoDispose<TodoNotifier, Todo?>((ref) {
    final todos = ref.watch(DataProviders.todoListStateProvider).todos;
    return TodoNotifier(todos);
  });

  static final createParametersProvider = StateNotifierProvider.autoDispose
      .family<CreateScreenParametersNotifier, CreateScreenParameters, Todo?>(
          (ref, Todo? todo) {
    final serviceUtil = ref.watch(ServicesProviders.serviceUtilProvider);
    final todo = ref.watch(todoProvider);
    return CreateScreenParametersNotifier(todo, serviceUtil);
  });

  static final todoListStateProvider =
      StateNotifierProvider<TodoListStateNotifier, TodoListState>((ref) {
    final serviceUtil = ref.watch(ServicesProviders.serviceUtilProvider);
    return TodoListStateNotifier(serviceUtil);
  });

  static final opacityProvider =
      StateNotifierProvider<OpacityNotifier, double>((ref) {
    return OpacityNotifier();
  });

  static final isDarkProvider =
      StateNotifierProvider<IsDarkNotifier, bool>((ref) {
    return IsDarkNotifier();
  });
}
