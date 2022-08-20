import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:todo_app/domain/enums/importance.dart';

part 'todo.freezed.dart';

@freezed
class Todo with _$Todo {
  const factory Todo({
    required String uuid,
    required bool done,
    required String text,
    required Importance importance,
    DateTime? deadline,
    required DateTime createdAt,
    required DateTime changedAt,
    required String lastUpdatedBy,
  }) = _Todo;
}
