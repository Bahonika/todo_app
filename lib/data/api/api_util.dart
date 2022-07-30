import 'package:todo_app/data/api/services/remote.dart';
import 'package:todo_app/data/mappers/todo_mapper.dart';
import 'package:todo_app/domain/models/todo.dart';

class ApiUtil {
  final RemoteService remoteService;

  ApiUtil(this.remoteService);

  Future<List<Todo>> getTodos() async {
    final result = await remoteService.getTodos();
    final List<Todo> todos =
        result.map((item) => TodoMapper.fromApi(item)).toList();
    return todos;
  }

  Future<void> deleteTodo(String uuid) async {
    final result = await remoteService.delete(uuid: uuid);
  }

  Future<void> createTodo(Todo todo) async {
    final result = await remoteService.create(todo: todo);
  }
}
