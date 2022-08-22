import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/domain/enums/importance.dart';
import 'package:todo_app/domain/models/todo.dart';
import 'package:todo_app/domain/models/create_screen_parameters.dart';

class CreateScreenParametersNotifier
    extends StateNotifier<CreateScreenParameters> {
  final Todo? todo;

  CreateScreenParametersNotifier(this.todo)
      : super(CreateScreenParameters.defaultParameters) {
    setAllData();
  }

  void setAllData() {
    if (todo != null) {
      state = state.copyWith(
        importance: todo!.importance,
        isEdit: true,
        date: todo!.deadline,
        showDate: todo!.deadline != null,
        textEditingController: TextEditingController(text: todo!.text),
        todoForEdit: todo,
      );
    } else {
      print("todo is null");
      state = CreateScreenParameters.defaultParameters;
      print(state.importance);
    }
  }

  set importance(Importance value) => state = state.copyWith(importance: value);

  set date(DateTime value) => state = state.copyWith(date: value);

  set isEdit(bool value) => state = state.copyWith(isEdit: value);

  set showDate(bool value) => state = state.copyWith(showDate: value);

  set text(TextEditingController value) =>
      state = state.copyWith(textEditingController: value);

  set todoForEdit(Todo value) => state = state.copyWith(todoForEdit: value);

  void toggleShowDate() => state = state.copyWith(showDate: !state.showDate);
}
