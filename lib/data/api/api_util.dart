import 'package:todo_app/data/api/services/local.dart';
import 'package:todo_app/data/api/services/remote.dart';
import 'package:todo_app/data/mappers/todo_mapper.dart';
import 'package:todo_app/domain/models/todo.dart';

class ApiUtil {
  final RemoteService remoteService;
  final LocalService localService;
  ApiUtil(this.remoteService, this.localService);

  Future<List<Todo>> getTodos() async {
    var result;
    result = localService.getTodos();
    try{
      result = await remoteService.getTodos();
    } catch (e) {
      print(e);
    }

    final List<Todo> todos =
        result.map((item) => TodoMapper.fromApi(item)).toList();
    return todos;
  }

  Future<void> deleteTodo(String uuid) async {
    final result = await remoteService.delete(uuid: uuid);
  }

  Future<void> createTodo(Todo todo) async {
    localService.create(todo: todo);
    final result = await remoteService.create(todo: todo);
  }

  Future<void> updateTodo(Todo todo) async {
    final result = await remoteService.update(uuid: todo.uuid, todo: todo);
  }

  void setDone(Todo todo) async {
    updateTodo(todo.copyWith(done: true));
  }
}
