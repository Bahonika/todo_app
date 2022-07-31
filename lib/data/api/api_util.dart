import 'package:todo_app/data/api/services/local.dart';
import 'package:todo_app/data/api/services/remote.dart';
import 'package:todo_app/domain/models/todo.dart';

class ApiUtil {
  final RemoteService remoteService;
  final LocalService localService;

  ApiUtil(this.remoteService, this.localService);

  Future<List<Todo>> getTodos() async {
    var result;
    result = localService.todos.values.toList();
    try {
      result = await remoteService.getTodos();
    } catch (e) {}
    return result;
  }

  Future<void> deleteTodo(String uuid) async {
    var result;

    localService.delete(uuid: uuid);
    try {
      result = await remoteService.delete(uuid: uuid);
    } catch (e) {
      print(e);
    }
  }

  Future<void> createTodo(Todo todo) async {
    localService.create(todo: todo);
    try {
      final result = await remoteService.create(todo: todo);
    } catch (e) {}
  }

  Future<void> updateTodo(Todo todo) async {
    localService.update(todo: todo);
    try {
      final result = await remoteService.update(uuid: todo.uuid, todo: todo);
    } catch (e){}
  }

  void setDone(Todo todo) async {
    updateTodo(todo.copyWith(done: true));
  }

  void setUndone(Todo todo) async {
    updateTodo(todo.copyWith(done: false));
  }
}
