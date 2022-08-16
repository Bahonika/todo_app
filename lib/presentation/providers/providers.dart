import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/domain/enums/importance.dart';
import 'package:todo_app/domain/models/todo.dart';
import 'package:todo_app/presentation/providers/bool_notifier.dart';
import 'package:todo_app/presentation/providers/create_screen_notifier.dart';
import 'package:todo_app/presentation/providers/date_notifier.dart';
import 'package:todo_app/presentation/providers/importance_notifier.dart';
import 'package:todo_app/presentation/providers/services_providers.dart';
import 'package:todo_app/presentation/providers/text_notifier.dart';
import 'package:todo_app/presentation/providers/todo_for_edit_notifier.dart';
import 'package:todo_app/presentation/providers/todos_notifier.dart';

class DataProviders {
  static final createScreenProvider =
      StateNotifierProvider.family<CreateScreenNotifier, bool?, Todo>(
          (ref, Todo todo) {
            // думаю есть вариант сделать это менее громоздким
            // например создать модель параметров для экрана создания
            // и внутри одного провайдера контролировать все значения
    return CreateScreenNotifier(
      isEditNotifier: ref.watch(isEditProvider.notifier),
      selectedDateNotifier: ref.watch(selectedDateProvider.notifier),
      selectedImportanceNotifier:
          ref.watch(selectedImportanceProvider.notifier),
      showDateNotifier: ref.watch(showDateProvider.notifier),
      textControllerNotifier: ref.watch(textControllerProvider.notifier),
      todoForEditNotifier: ref.watch(todoForEditProvider.notifier),
      todoForEdit: ref.watch(todoForEditProvider)!,
    );
  });

  static final isEditProvider =
      StateNotifierProvider<IsEditNotifier, bool>((ref) {
    return IsEditNotifier();
  });

  static final showAllTodosProvider =
      StateNotifierProvider<ShowAllTodosNotifier, bool>((ref) {
    return ShowAllTodosNotifier();
  });

  static final showDateProvider =
      StateNotifierProvider<ShowDateNotifier, bool>((ref) {
    return ShowDateNotifier();
  });

  static final selectedDateProvider =
      StateNotifierProvider<SelectedDateNotifier, DateTime>((ref) {
    return SelectedDateNotifier();
  });

  static final selectedImportanceProvider =
      StateNotifierProvider<SelectedImportanceNotifier, Importance>((ref) {
    return SelectedImportanceNotifier();
  });

  static final textControllerProvider =
      StateNotifierProvider<TextControllerNotifier, TextEditingController>(
          (ref) {
    return TextControllerNotifier();
  });

  static final todoForEditProvider =
      StateNotifierProvider<TodoForEditNotifier, Todo?>((ref) {
    return TodoForEditNotifier();
  });

  static final todosController =
      StateNotifierProvider<TodosNotifier, List<Todo>>(
    (ref) {
      final serviceUtil = ref.watch(ServicesProviders.serviceUtilProvider);
      return TodosNotifier(serviceUtil);
    },
  );
}
