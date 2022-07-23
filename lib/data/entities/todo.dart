import 'package:todo_app/data/abstract/model.dart';

enum Importance { low, basic, important }

class Todo implements Model {
  final String uuid;
  final bool done;
  final String text;
  final Importance importance;
  final DateTime? deadline;

  Todo(
      {required this.uuid,
      this.deadline,
      required this.done,
      required this.text,
      required this.importance});

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      deadline: DateTime.parse(json["deadline"]),
      done: json["done"],
      text: json["name"],
      importance: json["importance"],
      uuid: json["id"],
    );
  }


  //todo: real to-map convert
  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      "id": "<uuid>", // уникальный идентификатор элемента
      "text": "blablabla",
      "importance": "<importance>", // importance = low | basic | important
      "deadline": "<unix timestamp>", // int64, может отсутствовать, тогда нет
      "done": "<bool>",
      "created_at": "<unix timestamp>",
      "changed_at": "<unix timestamp>",
      "last_updated_by": " <device id>"
    };

    return map;
  }
}
