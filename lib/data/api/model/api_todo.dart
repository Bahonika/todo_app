import 'package:todo_app/domain/enums/importance.dart';
import 'package:todo_app/domain/models/todo.dart';

class ApiTodo {
  final String uuid;
  final bool done;
  final String text;
  final Importance importance;
  final DateTime? deadline;

  static Importance importanceFromString(String stringImportance) {
    switch (stringImportance) {
      case "low":
        return Importance.low;
      case "important":
        return Importance.important;
      default:
        return Importance.basic;
    }
  }

  ApiTodo.fromApi(Map<String, dynamic> map)
      : uuid = map["id"],
        done = map["done"],
        text = map["text"],
        importance = importanceFromString(map["importance"]),
        deadline = map["deadline"] != null
            ? DateTime.fromMillisecondsSinceEpoch(map["deadline"])
            : null;
}
