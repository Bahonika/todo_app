import 'dart:io';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo_app/data/api/model/local_todo.dart';
import 'package:todo_app/data/mappers/todo_mapper.dart';
import 'package:todo_app/domain/enums/importance.dart';
import 'package:todo_app/domain/models/todo.dart';
import 'package:uuid/uuid.dart';

class LocalService {
  // keys
  static const _revisionKey = "revision";
  static const _todosKey = "todos";
  static const _deviceIdKey = "deviceId";

  // boxes
  late Box<LocalTodo> _todos;
  late Box<int> _revision;
  late Box<String> _deviceId;

  // getters
  Box<LocalTodo> get todos => _todos;

  Box<int> get revision => _revision;

  Box<String> get deviceId => _deviceId;

  final uuid = const Uuid();

  Future<void> init() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    Hive.init(directory.path);
    Hive.registerAdapter(LocalTodoAdapter());
    Hive.registerAdapter(ImportanceAdapter());
    _todos = await Hive.openBox<LocalTodo>(_todosKey);
    _revision = await Hive.openBox<int>(_revisionKey);
    _deviceId = await Hive.openBox<String>(_deviceIdKey);
    setDeviceId(uuid.v1());
  }

  void dispose() {
    Hive.close();
  }

  // todos box
  List<Todo> getTodos() {
    final data =
        _todos.values.map((todo) => TodoMapper.fromLocal(todo)).toList();
    return data;
  }

  void create({required Todo todo}) {
    final localTodo = TodoMapper.toLocal(todo);
    _todos.add(localTodo);
  }

  void delete({required String uuid}) {
    _todos.delete(_todos.keys
        .firstWhere((element) => _todos.toMap()[element]!.uuid == uuid));
  }

  void update({required Todo todo}) {
    final localTodo = TodoMapper.toLocal(todo);
    _todos.put(
        _todos.keys.firstWhere(
            (element) => _todos.toMap()[element]!.uuid == todo.uuid),
        localTodo);
  }

  //revision box
  int getRevision() {
    final revision = _revision.values.last;
    return revision;
  }

  void setRevision(int value) {
    _revision.putAt(0, value);
  }

  void incrementRevision() {
    setRevision(_revision.get(_revisionKey)! + 1);
  }

  // device id box
  void setDeviceId(String value) {
    if (_deviceId.isEmpty) {
      _deviceId.put(_deviceIdKey, value);
    }
  }
}
