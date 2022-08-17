import 'package:flutter/material.dart';
import 'package:todo_app/domain/enums/importance.dart';
import 'package:todo_app/domain/models/todo.dart';

class CreateScreenParameters {
  bool isEdit;
  DateTime date;
  Importance importance;
  bool showDate;
  TextEditingController textEditingController;
  Todo? todoForEdit;

  CreateScreenParameters({
    required this.isEdit,
    required this.date,
    required this.importance,
    required this.showDate,
    required this.textEditingController,
    this.todoForEdit,
  });

  set setIsEdit(bool value) => isEdit = value;

  set setDate(DateTime value) => date = value;

  set setImportance(Importance value) => importance = value;

  set setShowDate(bool value) => showDate = value;

  set text(String value) => textEditingController.text = value;

  set setTodo(Todo? value) {
    todoForEdit = value;
  }

  void toggleShowDate() {
    showDate = !showDate;
  }

  CreateScreenParameters copyWith({
    bool? isEdit,
    DateTime? date,
    Importance? importance,
    bool? showDate,
    TextEditingController? textEditingController,
    Todo? todoForEdit,
  }) {
    return CreateScreenParameters(
      isEdit: isEdit ?? this.isEdit,
      date: date ?? this.date,
      importance: importance ?? this.importance,
      showDate: showDate ?? this.showDate,
      textEditingController:
          textEditingController ?? this.textEditingController,
      todoForEdit: todoForEdit ?? this.todoForEdit,
    );
  }

  static final defaultParameters = CreateScreenParameters(
    isEdit: false,
    date: DateTime.now(),
    importance: Importance.basic,
    showDate: false,
    textEditingController: TextEditingController(),
  );
}
