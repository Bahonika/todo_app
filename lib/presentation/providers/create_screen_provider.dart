import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/domain/models/todo.dart';
import 'date_provider.dart';
import 'text_provider.dart';
import 'todo_for_edit_provider.dart';
import 'bool_providers.dart';
import 'importance_provider.dart';

final createScreenProvider = StateNotifierProvider<CreateScreenNotifier, bool?>((ref) {
  return CreateScreenNotifier();
});


class CreateScreenNotifier extends StateNotifier<bool> {
  CreateScreenNotifier() : super(true);

  void setDefaults(WidgetRef ref){
    ref.read(todoForEditProvider.notifier).setDefault();
    ref.read(textControllerProvider.notifier).setDefault();
    ref.read(selectedImportanceProvider.notifier).setDefault();
    ref.read(selectedDateProvider.notifier).setDefault();
    ref.read(showDateProvider.notifier).setDefault();
    ref.read(isEditProvider.notifier).set(false);
  }

  void setEditingData(WidgetRef ref, Todo todo){
    ref.read(isEditProvider.notifier).set(true);
    ref.read(todoForEditProvider.notifier).setTodo(todo);
    ref.read(textControllerProvider.notifier).setText(todo.text);
    if (todo.deadline != null) {
      ref.read(showDateProvider.notifier).set(true);
      ref.read(selectedDateProvider.notifier).setDate(todo.deadline!);
    } else {
      ref.read(showDateProvider.notifier).set(false);
    }
    ref.read(selectedImportanceProvider.notifier).setImportance(todo.importance);
  }
}
