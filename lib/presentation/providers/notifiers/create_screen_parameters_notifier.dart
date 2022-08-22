import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/data/api/service_util.dart';
import 'package:todo_app/domain/enums/importance.dart';
import 'package:todo_app/domain/models/todo.dart';
import 'package:todo_app/domain/models/create_screen_parameters.dart';
import 'package:uuid/uuid.dart';

class CreateScreenParametersNotifier
    extends StateNotifier<CreateScreenParameters> {
  final Todo? todo;
  final ServiceUtil serviceUtil;

  CreateScreenParametersNotifier(this.todo, this.serviceUtil)
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
      );
    } else {
      state = CreateScreenParameters.defaultParameters;
    }
  }

  Todo generateTodo() {
    const uuid = Uuid();
    final todo = Todo(
      uuid: uuid.v1(),
      done: false,
      text: state.textEditingController.text,
      importance: state.importance,
      createdAt: DateTime.now(),
      changedAt: DateTime.now(),
      lastUpdatedBy: serviceUtil.localService.deviceId.values.first,
      deadline: state.showDate ? state.date : null,
    );
    return todo;
  }

  Todo alterTodo() {
    final alteredTodo = todo!.copyWith(
      deadline: state.showDate ? state.date : null,
      text: state.textEditingController.text,
      changedAt: DateTime.now(),
      importance: state.importance,
      lastUpdatedBy: serviceUtil.localService.deviceId.values.first,
    );
    return alteredTodo;
  }

  bool get isCorrect => state.textEditingController.text != "";

  set importance(Importance value) => state = state.copyWith(importance: value);

  set date(DateTime value) => state = state.copyWith(date: value);

  set showDate(bool value) => state = state.copyWith(showDate: value);

  set text(String value) => state =
      state.copyWith(textEditingController: TextEditingController(text: value));

  void toggleShowDate() => state = state.copyWith(showDate: !state.showDate);
}
