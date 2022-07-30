import 'dart:io';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo_app/domain/models/todo.dart';

class LocalService{
  static LocalService localService() {
    _localService ??= LocalService();
    return _localService!;
  }

  late Box _todos;

  static LocalService? _localService;

  Box get todos => _todos;

  Future<void> init() async {
    Directory directory = await getApplicationDocumentsDirectory();
    Hive.init(directory.path);
    Hive.registerAdapter(TodoAdapter());
    initTodoBox();
  }

  dispose(){
    Hive.close();
  }

  Future<void> initTodoBox() async {
    await Hive.openBox("todos");
    _todos = Hive.box("todos");
  }

  getTodos(){
    return _todos.get("todos");
  }

  create({required Todo todo}){
    _todos.add(todo);
  }


}