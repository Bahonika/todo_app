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
      changedAt: todo.changedAt,
      lastUpdatedBy: todo.lastUpdatedBy,
      createdAt: todo.createdAt,
    );
  }

  static Map<String, dynamic> toApi(Todo todo) {
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

    map["created_at"] = todo.createdAt;
    map["changed_at"] = todo.changedAt;
    map["last_updated_by"] = "123";

    return {"element": map};
  }

  static Map<String, dynamic> listToApi(List<Todo> todos){
    List<Map<String, dynamic>> list = [];

    for (int i = 0; i < todos.length; i++){
      Map<String, dynamic> map = {};
      map["id"] = todos[i].uuid;
      map["done"] = todos[i].done;
      map["text"] = todos[i].text;
      map["importance"] = todos[i].importance.name;

      //deadline can be null, need to check before mapping
      if (todos[i].deadline != null) {
        map["deadline"] =
            (todos[i].deadline!.toUtc().microsecondsSinceEpoch / 1000).round();
      }

      map["created_at"] = todos[i].createdAt;
      map["changed_at"] = todos[i].changedAt;
      map["last_updated_by"] = "123";
      list.add(map);
    }

    return {"list": list};
  }
}
