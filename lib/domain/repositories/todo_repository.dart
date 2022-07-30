import 'package:todo_app/domain/models/todo.dart';

abstract class TodoRepository {
  Future<List<Todo>> getTodos();
}
