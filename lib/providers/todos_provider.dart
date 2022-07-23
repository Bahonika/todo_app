import 'package:flutter/material.dart';
import 'package:todo_app/data/entities/todo.dart';
import 'package:uuid/uuid.dart';

class TodosProvider with ChangeNotifier {
  List<Todo> _todos = [];

  List<Todo> get todos => _todos;

  Uuid uuid = const Uuid();

  void getTodos() {
    notifyListeners();
  }

  void createTodo({
    required String text,
    required Importance importance,
    DateTime? deadline,
  }) {
    todos.add(
      Todo(
        uuid: uuid.v1(),
        done: false,
        text: text,
        importance: importance,
        deadline: deadline,
      ),
    );
    notifyListeners();
  }

  void deleteTodo(String uuid) {
    _todos.removeWhere((element) => element.uuid == uuid);
    notifyListeners();
  }

  setAsDone(String uuid){
    _todos.firstWhere((element) => element.uuid == uuid);
  }

  void updateTodo(String uuid) {}
}
