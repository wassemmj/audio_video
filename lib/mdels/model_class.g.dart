// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_class.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ModelClassAdapter extends TypeAdapter<ModelClass> {
  @override
  final int typeId = 0;

  @override
  ModelClass read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ModelClass(
        uri: fields[0] as String?,
        artist: fields[1] as String?,
        name: fields[2] as String?,
        duration: fields[3] as int?,
        index: fields[4] as int?,
        id: fields[5] as int?);
  }

  @override
  void write(BinaryWriter writer, ModelClass obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.uri)
      ..writeByte(1)
      ..write(obj.artist)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.duration)
      ..writeByte(4)
      ..write(obj.index)
      ..writeByte(5)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModelClassAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
