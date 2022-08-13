import 'package:flutter/material.dart';
import 'package:todo_app/domain/enums/importance.dart';
import 'package:todo_app/domain/models/todo.dart';
import 'package:uuid/uuid.dart';

class CreateTaskDataProvider with ChangeNotifier {
  // Variables
  bool _showDate = false;
  Importance _selectedImportance = Importance.basic;
  DateTime _selectedDate = DateTime.now();
  Uuid uuid = const Uuid();

  // Controllers
  final TextEditingController _controller = TextEditingController();

  // Getters
  bool get showDate => _showDate;

  Importance get selectedImportance => _selectedImportance;

  DateTime get selectedDate => _selectedDate;

  TextEditingController get controller => _controller;

  // Setters
  set showDate(bool value) {
    _showDate = value;
    notifyListeners();
  }

  set selectedImportance(Importance newImportance) {
    _selectedImportance = newImportance;
    notifyListeners();
  }

  set selectedDate(DateTime newDatetime) {
    _selectedDate = newDatetime;
    notifyListeners();
  }

  setControllerText(String text) {
    _controller.text = text;
    notifyListeners();
  }

  Todo modelingTodo({Todo? todo}) {
    Todo? tempTodo;
    if (todo != null) {
      tempTodo = todo.copyWith(
        text: _controller.text,
        importance: _selectedImportance,
        lastUpdatedBy: '123',
        changedAt: DateTime.now(),
        deadline: _showDate ? _selectedDate : null,
      );
    } else {
      tempTodo = Todo(
        done: false,
        text: _controller.text,
        importance: _selectedImportance,
        createdAt: DateTime.now(),
        lastUpdatedBy: '123',
        changedAt: DateTime.now(),
        uuid: uuid.v1(),
        deadline: _showDate ? _selectedDate : null,
      );
    }
    return tempTodo;
  }

  eraseData() {
    selectedImportance = Importance.basic;
    selectedDate = DateTime.now();
    setControllerText("");
    notifyListeners();
  }
}
