import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final textControllerProvider =
StateNotifierProvider<TextControllerNotifier, TextEditingController>((ref) {
  return TextControllerNotifier();
});

class TextControllerNotifier extends StateNotifier<TextEditingController> {
  TextControllerNotifier() : super(TextEditingController());

  void setDefault() {
    state.text = "";
  }

  void setText(String text) {
    state.text = text;
  }
}
