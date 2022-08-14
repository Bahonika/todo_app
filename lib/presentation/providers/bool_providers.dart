import 'package:flutter_riverpod/flutter_riverpod.dart';

final showDateProvider = StateNotifierProvider<ShowDateNotifier, bool>((ref) {
  return ShowDateNotifier();
});

class ShowDateNotifier extends StateNotifier<bool> {
  ShowDateNotifier() : super(false);

  void set(bool value) {
    state = value;
  }

  void setDefault() {
    set(false);
  }

  void toggle() {
    state = !state;
  }
}

final showAllTodosProvider =
    StateNotifierProvider<ShowAllTodosNotifier, bool>((ref) {
  return ShowAllTodosNotifier();
});

class ShowAllTodosNotifier extends StateNotifier<bool> {
  ShowAllTodosNotifier() : super(true);

  void set(bool value) {
    state = value;
  }

  void toggle() {
    state = !state;
  }
}

final isEditProvider = StateNotifierProvider<IsEditNotifier, bool>((ref) {
  return IsEditNotifier();
});

class IsEditNotifier extends StateNotifier<bool> {
  IsEditNotifier() : super(false);

  void set(bool value) {
    state = value;
  }

  void toggle() {
    state = !state;
  }
}
