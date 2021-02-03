import 'package:flutter/material.dart';
import 'package:tango_helper/non_ui.dart';

/// Widgets related to words.

class WordListPage extends StatefulWidget {
  @override
  _WordListPageState createState() => _WordListPageState();
}

class _WordListPageState extends State<WordListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('单词表'),
        actions: [
          IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => WordDetailPage(callback: () {
                          setState(() {});
                        })));
              })
        ],
      ),
      body: ListView(
          children: wordList
              .map((e) => ListTile(
                    title: Text(e.writtenForm),
                    subtitle:
                        Text('${e.hiragana} ${getCircledAccent(e.accent)}'),
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => WordDetailPage(
                              word: e,
                              callback: () {
                                setState(() {});
                              },
                            ))),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('${e.correctAnswers} / ${e.totalAnswers}'),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () async {
                            wordList.remove(e);
                            await save();
                            setState(() {});
                          }, // TODO Use a better method to remove.
                        ),
                      ],
                    ),
                  ))
              .toList()),
    );
  }
}

class WordDetailPage extends StatefulWidget {
  final Word word;
  final VoidCallback callback;

  @override
  WordDetailPage({this.word, @required this.callback});

  @override
  _WordDetailPageState createState() => _WordDetailPageState(word);
}

class _WordDetailPageState extends State<WordDetailPage> {
  Word word;
  final _formKey = GlobalKey<FormState>();

  @override
  _WordDetailPageState(this.word);

  @override
  Widget build(BuildContext context) {
    if (word == null) word = Word();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.word == null ? '新单词' : '单词详情'),
        actions: [
          TextButton(
            child: Text(
              '保存',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () async {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                if (widget.word == null) wordList.add(word);
                await save();
                widget.callback();
                Navigator.of(context).pop();
              }
            },
          )
        ],
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  initialValue: word.writtenForm,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(labelText: '书写形式'),
                  onSaved: (str) => word.writtenForm = str,
                  validator: (str) => str.isEmpty ? '书写形式不能为空。' : null,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  initialValue: word.hiragana,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(labelText: '平假名'),
                  onSaved: (str) => word.hiragana = str,
                  validator: (str) => str.isEmpty ? '平假名不能为空。' : null,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  initialValue: word.accent == -1 ? '' : word.accent.toString(),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(labelText: '声调'),
                  onSaved: (str) => word.accent = int.tryParse(str) ?? -1,
                  validator: (str) {
                    if (str.isNotEmpty &&
                        (int.tryParse(str) == null || int.tryParse(str) < 0)) {
                      return '请输入非负整数。';
                    }
                    return null;
                  },
                ),
              ),
              // TODO Add POS and meaning parts.
            ],
          ),
        ),
      ),
    );
  }
}
