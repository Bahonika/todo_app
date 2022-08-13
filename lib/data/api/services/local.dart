import 'dart:io';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo_app/domain/enums/importance.dart';
import 'package:todo_app/domain/models/todo.dart';

class LocalService {
  static const _revisionKey = "revision";

  late Box<Todo> _todos;
  late Box<int> _revision;

  Box<Todo> get todos => _todos;

  Box<int> get revision => _revision;

  void setRevision(int value) {
    _revision.put(_revisionKey, value);
  }

  void incrementRevision() {
    setRevision(_revision.get(_revisionKey)!);
  }

  Future<void> init() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    Hive.init(directory.path);
    Hive.registerAdapter(TodoAdapter());
    Hive.registerAdapter(ImportanceAdapter());
    _todos = await Hive.openBox<Todo>("todos");
    _revision = await Hive.openBox<int>(_revisionKey);
  }

  void dispose() {
    Hive.close();
  }

  List<Todo> getTodos() {
    final data = _todos.values.toList();
    return data;
  }

  void create({required Todo todo}) {
    _todos.add(todo);
  }

  void delete({required String uuid}) {
    _todos.delete(_todos.keys
        .firstWhere((element) => _todos.toMap()[element]!.uuid == uuid));
  }

  void update({required Todo todo}) {
    _todos.put(
        _todos.keys.firstWhere(
            (element) => _todos.toMap()[element]!.uuid == todo.uuid),
        todo);
  }
}
