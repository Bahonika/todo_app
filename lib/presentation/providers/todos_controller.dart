import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/data/api/service_util.dart';
import 'package:todo_app/domain/models/todo.dart';
import 'package:todo_app/presentation/providers/bool_providers.dart';
import 'package:todo_app/presentation/providers/date_provider.dart';
import 'package:todo_app/presentation/providers/importance_provider.dart';
import 'package:todo_app/presentation/providers/services_providers.dart';
import 'package:todo_app/presentation/providers/text_provider.dart';
import 'package:uuid/uuid.dart';


final todosController = StateNotifierProvider<TodosNotifier, List<Todo>>(
  (ref) {
    final serviceUtil = ref.watch(serviceUtilProvider);
    return TodosNotifier(serviceUtil);
  },
);

class TodosNotifier extends StateNotifier<List<Todo>> {
  TodosNotifier(this.serviceUtil) : super([]) {
    _init();
  }

  final ServiceUtil serviceUtil;

  void _init() async {
    await serviceUtil.localService.init();
    load();
  }

  void load() async {
    final data = await serviceUtil.getTodos();
    state = data;
  }

  void create(Todo todo) {
    serviceUtil.createTodo(todo);
    load();
  }

  Todo alterTodo(WidgetRef ref, Todo todo) {
    final alteredTodo = todo.copyWith(
      deadline:
          ref.read(showDateProvider) ? ref.read(selectedDateProvider) : null,
      text: ref.read(textControllerProvider).text,
      changedAt: DateTime.now(),
      importance: ref.read(selectedImportanceProvider),
      lastUpdatedBy: "123",
    );

    return alteredTodo;
  }

  Todo generateTodo(WidgetRef ref) {
    Uuid uuid = const Uuid();
    final todo = Todo(
      createdAt: DateTime.now(),
      changedAt: DateTime.now(),
      lastUpdatedBy: "123",
      deadline:
          ref.read(showDateProvider) ? ref.read(selectedDateProvider) : null,
      uuid: uuid.v1(),
      done: false,
      text: ref.read(textControllerProvider).text,
      importance: ref.read(selectedImportanceProvider),
    );
    return todo;
  }

  void delete(Todo todo) {
    serviceUtil.deleteTodo(todo.uuid);
    state.removeWhere((element) => element == todo);
    load();
  }

  void update(Todo todo) {
    serviceUtil.updateTodo(todo).then((value) => load());
  }

  void setAsDone(Todo todo) {
    serviceUtil.setDone(todo).then((value) => load());
  }

  void setAsUndone(Todo todo) {
    serviceUtil.setUndone(todo);
    load();
  }
}

final completedTodosProvider = Provider<List<Todo>>((ref) {
  final todos =
      ref.watch(todosController).where((element) => element.done).toList();
  return todos;
});

final uncompletedTodosProvider = Provider<List<Todo>>((ref) {
  final todos =
      ref.watch(todosController).where((element) => !element.done).toList();
  return todos;
});




