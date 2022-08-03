import 'dart:io';

import 'package:hive/hive.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo_app/domain/enums/importance.dart';
import 'package:todo_app/domain/models/todo.dart';
import 'package:todo_app/presentation/logger/logging.dart';

class LocalService {
  static LocalService? _localService;

  static LocalService localService() {
    _localService ??= LocalService();
    return _localService!;
  }

  late Box<Todo> _todos;
  late Box<int> _revision;

  Box<Todo> get todos => _todos;

  Box<int> get revision => _revision;

  void setRevision(int value) {
    _revision.put("revision", value);
  }
  void incrementRevision(){
    setRevision(_revision.get("revision")!);
  }


  Future<void> init() async {
    Directory directory = await getApplicationDocumentsDirectory();
    Hive.init(directory.path);
    Hive.registerAdapter(TodoAdapter());
    Hive.registerAdapter(ImportanceAdapter());
    _todos = await Hive.openBox<Todo>("todos");
    _revision = await Hive.openBox<int>("revision");
  }

  dispose() {
    Hive.close();
  }

  create({required Todo todo}) {
    _todos.add(todo);
  }

  delete({required String uuid}) {
    _todos.delete(_todos.keys
        .firstWhere((element) => _todos.toMap()[element]!.uuid == uuid));
  }

  update({required Todo todo}) {
    _todos.put(
        _todos.keys.firstWhere(
            (element) => _todos.toMap()[element]!.uuid == todo.uuid),
        todo);
  }
}
