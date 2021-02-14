import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tango_helper/non_ui.dart';
import 'package:tango_helper/theme.dart';

/// Widgets related to memorization.

class MemoPage extends StatefulWidget {
  final VoidCallback callback;

  @override
  MemoPage({@required this.callback});

  @override
  _MemoPageState createState() => _MemoPageState();
}

class _MemoPageState extends State<MemoPage> {
  int _index = 1;

  /// Whether the page shows a test question ([true]) or a word introduction.
  bool isInTest = true;

  Mode _mode;
  final _tempWordList = wordList.where((e) => !e.isDisabled).toList();
  Word _currentWord;
  // TODO Check whether [wordList] is empty.

  @override
  void initState() {
    super.initState();
    _currentWord = _tempWordList[Random().nextInt(_tempWordList.length)];
  }

  @override
  Widget build(BuildContext context) {
    if (mode == Mode.mixed || mode == null) {
      _mode = Mode.values[Random().nextInt(Mode.values.length - 1)];
    } else {
      _mode = mode;
    }

    // TODO Deal with words without an explanation.

    return Scaffold(
      backgroundColor: lightColor,
      appBar: AppBar(
        backgroundColor: lightColor,
        shadowColor: const Color(0),
        leading: IconButton(
          icon: BackButtonIcon(),
          color: darkColor,
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          '单词 $_index',
          style: TextStyle(color: darkColor),
        ),
      ),
      body: isInTest
          ? TestBody(
              word: _currentWord,
              mode: _mode,
              callback: () {
                setState(() {
                  isInTest = false;
                });
                widget.callback();
              },
            )
          : ReviewBody(
              word: _currentWord,
              callback: (isBack) {
                if (isBack == null)
                  throw Exception('[isBack] is [null] in callback parameter');
                if (!isBack) {
                  _index++;
                  _currentWord =
                      _tempWordList[Random().nextInt(_tempWordList.length)];
                }
                isInTest = true;
                setState(() {});
                widget.callback();
              }),
    );
  }
}

/// The widget showing the kanji/hiragana with yes/no options.
class TestBody extends StatelessWidget {
  final Word word;
  final Mode mode;
  final VoidCallback callback;
  final DateTime _startTime = DateTime.now();

  @override
  TestBody({@required this.word, @required this.mode, @required this.callback})
      : assert(word != null && mode != null && callback != null);

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (mode == Mode.read) {
      content = Text(
        word.writtenForm,
        style: TextStyle(
          fontSize: word.writtenForm.length < 5 ? 72.0 : 48.0,
          fontFamily: 'JapaneseFont',
        ),
      );
    } else if (mode == Mode.write) {
      content = Text(
        word.hiragana,
        style: TextStyle(
          fontSize: word.hiragana.length < 5 ? 72.0 : 48.0,
          fontFamily: 'JapaneseFont',
        ),
      );
    } else {
      content = RichText(
          text: TextSpan(
              text: getPosLabel(word.pos),
              children: [
                TextSpan(
                    text: word.meaning,
                    style: TextStyle(fontSize: 64.0, fontFamily: 'ChineseFont'))
              ],
              style: TextStyle(
                  fontSize: 32.0,
                  fontFamily: 'JapaneseFont',
                  color: darkColor)));
    }

    return Column(
      children: [
        Center(
          child: Container(
              height: MediaQuery.of(context).size.height / 3,
              alignment: AlignmentDirectional.center,
              child: content),
        ),
        Expanded(
          child: Container(
              margin: EdgeInsets.only(top: 32.0),
              child: Material(
                  color: darkColor,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.check_circle),
                              iconSize: 112.0,
                              color: lightColor,
                              onPressed: () async {
                                await word.answer(AnswerRecord(
                                    answer: true,
                                    type: mode,
                                    time: _startTime,
                                    duration:
                                        DateTime.now().difference(_startTime)));
                                callback();
                              },
                            ),
                            Text('我记得',
                                style: TextStyle(
                                    color: lightColor,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.cancel),
                              iconSize: 112.0,
                              color: lightColor,
                              onPressed: () async {
                                await word.answer(AnswerRecord(
                                    answer: false,
                                    type: mode,
                                    time: _startTime,
                                    duration:
                                        DateTime.now().difference(_startTime)));
                                callback();
                              },
                            ),
                            Text('我忘了',
                                style: TextStyle(
                                    color: lightColor,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                  ))),
        )
      ],
    );
  }
}

/// The widget showing the word definition, currently only kanji and hiragana.
class ReviewBody extends StatelessWidget {
  final Word word;
  final Function(bool) callback;

  @override
  ReviewBody({@required this.word, @required this.callback})
      : assert(word != null && callback != null);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Column(
            children: [
              SizedBox(height: 64.0),
              Text(word.writtenForm,
                  style: TextStyle(
                    fontSize: word.writtenForm.length < 5 ? 72.0 : 48.0,
                    fontFamily: 'JapaneseFont',
                  )),
              SizedBox(height: 16.0),
              Text(
                  word.hiragana +
                      word.accent.fold(
                          '', (s, accent) => s + getCircledAccent(accent)),
                  style: TextStyle(fontSize: 36.0, fontFamily: 'JapaneseFont')),
              SizedBox(height: 32.0),
              RichText(
                  text: TextSpan(
                      text: getPosLabel(word.pos),
                      children: [
                        TextSpan(
                            text: word.meaning,
                            style: TextStyle(fontFamily: 'ChineseFont'))
                      ],
                      style: TextStyle(
                          fontSize: 32.0,
                          fontFamily: 'JapaneseFont',
                          color: darkColor))),
            ],
          ),
        ),
        Expanded(
          child: Container(
              margin: EdgeInsets.only(top: 32.0),
              child: Material(
                color: darkColor,
                child: Stack(
                  alignment: AlignmentDirectional.topStart,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.error),
                                color: lightColor,
                                iconSize: 48.0,
                                onPressed: () async {
                                  await word.changeAnswer();
                                  callback(false);
                                },
                              ),
                              Text('答错', style: TextStyle(color: lightColor)),
                            ],
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.undo),
                                color: lightColor,
                                iconSize: 48.0,
                                onPressed: () async {
                                  await word.reverse();
                                  callback(true);
                                },
                              ),
                              Text('撤销', style: TextStyle(color: lightColor))
                            ],
                          )
                        ],
                      ),
                    ),
                    Center(
                        child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.next_plan),
                          iconSize: 112.0,
                          color: lightColor,
                          onPressed: () {
                            callback(false);
                          },
                        ),
                        Text('下一个',
                            style:
                                TextStyle(color: lightColor, fontSize: 16.0)),
                      ],
                    ))
                  ],
                ),
              )),
        )
      ],
    );
  }
}
