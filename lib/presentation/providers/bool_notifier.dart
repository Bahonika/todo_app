import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShowAllTodosNotifier extends StateNotifier<bool> {
  ShowAllTodosNotifier() : super(true);

  void setTrue() => state = true;

  void setFalse() => state = false;

  void toggle() => state = !state;
}

class IsDarkNotifier extends StateNotifier<bool> {
  IsDarkNotifier() : super(false);

  void setTrue() => state = true;

  void setFalse() => state = false;

  void toggle() => state = !state;
}
