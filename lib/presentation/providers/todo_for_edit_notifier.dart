import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/domain/models/todo.dart';

class TodoForEditNotifier extends StateNotifier<Todo?> {
  TodoForEditNotifier() : super(null);

  setTodo(Todo todo) {
    state = todo;
  }
}
