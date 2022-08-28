import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/data/api/service_util.dart';
import 'package:todo_app/domain/models/todo.dart';
import 'package:todo_app/domain/models/todo_list_state.dart';

class TodoListStateNotifier extends StateNotifier<TodoListState> {
  final ServiceUtil serviceUtil;

  TodoListStateNotifier(
    this.serviceUtil,
  ) : super(
          TodoListState(
            showAll: true,
            isLoading: true,
            todos: [],
          ),
        ) {
    _init();
  }

  void _init() {
    load();
  }

  void setErrorState(Object? error, StackTrace stackTrace) {
    String? errorToShow = error.toString().split("\n").first;
    state = TodoListState(
      isLoading: state.isLoading,
      todos: state.todos,
      error: errorToShow,
      showAll: state.showAll,
    );
  }

  Future<void> load() async {
    state = TodoListState(
      isLoading: true,
      todos: state.todos,
      showAll: state.showAll,
    );
    serviceUtil.getTodos().listen((value) {})
      ..onData((data) {
        state = TodoListState(
          isLoading: true,
          todos: data,
          showAll: state.showAll,
        );
      })
      ..onDone(() {
        state = TodoListState(
          isLoading: false,
          todos: state.todos,
          showAll: state.showAll,
        );
      });
  }

  void loadLocal() {
    state = TodoListState(
      isLoading: true,
      todos: state.todos,
      showAll: state.showAll,
    );
    final localTodos = serviceUtil.getFromLocal();
    state = TodoListState(
      isLoading: false,
      todos: localTodos,
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

  List<Todo> get todos {
    return state.showAll
        ? state.todos
        : state.todos.where((element) => !element.done).toList();
  }

  List<Todo> unDone() {
    final data = state.todos.where((element) => !element.done).toList();
    return data;
  }

  int get doneLength {
    return state.todos.length - unDone().length;
  }

  Future<void> create(Todo todo) async {
    await serviceUtil.createTodo(todo).onError(setErrorState);
    loadLocal();
  }

  Future<void> delete(Todo todo) async {
    state.todos.removeWhere((element) => element == todo);
    serviceUtil.deleteTodo(todo.uuid).onError(setErrorState);
    loadLocal();
  }

  Future<void> update(Todo todo) async {
    await serviceUtil.updateTodo(todo).onError(setErrorState);
    loadLocal();
  }

  Future<void> setAsDone(Todo todo) async {
    await serviceUtil.setDone(todo).onError(setErrorState);
    loadLocal();
  }

  Future<void> setAsUndone(Todo todo) async {
    await serviceUtil.setUndone(todo).onError(setErrorState);
    loadLocal();
  }
}
