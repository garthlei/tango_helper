import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tango_helper/non_ui.dart';

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
      // backgroundColor: isInTest ? Colors.grey[700] : _currentWord.color,
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        color: isInTest ? Colors.grey[700] : _currentWord.color,
        child: Material(
          color: Color(0),
          child: Column(
            children: [
              AppBar(
                backgroundColor: const Color(0),
                shadowColor: const Color(0),
                leading: IconButton(
                  icon: BackButtonIcon(),
                  splashRadius: 24.0,
                  // color: darkColor,
                  onPressed: () => Navigator.of(context).pop(),
                ),
                title: Text(
                  '单词 $_index',
                  // style: TextStyle(color: darkColor),
                ),
                actions: [
                  isInTest
                      ? SizedBox()
                      : Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 64,
                              alignment: Alignment.center,
                              child: Text('/',
                                  style: TextStyle(
                                      fontSize: 28.0,
                                      fontWeight: FontWeight.w100)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  right: 20.0, bottom: 8.0),
                              child: Text(
                                  _currentWord.correctAnswers.toString(),
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'DIN Condensed')),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 20.0, top: 24.0),
                              child: Text(_currentWord.totalAnswers.toString(),
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'DIN Condensed')),
                            ),
                          ],
                        )
                ],
              ),
              Expanded(
                child: isInTest
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
                            throw Exception(
                                '[isBack] is [null] in callback parameter');
                          if (!isBack) {
                            _index++;
                            _currentWord = _tempWordList[
                                Random().nextInt(_tempWordList.length)];
                          }
                          isInTest = true;
                          setState(() {});
                          widget.callback();
                        }),
              ),
            ],
          ),
        ),
      ),
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
            fontSize: 36.0, color: Colors.white, fontFamily: 'Hiragino Sans'),
      );
    } else if (mode == Mode.write) {
      content = Text(
        word.hiragana,
        style: TextStyle(
            fontSize: 36.0, color: Colors.white, fontFamily: 'Hiragino Sans'),
      );
    } else {
      content = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            word.posLabel,
            style: TextStyle(
              color: Colors.white,
              fontSize: 36.0,
              fontWeight: FontWeight.w600,
              fontFamily: 'Hiragino Sans',
            ),
          ),
          SizedBox(width: 36.0),
          Text(word.meaning,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 36.0,
                  fontWeight: FontWeight.w300))
        ],
      );
    }

    return Column(
      children: [
        Center(
          child: Container(
              height: MediaQuery.of(context).size.height / 2,
              alignment: AlignmentDirectional.center,
              child: content),
        ),
        Expanded(
          child: Container(
              child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Text(
                        '✓',
                        style: GoogleFonts.balsamiqSans(
                          fontSize: 96,
                          color: Colors.white,
                        ),
                      ),
                      iconSize: 100.0,
                      // color: Colors.white,
                      onPressed: () async {
                        await word.answer(AnswerRecord(
                            answer: true,
                            type: mode,
                            time: _startTime,
                            duration: DateTime.now().difference(_startTime)));
                        callback();
                      },
                    ),
                    Text('我记得',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Text(
                        '✗',
                        style: GoogleFonts.balsamiqSans(
                          fontSize: 96,
                          color: Colors.white,
                        ),
                      ),
                      iconSize: 100.0,
                      color: Colors.white,
                      onPressed: () async {
                        await word.answer(AnswerRecord(
                            answer: false,
                            type: mode,
                            time: _startTime,
                            duration: DateTime.now().difference(_startTime)));
                        callback();
                      },
                    ),
                    Text('我忘了',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          )),
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
                    fontSize: 36.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Hiragino Sans',
                  )),
              SizedBox(height: 8.0),
              Text(
                  word.hiragana +
                      ' ' +
                      word.accent.fold(
                          '', (s, accent) => s + getCircledAccent(accent)),
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white,
                    fontFamily: 'Hiragino Sans',
                  )),
              SizedBox(height: 32.0),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    word.posLabel,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Hiragino Sans',
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Text(word.meaning,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w300))
                ],
              )
            ],
          ),
        ),
        Expanded(
          child: Container(
              margin: EdgeInsets.only(top: 32.0),
              child: Stack(
                alignment: AlignmentDirectional.bottomStart,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          child:
                              Text('答错', style: TextStyle(color: Colors.white)),
                          onPressed: () async {
                            await word.changeAnswer();
                            callback(false);
                          },
                        ),
                        TextButton(
                          child:
                              Text('撤销', style: TextStyle(color: Colors.white)),
                          onPressed: () async {
                            await word.reverse();
                            callback(true);
                          },
                        ),
                      ],
                    ),
                  ),
                  Center(
                      child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Text(
                          '✓',
                          style: GoogleFonts.balsamiqSans(
                              fontSize: 96,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        iconSize: 100.0,
                        color: Colors.white,
                        onPressed: () {
                          callback(false);
                        },
                      ),
                      Text('下一个',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold)),
                    ],
                  ))
                ],
              )),
        )
      ],
    );
  }
}
