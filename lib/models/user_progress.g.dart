// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_progress.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserProgressAdapter extends TypeAdapter<UserProgress> {
  @override
  final int typeId = 2;

  @override
  UserProgress read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserProgress(
      id: fields[0] as String,
      scheduleId: fields[1] as String,
      date: fields[2] as String,
      exerciseId: fields[4] as String,
    )..exerciseData = (fields[3] as Map).cast<String, dynamic>();
  }

  @override
  void write(BinaryWriter writer, UserProgress obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.scheduleId)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.exerciseData)
      ..writeByte(4)
      ..write(obj.exerciseId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProgressAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
