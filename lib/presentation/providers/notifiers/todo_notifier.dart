import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/domain/models/todo.dart';

class TodoNotifier extends StateNotifier<Todo?> {
  TodoNotifier(this.todos) : super(null);
  final List<Todo> todos;

  void setTodo(String? uuid){
    state = todos.firstWhere((todo) => todo.uuid == uuid);
  }
}
