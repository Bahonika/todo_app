import 'package:flutter_test/flutter_test.dart';
import 'package:todo_app/domain/circle_detector.dart';

void main(){
  final detector = CircleDetector();

  test("Line test", (){
    final list = [
      const Offset(0, 1),
      const Offset(0, 1),
      const Offset(0, 2),
      const Offset(0, 3),
      const Offset(0, 4),
    ];
    expect(detector.check(list), false);
  });

  test("Square test", () {
    final list = [
      const Offset(0, 0),
      const Offset(5, 5),
      const Offset(0, 10),
      const Offset(-5, 5),
    ];
    expect(detector.check(list), true);

  });

  test("Second square test", () {
    final list = [
      const Offset(0, 0),
      const Offset(5, 0),
      const Offset(5, 5),
      const Offset(5, 10),
      const Offset(0, 10),
      const Offset(-5, 10),
      const Offset(-5, 5),
      const Offset(-5, 0),
    ];
    expect(detector.check(list), false);

  });

}