import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/domain/enums/importance.dart';

class SelectedImportanceNotifier extends StateNotifier<Importance> {
  SelectedImportanceNotifier() : super(Importance.basic);

  void setImportance(Importance importance) {
    state = importance;
  }
}
