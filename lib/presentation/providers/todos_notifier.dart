import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/data/api/service_util.dart';
import 'package:todo_app/domain/models/todo.dart';
import 'package:todo_app/domain/models/todo_list_state.dart';
import 'package:todo_app/presentation/providers/create_screen_parameters_notifier.dart';

import 'package:uuid/uuid.dart';

class TodosNotifier extends StateNotifier<TodoListState> {
  final CreateScreenParametersNotifier createScreenParametersNotifier;
  final ServiceUtil serviceUtil;

  TodosNotifier(
    this.serviceUtil,
    this.createScreenParametersNotifier,
  ) : super(
          TodoListState(
            showAll: true,
            isLoading: true,
            todos: [],
          ),
        ) {
    _init();
  }

  void _init() async {
    await serviceUtil.localService.init();
    load();
  }

  void setErrorState(Object? error, StackTrace stackTrace) {
    state = TodoListState(
      isLoading: state.isLoading,
      todos: state.todos,
      error: error.toString(),
      showAll: state.showAll,
    );
  }

  void load() async {
    state = TodoListState(
      isLoading: true,
      todos: state.todos,
      showAll: state.showAll,
    );
    final data =
        await serviceUtil.getTodos().onError((error, stackTrace) => []);
    state = TodoListState(
      isLoading: false,
      todos: data,
      showAll: state.showAll,
    );
  }

  void toggleFilter() {
    state = TodoListState(
      showAll: !state.showAll,
      isLoading: state.isLoading,
      todos: state.todos,
    );
  }

  List<Todo> get unDone {
    final data = state.todos.where((element) => !element.done).toList();
    return data;
  }

  int get doneLength {
    return state.todos.length - unDone.length;
  }

  // я хотел вынести логику создания из этого класса,
  // но тогда функцию load тоже нужно будет вынести
  void create() async {
    final todo = generateTodo();
    await serviceUtil.createTodo(todo).onError(setErrorState);
    load();
  }

  Todo alterTodo() {
    final parametersState = createScreenParametersNotifier.state;

    final alteredTodo = parametersState.todoForEdit!.copyWith(
      deadline: parametersState.showDate ? parametersState.date : null,
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
      deadline: parametersState.showDate ? parametersState.date : null,
      uuid: uuid.v1(),
      done: false,
      text: parametersState.textEditingController.text,
      importance: parametersState.importance,
    );
    return todo;
  }

  void delete(Todo todo) async {
    state.todos.removeWhere((element) => element == todo);
    await serviceUtil.deleteTodo(todo.uuid).onError(setErrorState);
    load();
  }

  void update() async {
    final todo = alterTodo();
    await serviceUtil.updateTodo(todo).onError(setErrorState);
    load();
  }

  Future<void> setAsDone(Todo todo) async {
    await serviceUtil.setDone(todo).onError(setErrorState);
    load();
  }

  void setAsUndone(Todo todo) async {
    await serviceUtil.setUndone(todo).onError(setErrorState);
    load();
  }
}
