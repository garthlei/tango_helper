import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tango_helper/non_ui.dart';

/// Widgets related to memorization.

class MemoPage extends StatefulWidget {
  @override
  _MemoPageState createState() => _MemoPageState();
}

class _MemoPageState extends State<MemoPage> {
  int _index = 1;

  /// Whether the page shows a test question ([true]) or a word introduction.
  bool isInTest = true;

  Mode _mode;
  Word _currentWord = wordList[Random().nextInt(wordList.length)];
  // TODO Check whether [wordList] is empty.

  @override
  Widget build(BuildContext context) {
    if (mode == Mode.mixed || mode == null) {
      _mode = Mode.values[Random().nextInt(Mode.values.length - 1)];
    } else {
      _mode = mode;
    }

    return Scaffold(
      appBar: AppBar(title: Text('单词 $_index')),
      body: isInTest
          ? TestBody(
              word: _currentWord,
              mode: _mode,
              callback: () {
                setState(() {
                  isInTest = false;
                });
              },
            )
          : ReviewBody(
              word: _currentWord,
              callback: (isReversed) async {
                if (isReversed == null)
                  throw Exception(
                      '[isReversed] is [null] in callback parameter');
                if (isReversed == true) await _currentWord.reverse();
                if (!isReversed) {
                  _index++;
                  _currentWord = wordList[Random().nextInt(wordList.length)];
                }
                isInTest = true;
                setState(() {});
              }),
    );
  }
}

/// The widget showing the kanji/hiragana with yes/no options.
class TestBody extends StatelessWidget {
  final Word word;
  final Mode mode;
  final VoidCallback callback;

  @override
  TestBody({@required this.word, @required this.mode, @required this.callback})
      : assert(word != null && mode != null && callback != null);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Center(
            child: mode == Mode.read
                ? Text(
                    word.writtenForm,
                    style: TextStyle(
                      fontSize: word.writtenForm.length < 5 ? 72.0 : 64.0,
                      fontFamily: 'JapaneseFont',
                    ),
                  )
                : Text(
                    word.hiragana,
                    style: TextStyle(
                      fontSize: word.hiragana.length < 5 ? 72.0 : 48.0,
                      fontFamily: 'JapaneseFont',
                    ),
                  ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                child:
                    Text('记得', style: TextStyle(fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                    minimumSize: Size(128.0, 64.0),
                    textStyle: TextStyle(fontSize: 24.0)),
                onPressed: () async {
                  await word.answer(true);
                  callback();
                },
              ),
              ElevatedButton(
                child: Text('不记得', style: TextStyle(fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                    minimumSize: Size(128.0, 64.0),
                    textStyle: TextStyle(fontSize: 24.0)),
                onPressed: () async {
                  await word.answer(false);
                  callback();
                },
              ),
            ],
          ),
        ],
      ),
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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Text(word.writtenForm,
                    style: TextStyle(
                      fontSize: word.writtenForm.length < 5 ? 72.0 : 64.0,
                      fontFamily: 'JapaneseFont',
                      // fontWeight: FontWeight.w700
                    )),
                SizedBox(height: 16.0),
                Text(word.hiragana + getCircledAccent(word.accent),
                    style:
                        TextStyle(fontSize: 36.0, fontFamily: 'JapaneseFont')),
              ],
            ),
            Column(
              children: [
                ElevatedButton(
                    child: Text('下一个'), onPressed: () => callback(false)),
                TextButton(
                    child: Text('撤回选择'), onPressed: () => callback(true)),
              ],
            )
          ],
        ),
      ),
    );
  }
}
