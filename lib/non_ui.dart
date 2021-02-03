import 'dart:convert';

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

  /// 格助
  @HiveField(14)
  cp,

  /// 取立て助
  @HiveField(15)
  promp,

  /// 終助
  @HiveField(16)
  endp,

  /// 接助
  @HiveField(17)
  contp,

  /// 並助
  @HiveField(18)
  parp,

  /// 引助
  @HiveField(19)
  quotp,

  /// 準助
  @HiveField(20)
  np,
}

/// A Japanese word stored in the word list.
@HiveType(typeId: 2)
class Word {
  @HiveField(0)
  String writtenForm = '';

  @HiveField(1)
  String hiragana = '';

  @HiveField(2)
  int accent = -1;

  @HiveField(3)
  String meaning = '';

  /// Part of speech of the word.
  @HiveField(4)
  List<bool> pos = Pos.values.map((e) => false).toList();

  @HiveField(5)
  int _totalAnswers = 0;

  @HiveField(6)
  int _correctAnswers = 0;

  @HiveField(7)
  bool _lastAnswer;

  int get totalAnswers => _totalAnswers;
  int get correctAnswers => _correctAnswers;

  Future<void> answer(bool isCorrect) async {
    if (isCorrect) _correctAnswers++;
    _totalAnswers++;
    _lastAnswer = isCorrect;
    await save();
  }

  /// Reverse the last answer.
  Future<void> reverse() async {
    if (_lastAnswer == null)
      throw Exception('Last-answer information is unavailable.');
    if (_lastAnswer) _correctAnswers--;
    _totalAnswers--;
    _lastAnswer = null;
    await save();
  }
}

/// Initialize Hive.
Future<void> init() async {
  await Hive.initFlutter();
  Hive.registerAdapter(ModeAdapter());
  Hive.registerAdapter(PosAdapter());
  Hive.registerAdapter(WordAdapter());
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
}

/// Save in the Hive box.
Future<void> save() async {
  await box.put('word_list', wordList);
  await box.put('mode', mode);
}

String getCircledAccent(int accent) {
  const circleMap = '⓪①②③⑤⑥⑦⑧⑨⑩⑪⑫⑬⑭⑮⑰⑱⑲⑳㉑㉒㉓㉔㉕㉖㉗㉘㉙㉚㉛㉜㉝㉞㉟';

  if (accent < 0) return '';

  if (accent < circleMap.length) return circleMap[accent];

  return '($accent)';
}
