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

  void _init() async {
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
  void create(Todo todo) async {
    await serviceUtil.createTodo(todo).onError(setErrorState);
    load();
  }

  void delete(Todo todo) async {
    state.todos.removeWhere((element) => element == todo);
    await serviceUtil.deleteTodo(todo.uuid).onError(setErrorState);
    load();
  }

  void update(Todo todo) async {
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
