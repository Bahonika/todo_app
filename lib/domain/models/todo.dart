
import 'package:hive/hive.dart';
import 'package:todo_app/domain/enums/importance.dart';

class Todo extends HiveObject{
  final String uuid;
  final bool done;
  final String text;
  final Importance importance;
  final DateTime? deadline;

  Todo(
      {required this.uuid,
      this.deadline,
      required this.done,
      required this.text,
      required this.importance});
}
