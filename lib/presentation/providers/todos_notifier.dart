import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/data/api/service_util.dart';
import 'package:todo_app/domain/models/todo.dart';
import 'package:todo_app/presentation/providers/create_screen_parameters_notifier.dart';
import 'package:todo_app/presentation/providers/providers.dart';

import 'package:uuid/uuid.dart';

class TodosNotifier extends StateNotifier<List<Todo>> {
  final CreateScreenParametersNotifier createScreenParametersNotifier;
  final ServiceUtil serviceUtil;

  TodosNotifier(
    this.serviceUtil,
    this.createScreenParametersNotifier,
  ) : super([]) {
    _init();
  }


  void _init() async {
    await serviceUtil.localService.init();
    load();
  }

  void load() async {
    final data = await serviceUtil.getTodos();
    state = data;
  }

  void create() async {
    final todo = generateTodo();
    await serviceUtil.createTodo(todo);
    load();
  }

  Todo alterTodo() {
    final parametersState = createScreenParametersNotifier.state;

    final alteredTodo = parametersState.todoForEdit!.copyWith(
      deadline: parametersState.showDate
          ? parametersState.date
          : null,
      text: parametersState.textEditingController.text,
      changedAt: DateTime.now(),
      importance: parametersState.importance,
      lastUpdatedBy: serviceUtil.localService.deviceId.values.first,
    );
    return alteredTodo;
  }


  Todo generateTodo() {
    Uuid uuid = const Uuid();
    final parametersState = createScreenParametersNotifier.state;
    final todo = Todo(
      createdAt: DateTime.now(),
      changedAt: DateTime.now(),
      lastUpdatedBy: serviceUtil.localService.deviceId.values.first,
      deadline: parametersState.showDate
          ? parametersState.date
          : null,
      uuid: uuid.v1(),
      done: false,
      text: parametersState.textEditingController.text,
      importance: parametersState.importance,
    );
    return todo;
  }

  void delete(Todo todo) async {
    state.removeWhere((element) => element == todo);
    await serviceUtil.deleteTodo(todo.uuid);
    load();
  }

  void update() async {
    final todo = alterTodo();
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

final completedTodosProvider = Provider.autoDispose<List<Todo>>((ref) {
  final todos = ref
      .watch(DataProviders.todosController)
      .where((element) => element.done)
      .toList();
  return todos;
});

final uncompletedTodosProvider = Provider.autoDispose<List<Todo>>((ref) {
  final todos = ref
      .watch(DataProviders.todosController)
      .where((element) => !element.done)
      .toList();
  return todos;
});
