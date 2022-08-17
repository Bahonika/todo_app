import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/domain/models/todo.dart';
import 'package:todo_app/presentation/providers/create_screen_parameters_notifier.dart';

class CreateScreenNotifier extends StateNotifier<bool?> {
  final CreateScreenParametersNotifier createScreenParametersNotifier;
  final Todo todoForEdit;

  CreateScreenNotifier({
    required this.createScreenParametersNotifier,
    required this.todoForEdit,
  }) : super(null);

  void setEditingData() {
    createScreenParametersNotifier.todoForEdit = todoForEdit;
    createScreenParametersNotifier.isEdit = true;
    if (todoForEdit.deadline != null) {
      createScreenParametersNotifier.showDate = true;
      createScreenParametersNotifier.date = todoForEdit.deadline!;
    }
    createScreenParametersNotifier.importance = todoForEdit.importance;
    final controller = TextEditingController();
    controller.text = todoForEdit.text;
    createScreenParametersNotifier.text = controller;
  }
}
