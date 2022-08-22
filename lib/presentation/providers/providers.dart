import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/domain/models/todo.dart';
import 'package:todo_app/domain/models/todo_list_state.dart';
import 'package:todo_app/presentation/navigation/navigation_controller.dart';
import 'package:todo_app/presentation/providers/is_dark_notifier.dart';
import 'package:todo_app/domain/models/create_screen_parameters.dart';
import 'package:todo_app/presentation/providers/create_screen_parameters_notifier.dart';
import 'package:todo_app/presentation/providers/opacity_notifier.dart';
import 'package:todo_app/presentation/providers/services_providers.dart';
import 'package:todo_app/presentation/providers/todos_notifier.dart';

class DataProviders {
  static final navigationProvider = Provider<NavigationController>((ref) {
    return NavigationController();
  });

  static final todoProvider = StateProvider<Todo?>((ref) {
    return null;
  });

  static final createParametersProvider = StateNotifierProvider.autoDispose.family<
      CreateScreenParametersNotifier, CreateScreenParameters, Todo?>((ref, Todo? todo) {

    return CreateScreenParametersNotifier(todo);
  });

  static final opacityProvider =
      StateNotifierProvider<OpacityNotifier, double>((ref) {
    return OpacityNotifier();
  });

  // static final createScreenProvider = StateNotifierProvider.autoDispose
  //     .family<CreateScreenNotifier, bool?, Todo>((ref, Todo todo) {
  //   return CreateScreenNotifier(
  //     todoForEdit: todo,
  //     parameters: ref.watch(createParametersProvider.notifier),
  //   );
  // });

  static final todosController =
      StateNotifierProvider.autoDispose<TodosNotifier, TodoListState>(
    (ref) {
      final serviceUtil = ref.watch(ServicesProviders.serviceUtilProvider);

      // не придумал, как без этого логику вынести в одну функцию в провайдере
      // надо еще подумать, может вообще нужно куда - то в другое место
      // вынести create и update, как предлагалось уже
      final todo = ref.watch(todoProvider);
      final parameters = ref.read(createParametersProvider(todo).notifier);

      return TodosNotifier(serviceUtil, parameters);
    },
  );

  static final isDarkProvider =
      StateNotifierProvider<IsDarkNotifier, bool>((ref) {
    return IsDarkNotifier();
  });
}
