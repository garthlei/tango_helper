import 'package:flutter/material.dart';
import 'package:tango_helper/memorize.dart';
import 'package:tango_helper/non_ui.dart';
import 'package:tango_helper/settings.dart';
import 'package:tango_helper/words.dart';

void main() {
  init();
  runApp(TangoHelper());
}

class TangoHelper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SimpleNavigator(),
    );
  }
}

class SimpleNavigator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('単語助手')),
      body: ListView(
        children: [
          ListTile(
            title: Text('开始记忆'),
            onTap: () => wordList.isEmpty
                ? showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: Text('没有单词'),
                          content: Text('请在单词表中添加至少一个单词。'),
                          actions: [
                            TextButton(
                              child: Text('好'),
                              onPressed: () => Navigator.of(context).pop(),
                            )
                          ],
                        ))
                : Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => MemoPage())),
          ),
          ListTile(
            title: Text('单词表'),
            onTap: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => WordListPage())),
          ),
          ListTile(
            title: Text('模式选择'),
            onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => ModeSelectorPage())),
          ),
        ],
      ),
    );
  }
}
