import 'dart:async';

import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:logger/logger.dart';
import 'package:todo_app/data/api/services/local.dart';
import 'package:todo_app/data/api/services/remote.dart';
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
      rethrow;
    }
    return todos;
  }

  Future<List<Todo>> getFromRemote() async {
    List<Todo> todos = [];
    try {
      todos = await _remoteService.getTodos();
      _log.i("Get from remote");
    } catch (e) {
      _log.w("Can't get from remote", e);
      rethrow;
    }
    return todos;
  }

  Stream<List<Todo>> getTodos() async* {
    final localTodos = getFromLocal();
    yield localTodos;
    final localRevision = _localService.getRevision();

    final remoteTodos = await getFromRemote();
    final remoteRevision = _remoteService.getRevision();
    final mergedTodos = await mergeRevision(
      localRevision: localRevision,
      localTodos: localTodos,
      remoteRevision: remoteRevision,
      remoteTodos: remoteTodos,
    );

    yield mergedTodos;
  }

  Future<List<Todo>> mergeRevision({
    required int localRevision,
    required List<Todo> localTodos,
    required int remoteRevision,
    required List<Todo> remoteTodos,
  }) async {
    _log.v("localRevision is $localRevision\n"
        "remoteRevision is $remoteRevision");

    var todos = <Todo>[];
    if (localRevision > remoteRevision) {
      todos = await _remoteService.patch(todos: localTodos);
      _localService.setRevision(remoteRevision);
      _log.i("Reset local data as foundation");
    } else if (localRevision < remoteRevision) {
      todos = _localService.patch(todos: remoteTodos);
      _localService.setRevision(remoteRevision);
      _log.i("Reset remote data as foundation");
    } else {
      todos = localTodos;
      _log.i("The revisions are the same");
    }
    return todos;
  }

  Future<void> deleteTodo(String uuid) async {
    try {
      await _remoteService.delete(uuid: uuid);
      _log.i("Delete on remote");
    } catch (e) {
      _log.w("Can't delete on remote");
      rethrow;
    }
    try {
      _localService.delete(uuid: uuid);
      _log.i("Delete on local");
    } catch (e) {
      _log.e("Can't delete on local");
      rethrow;
    }
    AppMetrica.reportEvent("delete_todo");
  }

  Future<void> createTodo(Todo todo) async {
    try {
      _localService.create(todo: todo);
      _log.i("Create on local");
    } catch (e) {
      _log.e("Can't create on local");
      rethrow;
    }
    try {
      await _remoteService.create(todo: todo);
      _log.i("Create on remote");
    } catch (e) {
      _log.w("Can't create on remote", e);
      rethrow;
    }
    AppMetrica.reportEvent("create_todo");
  }

  Future<void> updateTodo(Todo todo) async {
    try {
      _localService.update(todo: todo);
      _log.i("Update local");
    } catch (e) {
      _log.e("Can't update local", e);
      rethrow;
    }
    try {
      await _remoteService.update(uuid: todo.uuid, todo: todo);
      _log.i("Update remote");
    } catch (e) {
      _log.e("Can't update remote");
      rethrow;
    }
  }

  Future<void> setDone(Todo todo) async {
    updateTodo(todo.copyWith(done: true, deadline: todo.deadline));
    AppMetrica.reportEvent("set_done");
  }

  Future<void> setUndone(Todo todo) async {
    updateTodo(todo.copyWith(done: false, deadline: todo.deadline));
  }
}
