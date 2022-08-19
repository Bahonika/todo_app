import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/data/api/service_util.dart';
import 'package:todo_app/domain/models/todo.dart';
import 'package:todo_app/presentation/providers/create_screen_parameters_notifier.dart';
import 'package:todo_app/presentation/providers/providers.dart';

import 'package:uuid/uuid.dart';

class ListViewState {
  final bool isLoading;
  final List<Todo> todoList;
  final Object? error;

  ListViewState({required this.isLoading, required this.todoList, this.error});

  static final initial = ListViewState(
    isLoading: true,
    todoList: [],
  );
}

class TodosNotifier extends StateNotifier<ListViewState> {
  final CreateScreenParametersNotifier createScreenParametersNotifier;
  final ServiceUtil serviceUtil;

  TodosNotifier(
    this.serviceUtil,
    this.createScreenParametersNotifier,
  ) : super(ListViewState.initial) {
    _init();
  }

  void _init() async {
    await serviceUtil.localService.init();
    load();
  }

  void setErrorState(Object? error, StackTrace stackTrace) {
    state = ListViewState(
      isLoading: state.isLoading,
      todoList: state.todoList,
      error: error,
    );
  }

  void load() async {
    state = ListViewState(isLoading: true, todoList: state.todoList);
    final data =
        await serviceUtil.getTodos().onError((error, stackTrace) => []);
    state = ListViewState(isLoading: false, todoList: data);
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
    state.todoList.removeWhere((element) => element == todo);
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

final completedTodosProvider = Provider.autoDispose<List<Todo>>((ref) {
  final todos = ref
      .watch(DataProviders.todosController)
      .todoList
      .where((element) => element.done)
      .toList();
  return todos;
});

final uncompletedTodosProvider = Provider.autoDispose<List<Todo>>((ref) {
  final todos = ref
      .watch(DataProviders.todosController)
      .todoList
      .where((element) => !element.done)
      .toList();
  return todos;
});
