import 'package:flutter/material.dart';
import 'package:todo_app/data/api/api_util.dart';

// import 'package:todo_app/data/api/services/local.dart';
// import 'package:todo_app/data/api/services/remote.dart';
import 'package:todo_app/domain/models/todo.dart';
import 'package:todo_app/internal/dependencies/api_module.dart';
import 'package:uuid/uuid.dart';

import '../../domain/enums/importance.dart';

class TodosProvider with ChangeNotifier {
  List<Todo> _todos = [];

  List<Todo> get todos => _todos;

  List<Todo> get completedTodos =>
      _todos.where((element) => element.done).toList();

  Uuid uuid = const Uuid();
  ApiUtil apiUtil = ApiModule.apiUtil();

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
      lastUpdatedBy: '123',
      changedAt: DateTime.now(),
      createdAt: DateTime.now(),
    );
    await apiUtil.createTodo(tempTodo);
    getTodos();
    notifyListeners();
  }

  void deleteTodo(String uuid) {
    _todos.removeWhere((element) => element.uuid == uuid);
    apiUtil.deleteTodo(uuid);
    notifyListeners();
  }

  //put same entity with done = true
  setAsDone(Todo todo) {
    apiUtil.setDone(todo);
  }

  void updateTodo(Todo todo) {
    apiUtil.updateTodo(todo);
  }
}
