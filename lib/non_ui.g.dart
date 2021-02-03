// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'non_ui.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ModeAdapter extends TypeAdapter<Mode> {
  @override
  final int typeId = 0;

  @override
  Mode read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Mode.read;
      case 1:
        return Mode.write;
      case 2:
        return Mode.mixed;
      default:
        return null;
    }
  }

  @override
  void write(BinaryWriter writer, Mode obj) {
    switch (obj) {
      case Mode.read:
        writer.writeByte(0);
        break;
      case Mode.write:
        writer.writeByte(1);
        break;
      case Mode.mixed:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PosAdapter extends TypeAdapter<Pos> {
  @override
  final int typeId = 1;

  @override
  Pos read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Pos.n;
      case 1:
        return Pos.pn;
      case 2:
        return Pos.a1;
      case 3:
        return Pos.a2;
      case 4:
        return Pos.vt1;
      case 5:
        return Pos.vt2;
      case 6:
        return Pos.vt3;
      case 7:
        return Pos.vi1;
      case 8:
        return Pos.vi2;
      case 9:
        return Pos.vi3;
      case 10:
        return Pos.ad;
      case 11:
        return Pos.pren;
      case 12:
        return Pos.intj;
      case 13:
        return Pos.conj;
      case 14:
        return Pos.cp;
      case 15:
        return Pos.promp;
      case 16:
        return Pos.endp;
      case 17:
        return Pos.contp;
      case 18:
        return Pos.parp;
      case 19:
        return Pos.quotp;
      case 20:
        return Pos.np;
      default:
        return null;
    }
  }

  @override
  void write(BinaryWriter writer, Pos obj) {
    switch (obj) {
      case Pos.n:
        writer.writeByte(0);
        break;
      case Pos.pn:
        writer.writeByte(1);
        break;
      case Pos.a1:
        writer.writeByte(2);
        break;
      case Pos.a2:
        writer.writeByte(3);
        break;
      case Pos.vt1:
        writer.writeByte(4);
        break;
      case Pos.vt2:
        writer.writeByte(5);
        break;
      case Pos.vt3:
        writer.writeByte(6);
        break;
      case Pos.vi1:
        writer.writeByte(7);
        break;
      case Pos.vi2:
        writer.writeByte(8);
        break;
      case Pos.vi3:
        writer.writeByte(9);
        break;
      case Pos.ad:
        writer.writeByte(10);
        break;
      case Pos.pren:
        writer.writeByte(11);
        break;
      case Pos.intj:
        writer.writeByte(12);
        break;
      case Pos.conj:
        writer.writeByte(13);
        break;
      case Pos.cp:
        writer.writeByte(14);
        break;
      case Pos.promp:
        writer.writeByte(15);
        break;
      case Pos.endp:
        writer.writeByte(16);
        break;
      case Pos.contp:
        writer.writeByte(17);
        break;
      case Pos.parp:
        writer.writeByte(18);
        break;
      case Pos.quotp:
        writer.writeByte(19);
        break;
      case Pos.np:
        writer.writeByte(20);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PosAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WordAdapter extends TypeAdapter<Word> {
  @override
  final int typeId = 2;

  @override
  Word read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Word()
      ..writtenForm = fields[0] as String
      ..hiragana = fields[1] as String
      ..accent = fields[2] as int
      ..meaning = fields[3] as String
      ..pos = (fields[4] as List)?.cast<bool>()
      .._totalAnswers = fields[5] as int
      .._correctAnswers = fields[6] as int
      .._lastAnswer = fields[7] as bool;
  }

  @override
  void write(BinaryWriter writer, Word obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.writtenForm)
      ..writeByte(1)
      ..write(obj.hiragana)
      ..writeByte(2)
      ..write(obj.accent)
      ..writeByte(3)
      ..write(obj.meaning)
      ..writeByte(4)
      ..write(obj.pos)
      ..writeByte(5)
      ..write(obj._totalAnswers)
      ..writeByte(6)
      ..write(obj._correctAnswers)
      ..writeByte(7)
      ..write(obj._lastAnswer);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
