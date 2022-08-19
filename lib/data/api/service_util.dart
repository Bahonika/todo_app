import 'package:logger/logger.dart';
import 'package:todo_app/data/api/services/local.dart';
import 'package:todo_app/data/api/services/remote.dart';
import 'package:todo_app/data/mappers/todo_mapper.dart';
import 'package:todo_app/domain/models/todo.dart';
import 'package:todo_app/presentation/logger/logging.dart';

class ServiceUtil {
  final RemoteService _remoteService;
  final LocalService _localService;

  ServiceUtil(this._remoteService, this._localService);

  final Logger _log = Logging.logger();

  LocalService get localService => _localService;

  List<Todo> getFromLocal() {
    List<Todo> todos = [];
    try {
      todos = _localService.getTodos();
      _log.i("Get from local");
    } catch (e) {
      _log.e("Can't get from local", e);
    }
    return todos;
  }

  Future<List<Todo>> getFromRemote() async {
    List<Todo> todos = [];
    try {
      final result = await _remoteService.getTodos();
      _log.i("Get from remote");
      todos = result.map((item) => TodoMapper.fromApi(item)).toList();
    } catch (e) {
      _log.w("Can't get from remote", e);
    }
    return todos;
  }

  Future<List<Todo>> getTodos() async {
    List<Todo> localTodos = getFromLocal();
    List<Todo> remoteTodos = await getFromRemote();
    return localTodos;
  }

  Future<void> deleteTodo(String uuid) async {
    try {
      await _remoteService.delete(uuid: uuid);
      _log.i("Delete on remote");
    } catch (e) {
      _log.w("Can't delete on remote");
    }
    try {
      _localService.delete(uuid: uuid);
      _log.i("Delete on local");
    } catch (e) {
      _log.e("Can't delete on local");
    }
  }

  Future<void> createTodo(Todo todo) async {
    try {
      _localService.create(todo: todo);
      _log.i("Create on local");
    } catch (e) {
      _log.e("Can't create on local");
    }
    try {
      await _remoteService.create(todo: todo);
      _log.i("Create on remote");
    } catch (e) {
      _log.w("Can't create on remote", e);
    }
  }

  Future<void> updateTodo(Todo todo) async {
    try {
      _localService.update(todo: todo);
      _log.i("Update local");
    } catch (e) {
      _log.e("Can't update local", e);
    }
    try {
      await _remoteService.update(uuid: todo.uuid, todo: todo);
      _log.i("Update remote");
    } catch (e) {
      _log.w("Can't update remote");
    }
  }

  Future<void> setDone(Todo todo) async {
    updateTodo(todo.copyWith(done: true, deadline: todo.deadline));
  }

  Future<void> setUndone(Todo todo) async {
    updateTodo(todo.copyWith(done: false, deadline: todo.deadline));
  }
}
