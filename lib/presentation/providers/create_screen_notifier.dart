import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/domain/models/todo.dart';
import 'package:todo_app/presentation/providers/create_screen_parameters_notifier.dart';

class CreateScreenNotifier extends StateNotifier<bool?> {
  final CreateScreenParametersNotifier parameters;
  final Todo todoForEdit;

  CreateScreenNotifier({
    required this.parameters,
    required this.todoForEdit,
  }) : super(null);

  void setEditingData() {
    parameters.todoForEdit = todoForEdit;
    parameters.isEdit = true;
    if (todoForEdit.deadline != null) {
      parameters.showDate = true;
      parameters.date = todoForEdit.deadline!;
    }
    parameters.importance = todoForEdit.importance;
    final controller = TextEditingController();
    controller.text = todoForEdit.text;
    parameters.text = controller;
  }
}
