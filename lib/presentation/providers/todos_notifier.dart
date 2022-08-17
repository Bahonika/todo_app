import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/data/api/service_util.dart';
import 'package:todo_app/domain/models/todo.dart';
import 'package:todo_app/presentation/providers/providers.dart';

import 'package:uuid/uuid.dart';

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

  void create(Todo todo) async {
    await serviceUtil.createTodo(todo);
    load();
  }

  Todo alterTodo(WidgetRef ref, Todo todo) {
    final alteredTodo = todo.copyWith(
      deadline: ref.read(DataProviders.showDateProvider)
          ? ref.read(DataProviders.selectedDateProvider)
          : null,
      text: ref.read(DataProviders.textControllerProvider).text,
      changedAt: DateTime.now(),
      importance: ref.read(DataProviders.selectedImportanceProvider),
      lastUpdatedBy: serviceUtil.localService.deviceId.values.first,
    );
    return alteredTodo;
  }

  Todo generateTodo(WidgetRef ref) {
    Uuid uuid = const Uuid();
    final todo = Todo(
      createdAt: DateTime.now(),
      changedAt: DateTime.now(),
      lastUpdatedBy: serviceUtil.localService.deviceId.values.first,
      deadline: ref.read(DataProviders.showDateProvider)
          ? ref.read(DataProviders.selectedDateProvider)
          : null,
      uuid: uuid.v1(),
      done: false,
      text: ref.read(DataProviders.textControllerProvider).text,
      importance: ref.read(DataProviders.selectedImportanceProvider),
    );
    return todo;
  }

  void delete(Todo todo) async {
    state.removeWhere((element) => element == todo);
    await serviceUtil.deleteTodo(todo.uuid);
    load();
  }

  void update(Todo todo) async {
    await serviceUtil.updateTodo(todo);
    load();
  }

  Future<void> setAsDone(Todo todo) async {
    await serviceUtil.setDone(todo);
    load();
  }

  void setAsUndone(Todo todo) async {
    await serviceUtil.setUndone(todo);
    load();
  }
}

final completedTodosProvider = Provider<List<Todo>>((ref) {
  final todos = ref
      .watch(DataProviders.todosController)
      .where((element) => element.done)
      .toList();
  return todos;
});

final uncompletedTodosProvider = Provider<List<Todo>>((ref) {
  final todos = ref
      .watch(DataProviders.todosController)
      .where((element) => !element.done)
      .toList();
  return todos;
});
