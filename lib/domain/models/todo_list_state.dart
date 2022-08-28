import 'package:todo_app/domain/models/todo.dart';

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
