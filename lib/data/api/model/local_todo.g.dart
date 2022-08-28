// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_todo.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LocalTodoAdapter extends TypeAdapter<LocalTodo> {
  @override
  final int typeId = 0;

  @override
  LocalTodo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LocalTodo(
      createdAt: fields[5] as DateTime,
      changedAt: fields[6] as DateTime,
      lastUpdatedBy: fields[7] as String,
      uuid: fields[0] as String,
      deadline: fields[4] as DateTime?,
      done: fields[1] as bool,
      text: fields[2] as String,
      importance: fields[3] as Importance,
    );
  }

  @override
  void write(BinaryWriter writer, LocalTodo obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.uuid)
      ..writeByte(1)
      ..write(obj.done)
      ..writeByte(2)
      ..write(obj.text)
      ..writeByte(3)
      ..write(obj.importance)
      ..writeByte(4)
      ..write(obj.deadline)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.changedAt)
      ..writeByte(7)
      ..write(obj.lastUpdatedBy);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocalTodoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
