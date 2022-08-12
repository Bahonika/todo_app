import 'package:hive/hive.dart';
import 'package:todo_app/domain/enums/importance.dart';

part 'todo.g.dart';

@HiveType(typeId: 0)
class Todo extends HiveObject {
  @HiveField(0)
  final String uuid;
  @HiveField(1)
  final bool done;
  @HiveField(2)
  final String text;
  @HiveField(3)
  final Importance importance;
  @HiveField(4)
  final DateTime? deadline;
  @HiveField(5)
  final DateTime createdAt;
  @HiveField(6)
  final DateTime changedAt;
  @HiveField(7)
  final String lastUpdatedBy;

  Todo({
    required this.createdAt,
    required this.changedAt,
    required this.lastUpdatedBy,
    required this.uuid,
    this.deadline,
    required this.done,
    required this.text,
    required this.importance,
  });

  Todo copyWith({
    String? uuid,
    bool? done,
    String? text,
    Importance? importance,
    DateTime? deadline,
    DateTime? createdAt,
    DateTime? changedAt,
    String? lastUpdatedBy,
  }) {
    return Todo(
      uuid: uuid ?? this.uuid,
      done: done ?? this.done,
      text: text ?? this.text,
      importance: importance ?? this.importance,
      deadline: deadline,
      changedAt: changedAt ?? this.changedAt,
      lastUpdatedBy: lastUpdatedBy ?? this.lastUpdatedBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
