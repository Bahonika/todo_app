import 'package:todo_app/domain/enums/importance.dart';
import 'package:todo_app/domain/models/todo.dart';

final todo = Todo(uuid: "1",
    done: false,
    text: "test1",
    importance: Importance.basic,
    createdAt: DateTime.now(),
    changedAt: DateTime.now(),
    lastUpdatedBy: "1",
);

