import 'package:todo_app/data/api/model/api_todo.dart';
import 'package:todo_app/data/api/model/local_todo.dart';
import 'package:todo_app/domain/models/todo.dart';

class TodoMapper {
  static Todo fromLocal(LocalTodo todo) {
    return Todo(
      uuid: todo.uuid,
      done: todo.done,
      text: todo.text,
      importance: todo.importance,
      deadline: todo.deadline,
      createdAt: todo.createdAt,
      changedAt: todo.changedAt,
      lastUpdatedBy: todo.lastUpdatedBy,
    );
  }

  static LocalTodo toLocal(Todo todo) {
    return LocalTodo(
      uuid: todo.uuid,
      done: todo.done,
      text: todo.text,
      importance: todo.importance,
      deadline: todo.deadline,
      createdAt: todo.createdAt,
      changedAt: todo.changedAt,
      lastUpdatedBy: todo.lastUpdatedBy,
    );
  }

  static Todo fromApi(Map<String, dynamic> map) {
    final todo = ApiTodo.fromMap(map);
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
    final map = <String, dynamic>{};
    map["id"] = todo.uuid;
    map["done"] = todo.done;
    map["text"] = todo.text;
    map["importance"] = todo.importance.name;

    //deadline can be null, need to check before mapping
    if (todo.deadline != null) {
      map["deadline"] =
          (todo.deadline!.toUtc().microsecondsSinceEpoch / 1000).round();
    }

    map["created_at"] =
        (todo.createdAt.toUtc().microsecondsSinceEpoch / 1000).round();
    map["changed_at"] =
        (todo.changedAt.toUtc().microsecondsSinceEpoch / 1000).round();
    map["last_updated_by"] = todo.lastUpdatedBy;

    return map;
  }

  static Map<String, dynamic> toApiWithPrefixElement(Todo todo) {
    return {"element": toApi(todo)};
  }

  static Map<String, dynamic> listToApi(List<Todo> todos) {
    final list = <Map<String, dynamic>>[];

    for (Todo todo in todos) {
      list.add(toApi(todo));
    }

    return {"list": list};
  }
}
