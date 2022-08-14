import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedDateProvider =
StateNotifierProvider<SelectedDateNotifier, DateTime>((ref) {
  return SelectedDateNotifier();
});

class SelectedDateNotifier extends StateNotifier<DateTime> {
  SelectedDateNotifier() : super(DateTime.now());

  void setDate(DateTime dateTime) {
    state = dateTime;
  }

  void setDefault() {
    state = DateTime.now();
  }
}
