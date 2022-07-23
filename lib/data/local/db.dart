import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/data/entities/todo.dart';

abstract class DB {

  static Database? _db;

  static int get _version => 1;

  static Future<void> init() async {

    if (_db != null) { return; }

    try {
      String path = '${await getDatabasesPath()}example';
      _db = await openDatabase(path, version: _version, onCreate: onCreate);
    }
    catch(ex) {
      print(ex);
    }
  }

  static void onCreate(Database db, int version) async =>
      await db.execute('CREATE TABLE todo_items (id INTEGER PRIMARY KEY NOT NULL, task STRING, complete BOOLEAN)');

  static Future<List<Map<String, dynamic>>> query(String table) async => _db!.query(table);

  static Future<int> insert(String table, Todo todo) async =>
      await _db!.insert(table, todo.toJson());

  static Future<int> update(String table, Todo todo  ) async =>
      await _db!.update(table, todo.toJson(), where: 'id = ?', whereArgs: [todo.uuid]);

  static Future<int> delete(String table, Todo todo) async =>
      await _db!.delete(table, where: 'id = ?', whereArgs: [todo.uuid]);
}
