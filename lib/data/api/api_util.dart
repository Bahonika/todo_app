import 'package:logger/logger.dart';
import 'package:todo_app/data/api/services/local.dart';
import 'package:todo_app/data/api/services/remote.dart';
import 'package:todo_app/data/mappers/todo_mapper.dart';
import 'package:todo_app/domain/models/todo.dart';
import 'package:todo_app/presentation/logger/logging.dart';

class ApiUtil {
  final RemoteService remoteService;
  final LocalService localService;

  ApiUtil(this.remoteService, this.localService);

  Logger log = Logging.logger();

  List<Todo> getFromLocal() {
    List<Todo> todos = [];
    try {
      todos = localService.todos.values.toList();
      log.i("Get from local");
    } catch (e) {
      log.e("Can't get from local");
    }

    return todos;
  }

  Future<List<Todo>> getFromRemote() async {
    List<Todo> todos = [];
    try {
      final result = await remoteService.getTodos();
      log.i("Get from remote");
      todos = result.map((item) => TodoMapper.fromApi(item)).toList();
    } catch (e) {
      log.w("Can't get from remote");
    }
    return todos;
  }

  Future<List<Todo>> getTodos() async {
    List<Todo> localTodos = getFromLocal();

    // temporary ignore unused
    // will be used when offline first
    // ignore: unused_local_variable
    List<Todo> remoteTodos = await getFromRemote();
    return localTodos;
  }

  Future<void> deleteTodo(String uuid) async {
    try {
      localService.delete(uuid: uuid);
      log.i("Delete on local");
    } catch (e) {
      log.e("Can't delete on local");
    }
    try {
      await remoteService.delete(uuid: uuid);
      log.i("Delete on remote");
    } catch (e) {
      log.w("Can't delete on remote");
    }
  }

  Future<void> createTodo(Todo todo) async {
    try {
      localService.create(todo: todo);
      log.i("Create on local");
    } catch (e) {
      log.e("Can't create on local");
    }
    try {
      await remoteService.create(todo: todo);
      log.i("Create on remote");
    } catch (e) {
      log.w("Can't create on remote", e);
    }
  }

  Future<void> updateTodo(Todo todo) async {
    try {
      localService.update(todo: todo);
      log.i("Update local");
    } catch (e) {
      log.e("Can't update local", e);
    }
    try {
      await remoteService.update(uuid: todo.uuid, todo: todo);
      log.i("Update remote");
    } catch (e) {
      log.w("Can't update remote");
    }
  }

  void setDone(Todo todo) async {
    updateTodo(todo.copyWith(done: true));
  }

  void setUndone(Todo todo) async {
    updateTodo(todo.copyWith(done: false));
  }
}
