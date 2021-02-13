import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'non_ui.g.dart';

/// Non-widget classes in Tango Helper.

Mode mode;
Box box;
List<Word> wordList;

// The memorization mode.
@HiveType(typeId: 0)
enum Mode {
  @HiveField(0)
  read,

  @HiveField(1)
  write,

  @HiveField(3)
  output,

  @HiveField(2)
  mixed,
}

// Japanese parts of speech.
@HiveType(typeId: 1)
enum Pos {
  /// 名
  @HiveField(0)
  n,

  /// 固名
  @HiveField(1)
  pn,

  /// 形 I
  @HiveField(2)
  a1,

  /// 形 II
  @HiveField(3)
  a2,

  /// 他 I
  @HiveField(4)
  vt1,

  /// 他 II
  @HiveField(5)
  vt2,

  /// 他 III
  @HiveField(6)
  vt3,

  /// 自 I
  @HiveField(7)
  vi1,

  /// 自 II
  @HiveField(8)
  vi2,

  /// 自 III
  @HiveField(9)
  vi3,

  /// 副
  @HiveField(10)
  ad,

  /// 連体
  @HiveField(11)
  pren,

  /// 感
  @HiveField(12)
  intj,

  /// 接
  @HiveField(13)
  conj,

  /// 判
  @HiveField(14)
  jud,

  /// 格助
  @HiveField(15)
  cp,

  /// 取立て助
  @HiveField(16)
  promp,

  /// 終助
  @HiveField(17)
  endp,

  /// 接助
  @HiveField(18)
  contp,

  /// 並助
  @HiveField(19)
  parp,

  /// 引助
  @HiveField(20)
  quotp,

  /// 準助
  @HiveField(21)
  np,
}

@HiveType(typeId: 3)
class AnswerRecord {
  @HiveField(0)
  final bool answer;

  @HiveField(1)
  final Mode type;

  @HiveField(2)
  final DateTime time;

  @HiveField(3)
  final Duration duration;

  AnswerRecord(
      {@required this.answer,
      @required this.type,
      @required this.time,
      this.duration});
}

/// A Japanese word stored in the word list.
@HiveType(typeId: 2)
class Word {
  @HiveField(0)
  String writtenForm = '';

  @HiveField(1)
  String hiragana = '';

  @HiveField(8)
  List<int> accent = List();

  @HiveField(3)
  String meaning = '';

  /// Part of speech of the word.
  @HiveField(4)
  List<bool> pos = Pos.values.map((e) => false).toList();

  @HiveField(5)
  int _totalAnswers = 0;

  @HiveField(6)
  int _correctAnswers = 0;

  @HiveField(9)
  List<AnswerRecord> answers = List();

  @HiveField(7)
  bool _lastAnswer;

  @HiveField(10)
  bool isDisabled = false;

  int get totalAnswers => _totalAnswers;
  int get correctAnswers => _correctAnswers;

  double getAverage({Mode mode}) {
    int avg = 0;
    int times = 0;

    for (final record in answers)
      if ((mode == null || record.type == mode) && record.answer) {
        avg += record.duration.inMilliseconds;
        times++;
      }

    if (times == 0) return null;
    avg ~/= times * 100;

    return avg / 10;
  }

  String getCount({Mode mode}) {
    int yesCount = 0, totalCount = 0;

    for (final record in answers)
      if (mode == null || mode == record.type) {
        yesCount += record.answer ? 1 : 0;
        totalCount++;
      }

    return '$yesCount / $totalCount';
  }

  Future<void> answer(AnswerRecord record) async {
    if (record.answer) _correctAnswers++;
    _totalAnswers++;
    _lastAnswer = record.answer;
    answers.add(record);
    await save();
  }

  /// Reverse the last answer.
  Future<void> reverse() async {
    if (_lastAnswer == null)
      throw Exception('Last-answer information is unavailable.');
    if (_lastAnswer) _correctAnswers--;
    _totalAnswers--;
    _lastAnswer = null;
    answers.removeLast();
    await save();
  }
}

/// Initialize Hive.
Future<void> init() async {
  await Hive.initFlutter();
  Hive.registerAdapter(ModeAdapter());
  Hive.registerAdapter(PosAdapter());
  Hive.registerAdapter(WordAdapter());
  Hive.registerAdapter(AnswerRecordAdapter());
  Hive.registerAdapter(DurationAdapter());
  box = await Hive.openBox('user');

  wordList =
      (box.get('word_list') as List<dynamic>)?.map((e) => e as Word)?.toList();
  if (wordList == null) {
    wordList = List<Word>();
    await box.put('word_list', wordList);
  }

  mode = box.get('mode');
  if (mode == null) {
    mode = Mode.mixed;
    await box.put('mode', mode);
  }

  /// For backward compatibility.
  for (int i = 0; i < wordList.length; i++) {
    if (wordList[i].accent == null) wordList[i].accent = List();
    if (wordList[i].answers == null) wordList[i].answers = List();
    if (wordList[i].isDisabled == null) wordList[i].isDisabled = false;
    if (wordList[i].pos.length == 21) wordList[i].pos.add(false);
  }
  await save();
}

/// Save in the Hive box.
Future<void> save() async {
  await box.put('word_list', wordList);
  await box.put('mode', mode);
}

String getCircledAccent(int accent) {
  const circleMap = '⓪①②③④⑤⑥⑦⑧⑨⑩⑪⑫⑬⑭⑮⑯⑰⑱⑲⑳㉑㉒㉓㉔㉕㉖㉗㉘㉙㉚㉛㉜㉝㉞㉟';

  if (accent < 0) return '';

  if (accent < circleMap.length) return circleMap[accent];

  return '($accent)';
}

String getPosChinese(Pos pos) {
  const chineseMap = [
    '名词',
    '专有名词',
    'I 类形容词',
    'II 类形容词',
    'I 类他动词',
    'II 类他动词',
    'III 类他动词',
    'I 类自动词',
    'II 类自动词',
    'III 类自动词',
    '副词',
    '连体词',
    '叹词',
    '连词',
    '判断词',
    '格助词',
    '凸显助词',
    '语气助词',
    '接续助词',
    '并列助词',
    '引用助词',
    '准体助词',
  ];
  return chineseMap[pos.index];
}

String getPosAbbr(Pos pos) {
  const abbrMap = [
    '名',
    '固名',
    '形 I',
    '形 II',
    '他 I',
    '他 II',
    '他 III',
    '自 I',
    '自 II',
    '自 III',
    '副',
    '連体',
    '感',
    '接',
    '判',
    '格助',
    '取立て助',
    '終助',
    '接助',
    '並助',
    '引助',
    '準助',
  ];
  return abbrMap[pos.index];
}

String getPosLabel(List<bool> pos) {
  List<Pos> posLabels = List();
  String _ret = '［';
  for (int i = 0; i < pos.length; i++) if (pos[i]) posLabels.add(Pos.values[i]);

  if (posLabels.isEmpty) return '';
  _ret += getPosAbbr(posLabels.first);
  for (int i = 1; i < posLabels.length; i++)
    _ret += '・' + getPosAbbr(posLabels[i]);
  _ret += '］';
  return _ret;
}

class DurationAdapter extends TypeAdapter<Duration> {
  @override
  final int typeId = 4;

  @override
  Duration read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Duration(
      microseconds: fields[0] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Duration obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.inMicroseconds);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DurationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
