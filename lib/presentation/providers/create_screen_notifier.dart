import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/domain/models/todo.dart';
import 'package:todo_app/presentation/providers/bool_notifier.dart';
import 'package:todo_app/presentation/providers/date_notifier.dart';
import 'package:todo_app/presentation/providers/importance_notifier.dart';
import 'package:todo_app/presentation/providers/text_notifier.dart';
import 'package:todo_app/presentation/providers/todo_for_edit_notifier.dart';

class CreateScreenNotifier extends StateNotifier<bool?> {
  final IsEditNotifier isEditNotifier;
  final TodoForEditNotifier todoForEditNotifier;
  final TextControllerNotifier textControllerNotifier;
  final ShowDateNotifier showDateNotifier;
  final SelectedDateNotifier selectedDateNotifier;
  final SelectedImportanceNotifier selectedImportanceNotifier;
  final Todo todoForEdit;

  CreateScreenNotifier({
    required this.isEditNotifier,
    required this.todoForEditNotifier,
    required this.textControllerNotifier,
    required this.showDateNotifier,
    required this.selectedDateNotifier,
    required this.selectedImportanceNotifier,
    required this.todoForEdit,
  }) : super(null);

  void setDefaultData(){

  }

  void setEditingData() {
    selectedImportanceNotifier.setImportance(todoForEdit.importance);
    textControllerNotifier.setText(todoForEdit.text);
    isEditNotifier.setTrue();
    if (todoForEdit.deadline != null) {
      showDateNotifier.setTrue();
      selectedDateNotifier.setDate(todoForEdit.deadline!);
    } else {
      showDateNotifier.setFalse();
    }
  }
}
