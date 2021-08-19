/// The newly-designed home screen.

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tango_helper/memorize.dart';
import 'package:tango_helper/non_ui.dart';
import 'package:tango_helper/settings.dart';
import 'package:tango_helper/theme.dart';
import 'package:tango_helper/words.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Word exampleWord;

  @override
  void initState() {
    if (wordList.isEmpty) {
      exampleWord = Word();
      exampleWord.writtenForm = '単語助手';
      exampleWord.hiragana = 'たんごじょしゅ';
      exampleWord.accent = [4];
      exampleWord.pos = [
        false,
        true,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
      ];
      exampleWord.meaning = '您正在使用的应用程序。请进入单词库添加单词。';
    } else {
      exampleWord = wordList[Random().nextInt(wordList.length)];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grayishWhite,
      drawer: Drawer(
        child: ListView(
          children: [
            SizedBox(height: 32),
            CircleAvatar(
              radius: 48,
              backgroundColor: Colors.grey,
              child: Text(
                '单',
                style: TextStyle(color: Colors.white, fontSize: 48),
              ),
            ),
            SizedBox(height: 16),
            Center(child: Text('単語助手')),
            SizedBox(height: 32),
            Divider(),
            ListTile(
              title:
                  Text('首页', style: TextStyle(fontWeight: FontWeight.normal)),
              leading: const Icon(Icons.home),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title:
                  Text('开始记忆', style: TextStyle(fontWeight: FontWeight.normal)),
              leading: const Icon(Icons.bolt),
              onTap: wordList.any((word) => !word.isDisabled)
                  ? () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => MemoPage(callback: () {
                                setState(() {});
                              })));
                    }
                  : () => showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: Text('没有可用的单词'),
                            content: Text('请保证单词表中至少一个单词是启用的。'),
                            actions: [
                              TextButton(
                                child: Text('好'),
                                onPressed: () => Navigator.of(context).pop(),
                              )
                            ],
                          )),
            ),
            ListTile(
              title:
                  Text('单词库', style: TextStyle(fontWeight: FontWeight.normal)),
              leading: const Icon(Icons.source),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => WordListPage(
                          callback: () {
                            setState(() {});
                          },
                        )));
              },
            ),
            ListTile(
              title:
                  Text('设置', style: TextStyle(fontWeight: FontWeight.normal)),
              leading: const Icon(Icons.settings),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SettingsPage()));
              },
            )
          ],
        ),
      ),
      body: Builder(
        builder: (BuildContext context) => SafeArea(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  icon: const Icon(Icons.menu),
                  splashRadius: 24.0,
                )
              ],
            ),
            SizedBox(height: 8.0),
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width - 96.0,
                  height: 256,
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(color: Colors.grey, blurRadius: 16.0)
                  ], borderRadius: BorderRadius.circular(32.0)),
                  child: Material(
                    color: exampleWord.color,
                    borderRadius: BorderRadius.circular(32.0),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(32.0),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => WordDetailPage(
                                word: exampleWord,
                                callback: () {
                                  setState(() {});
                                })));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(36.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              exampleWord.writtenForm,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 36.0,
                                fontFamily: 'Hiragino Sans',
                              ),
                            ),
                            Text(
                              exampleWord.hiragana +
                                  '　' +
                                  exampleWord.accent.fold(
                                      '',
                                      (s, accent) =>
                                          s + getCircledAccent(accent)),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w200,
                                fontFamily: 'Hiragino Sans',
                              ),
                            ),
                            SizedBox(height: 16.0),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  exampleWord.posLabel,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(width: 16.0),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width - 216.0,
                                  child: Text(exampleWord.meaning,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w300)),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(36.0),
                  child: Text(exampleWord.correctAnswers.toString(),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          // fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'DIN Condensed')),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0, right: 28.0),
                  child: Text('/',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28.0,
                        fontWeight: FontWeight.w100,
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(exampleWord.totalAnswers.toString(),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'DIN Condensed')),
                )
              ],
            ),
            SizedBox(height: 8.0),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.count(
                    crossAxisCount: 2,
                    scrollDirection: Axis.horizontal,
                    mainAxisSpacing: 16.0,
                    crossAxisSpacing: 16.0,
                    clipBehavior: Clip.none,
                    children: wordList
                        // .map((e) => WordCard(word: e))
                        .map((e) => WordCard(
                              word: e,
                              callback: () {
                                setState(() {
                                  exampleWord = e;
                                });
                              },
                            ))
                        .toList()),
              ),
            )
          ],
        )),
      ),
    );
  }
}

class WordCard extends Container {
  WordCard({@required Word word, @required VoidCallback callback})
      : super(
          decoration: BoxDecoration(
              boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 8.0)],
              borderRadius: BorderRadius.circular(16.0)),
          child: Material(
            borderRadius: BorderRadius.circular(16.0),
            child: InkWell(
              onTap: callback,
              borderRadius: BorderRadius.circular(16.0),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Stack(
                  children: [
                    Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            word.writtenForm,
                            style: TextStyle(fontFamily: 'Hiragino Sans'),
                          ),
                          Text(
                            word.hiragana +
                                word.accent.fold(
                                    '',
                                    (str, accent) =>
                                        str + getCircledAccent(accent)),
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12.0,
                              fontWeight: FontWeight.w300,
                              fontFamily: 'Hiragino Sans',
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 20.0,
                      height: 20.0,
                      alignment: Alignment.center,
                      color: word.color,
                      child: Text(
                          word.pos.fold(
                                  false,
                                  (previousValue, element) =>
                                      previousValue || element)
                              ? word.posLabel.characters.first
                              : '',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Hiragino Sans',
                          )),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
}
