import 'dart:io';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo_app/data/api/model/api_todo.dart';
import 'package:todo_app/domain/models/todo.dart';

class LocalService{
  Box? todoBox;
  Future<void> init() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();

    Hive.init(appDocDir.path);
    await Hive.openBox<Todo>("todos");
    var todoBox = Hive.box("todos");
  }


  Future<List<ApiTodo>> getTodos(){
    return todoBox!.get("todos");
  }
}