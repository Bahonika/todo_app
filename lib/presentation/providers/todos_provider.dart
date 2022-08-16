import 'dart:async';

import 'package:flutter/material.dart';
import 'package:todo_app/data/api/service_util.dart';

import 'package:todo_app/domain/models/todo.dart';
import 'package:todo_app/internal/dependencies/api_module.dart';

class TodosProvider with ChangeNotifier {
  List<Todo> _todos = [];
  bool _showCompleted = true;
  final ServiceUtil apiUtil = ApiModule.apiUtil();

  final _streamController = StreamController<List<Todo>>.broadcast();

  bool get showCompleted => _showCompleted;

  Stream<List<Todo>> get todoListStream async* {
    yield await getTodos();
    yield* _streamController.stream;
  }

  Future<void> _updateTodoStream() async {
    if (_streamController.hasListener) {
      _streamController.add(await getTodos());
    }
  }

  set showCompleted(bool value) {
    _showCompleted = value;
    notifyListeners();
  }

  Future<List<Todo>> getTodos() async {
    _todos = await apiUtil.getTodos();
    return _todos;
  }

  List<Todo> getLocalTodos() {
    _todos = apiUtil.getFromLocal();
    return _todos;
  }

  Future<void> createTodo({required Todo todo}) async {
    await apiUtil.createTodo(todo);
    _updateTodoStream();
  }

  Future<void> deleteTodo(String uuid) async {
    _todos.removeWhere((element) =>
        element.uuid == uuid); //dismissible manually delete required
    apiUtil.deleteTodo(uuid);
    _updateTodoStream();
  }

  //put same entity with done = true
  void setAsDone(Todo todo) {
    apiUtil.setDone(todo);
    _updateTodoStream();
  }

  void setAsUndone(Todo todo) {
    apiUtil.setUndone(todo);
    _updateTodoStream();
  }

  void updateTodo(Todo todo) {
    apiUtil.updateTodo(todo);
    _updateTodoStream();
  }
}
