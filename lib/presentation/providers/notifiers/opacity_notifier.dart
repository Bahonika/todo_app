import 'package:flutter_riverpod/flutter_riverpod.dart';

class OpacityNotifier extends StateNotifier<double> {
  OpacityNotifier() : super(0.0);

  double get opacity => state;

  void toggle() async{
    state = 1.0;
    await Future.delayed(const Duration(milliseconds: 500));
    state = 0.0;
  }
}
