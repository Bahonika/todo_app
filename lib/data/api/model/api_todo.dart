import 'package:todo_app/domain/enums/importance.dart';

class ApiTodo {
  final String uuid;
  final bool done;
  final String text;
  final Importance importance;
  final DateTime? deadline;
  final DateTime createdAt;
  final DateTime changedAt;
  final String lastUpdatedBy;

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
        createdAt = DateTime.fromMillisecondsSinceEpoch(map["created_at"]),
        changedAt = DateTime.fromMillisecondsSinceEpoch(map["created_at"]),
        lastUpdatedBy = map["last_updated_by"],
        deadline = map["deadline"] != null
            ? DateTime.fromMillisecondsSinceEpoch(map["deadline"])
            : null;
}
