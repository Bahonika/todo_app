import 'dart:io';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo_app/domain/enums/importance.dart';
import 'package:todo_app/domain/models/todo.dart';

class LocalService{
  static LocalService? _localService;
  static LocalService localService() {
    _localService ??= LocalService();
    return _localService!;
  }

  late Box<Todo> _todos;

  Box<Todo> get todos => _todos;

  Future<void> init() async {
    Directory directory = await getApplicationDocumentsDirectory();
    Hive.init(directory.path);
    Hive.registerAdapter(TodoAdapter());
    Hive.registerAdapter(ImportanceAdapter());
    _todos = await Hive.openBox<Todo>("todos");
  }

  dispose(){
    Hive.close();
  }

  void initTodoBox()  {
    _todos = Hive.box<Todo>("todos");
  }

  getTodos(){
    return _todos.get("todos");
  }

  create({required Todo todo}){
    _todos.add(todo);
  }

  delete({required String uuid}){
    _todos.delete(_todos.keys.firstWhere((element) => _todos.toMap()[element]!.uuid == uuid));
  }

  update({required Todo todo}){
    _todos.put(_todos.keys.firstWhere((element) => _todos.toMap()[element]!.uuid == todo.uuid), todo);
  }

}