import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShowDateNotifier extends StateNotifier<bool> {
  ShowDateNotifier() : super(false);

  void setTrue() {
    state = true;
  }

  void setFalse() {
    state = false;
  }

  void toggle() {
    state = !state;
  }
}

class ShowAllTodosNotifier extends StateNotifier<bool> {
  ShowAllTodosNotifier() : super(true);

  void setTrue() {
    state = true;
  }

  void setFalse() {
    state = false;
  }

  void toggle() {
    state = !state;
  }
}

class IsEditNotifier extends StateNotifier<bool> {
  IsEditNotifier() : super(false);

  void setTrue() {
    state = true;
  }

  void setFalse() {
    state = false;
  }

  void toggle() {
    state = !state;
  }
}


class IsDarkNotifier extends StateNotifier<bool> {
  IsDarkNotifier() : super(false);

  void setTrue() {
    state = true;
  }

  void setFalse() {
    state = false;
  }

  void toggle() {
    state = !state;
  }
}