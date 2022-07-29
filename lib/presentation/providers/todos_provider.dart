import 'package:flutter/material.dart';
import 'package:todo_app/data/api/api_util.dart';
import 'package:todo_app/data/api/services/local.dart';
import 'package:todo_app/data/api/services/remote.dart';
import 'package:todo_app/domain/models/todo.dart';
import 'package:uuid/uuid.dart';

import '../../domain/enums/importance.dart';

class TodosProvider with ChangeNotifier {
  List<Todo> _todos = [];
  static RemoteService remoteService = RemoteService();
  static LocalService localService = LocalService(); //isn't in use yet

  List<Todo> get todos => _todos;

  List<Todo> get completedTodos =>
      _todos.where((element) => element.done).toList();

  Uuid uuid = const Uuid();
  ApiUtil apiUtil = ApiUtil(remoteService);

  Future<void> getTodos() async {
    _todos = await apiUtil.getTodos();
    notifyListeners();
  }

  void createTodo({
    required String text,
    required Importance importance,
    DateTime? deadline,
  }) async {
    Todo tempTodo = Todo(
      uuid: uuid.v1(),
      done: false,
      text: text,
      importance: importance,
      deadline: deadline,
    );
    _todos.add(tempTodo);
    await apiUtil.createTodo(tempTodo);
    getTodos();
    notifyListeners();
  }

  void deleteTodo(String uuid) {
    _todos.removeWhere((element) =>
        element.uuid == uuid); // if remove will throw dismissible bug
    apiUtil.deleteTodo(uuid);
    notifyListeners();
  }

  //put same entity with done = true
  setAsDone(String uuid) {
    Todo todo = _todos.firstWhere((element) => element.uuid == uuid);
    //todo: put this, maybe by updateTodo function
  }

  void updateTodo(String uuid) {}
}
