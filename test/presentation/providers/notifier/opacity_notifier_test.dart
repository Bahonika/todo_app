import 'package:flutter_test/flutter_test.dart';
import 'package:todo_app/presentation/providers/notifiers/opacity_notifier.dart';

void main(){

  test("Is opacity of logo changed", () {
    final opacity = OpacityNotifier();
    expect(opacity.state, 0.0);
    opacity.toggle();
    expect(opacity.state, 1.0);
  });

  test("Is opacity of logo returns", () async {
    final opacity = OpacityNotifier();
    expect(opacity.state, 0.0);
    opacity.toggle();
    await Future.delayed(const Duration(milliseconds: 500));
    expect(opacity.state, 0.0);
  });

}