import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:todo_app/domain/models/todo.dart';

// part 'todo_list_state.freezed.dart';

// @freezed
// class TodoListState with _$TodoListState {
//   const factory TodoListState.todos(List<Todo> todos) = Todos;
//
//   const factory TodoListState.loading(bool isLoading) = Loading;
//
//   const factory TodoListState.error([String? message]) = Error;
// }

class TodoListState {
  final bool showAll;
  final bool isLoading;
  final List<Todo> todos;
  final String? error;

  TodoListState({
    required this.showAll,
    required this.isLoading,
    required this.todos,
    this.error,
  });
}
