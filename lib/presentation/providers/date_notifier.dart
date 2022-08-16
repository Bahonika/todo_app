import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectedDateNotifier extends StateNotifier<DateTime> {
  SelectedDateNotifier() : super(DateTime.now());

  void setDate(DateTime dateTime) {
    state = dateTime;
  }
}
