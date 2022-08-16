import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TextControllerNotifier extends StateNotifier<TextEditingController> {
  TextControllerNotifier() : super(TextEditingController());

  void setText(String text) {
    state.text = text;
  }
}
