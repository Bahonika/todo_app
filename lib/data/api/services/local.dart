import 'dart:io';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo_app/domain/enums/importance.dart';
import 'package:todo_app/domain/models/todo.dart';
import 'package:uuid/uuid.dart';

class LocalService {
  // keys
  static const _revisionKey = "revision";
  static const _todosKey = "todos";
  static const _deviceIdKey = "deviceId";

  // boxes
  late Box<Todo> _todos;
  late Box<int> _revision;
  late Box<String> _deviceId;

  // getters
  Box<Todo> get todos => _todos;

  Box<int> get revision => _revision;

  Box<String> get deviceId => _deviceId;

  final uuid = const Uuid();

  Future<void> init() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    Hive.init(directory.path);
    Hive.registerAdapter(TodoAdapter());
    Hive.registerAdapter(ImportanceAdapter());
    _todos = await Hive.openBox<Todo>(_todosKey);
    _revision = await Hive.openBox<int>(_revisionKey);
    _deviceId = await Hive.openBox<String>(_deviceIdKey);
    setDeviceId(uuid.v1());
  }

  void dispose() {
    Hive.close();
  }

  // todos box
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

  //revision box

  void setRevision(int value) {
    _revision.put(_revisionKey, value);
  }

  void incrementRevision() {
    setRevision(_revision.get(_revisionKey)!);
  }

  // device id box

  void setDeviceId(String value) {
    if (_deviceId.isEmpty) {
      _deviceId.put(_deviceIdKey, value);
    }
  }
}
