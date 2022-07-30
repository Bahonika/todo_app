import 'dart:convert';

import 'package:todo_app/data/api/model/api_todo.dart';
import 'package:todo_app/domain/models/todo.dart';

class TodoMapper {
  static Todo fromApi(ApiTodo todo) {
    return Todo(
      uuid: todo.uuid,
      done: todo.done,
      text: todo.text,
      importance: todo.importance,
      deadline: todo.deadline,
    );
  }

  static Map<String, dynamic> toApi(Todo todo){
    Map<String, dynamic> map = {};
    map["id"] = todo.uuid;
    map["done"] = todo.done;
    map["text"] = todo.text;
    map["importance"] = todo.importance.name;

    //deadline can be null, need to check before mapping
    if (todo.deadline != null) {
      map["deadline"] =
          (todo.deadline!.toUtc().microsecondsSinceEpoch / 1000).round();
    }

    //todo with no hardcode
    map["created_at"] = 1;
    map["changed_at"] = 1;
    map["last_updated_by"] = "123";

    return {"element" : map};
  }
}
