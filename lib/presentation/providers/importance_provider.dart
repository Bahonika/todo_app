import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/domain/enums/importance.dart';

final selectedImportanceProvider =
StateNotifierProvider<SelectedImportanceNotifier, Importance>((ref) {
  return SelectedImportanceNotifier();
});

class SelectedImportanceNotifier extends StateNotifier<Importance> {
  SelectedImportanceNotifier() : super(Importance.basic);

  void setImportance(Importance importance) {
    state = importance;
  }

  void setDefault() {
    setImportance(Importance.basic);
  }
}