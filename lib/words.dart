import 'package:flutter/material.dart';
import 'package:tango_helper/non_ui.dart';
import 'package:tango_helper/theme.dart';

/// Widgets related to words.

class WordListPage extends StatefulWidget {
  final VoidCallback callback;

  WordListPage({this.callback});

  @override
  _WordListPageState createState() => _WordListPageState();
}

class _WordListPageState extends State<WordListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grayishWhite,
      appBar: AppBar(
        backgroundColor: Colors.grey[700],
        title: Text('单词库'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => WordEditPage(
                          callback: () {
                            setState(() {
                              widget.callback();
                            });
                          },
                        )));
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: ListView(children: [
        ListTile(
          // leading: const Icon(Icons.visibility),
          title: Text(
            '已启用',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Divider(height: 0),
        ...?wordList
            .where((e) => !e.isDisabled)
            .map((e) => Dismissible(
                  key: UniqueKey(),
                  onDismissed: (direction) {
                    setState(() {
                      e.isDisabled = true;
                      save();
                    });
                  },
                  background: Container(
                      color: Colors.grey[700],
                      child: const Icon(
                        Icons.arrow_downward,
                        color: Colors.white,
                      )),
                  direction: DismissDirection.endToStart,
                  child: Column(
                    children: [
                      ListTile(
                        tileColor: Colors.white,
                        title: Row(
                          children: [
                            Text(e.writtenForm,
                                style: TextStyle(fontFamily: 'Hiragino Sans')),
                            SizedBox(width: 16),
                            Container(
                              width: 20.0,
                              height: 20.0,
                              alignment: Alignment.center,
                              color: e.color,
                              child: Text(
                                  e.pos.fold(
                                          false,
                                          (previousValue, element) =>
                                              previousValue || element)
                                      ? e.posLabel.characters.first
                                      : '',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Hiragino Sans',
                                  )),
                            ),
                          ],
                        ),
                        subtitle: Text(
                          '${e.hiragana} ' +
                              e.accent.fold(
                                  '',
                                  (str, accent) =>
                                      str + getCircledAccent(accent)),
                          style: TextStyle(fontWeight: FontWeight.w300),
                        ),
                        onTap: () =>
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => WordDetailPage(
                                      word: e,
                                      callback: () {
                                        setState(() {
                                          widget.callback();
                                        });
                                      },
                                    ))),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(width: 16.0),
                            Text(
                              '${e.correctAnswers} / ${e.totalAnswers}',
                              style: TextStyle(
                                  fontFamily: 'DIN Condensed',
                                  fontSize: 24.0,
                                  color:
                                      _WordDetailPageState._getColorFromCount(
                                          [e.correctAnswers, e.totalAnswers])),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        height: 0,
                        endIndent: 96.0,
                      )
                    ],
                  ),
                ))
            .toList()
            .reversed,
        ListTile(
          // leading: const Icon(Icons.visibility_off),
          title: Text(
            '未启用',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Divider(height: 0),
        ...?wordList
            .where((e) => e.isDisabled)
            .map((e) => Dismissible(
                  key: UniqueKey(),
                  confirmDismiss: (direction) async {
                    bool retVal = true;
                    if (direction == DismissDirection.endToStart) {
                      retVal = false;
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: Text('删除这个单词？'),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('取消')),
                                  TextButton(
                                      onPressed: () async {
                                        wordList.remove(e);
                                        await save();
                                        setState(() {
                                          widget.callback();
                                        });
                                        Navigator.of(context).pop();
                                        retVal = true;
                                      },
                                      child: Text('好'))
                                ],
                              ));
                    }
                    return retVal;
                  },
                  onDismissed: (direction) async {
                    if (direction == DismissDirection.startToEnd) {
                      setState(() {
                        e.isDisabled = false;
                        save();
                      });
                    } else {}
                  },
                  background: Container(
                      color: Colors.grey[700],
                      child: const Icon(
                        Icons.arrow_upward,
                        color: Colors.white,
                      )),
                  secondaryBackground: Container(
                      color: Colors.red[800],
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                      )),
                  direction: DismissDirection.horizontal,
                  child: Column(
                    children: [
                      ListTile(
                        tileColor: Colors.white,
                        title: Row(
                          children: [
                            Text(e.writtenForm,
                                style: TextStyle(fontFamily: 'Hiragino Sans')),
                            SizedBox(width: 16),
                            Container(
                              width: 20.0,
                              height: 20.0,
                              alignment: Alignment.center,
                              color: e.color,
                              child: Text(
                                  e.pos.fold(
                                          false,
                                          (previousValue, element) =>
                                              previousValue || element)
                                      ? e.posLabel.characters.first
                                      : '',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Hiragino Sans',
                                  )),
                            ),
                          ],
                        ),
                        subtitle: Text(
                          '${e.hiragana} ' +
                              e.accent.fold(
                                  '',
                                  (str, accent) =>
                                      str + getCircledAccent(accent)),
                          style: TextStyle(fontWeight: FontWeight.w300),
                        ),
                        onTap: () =>
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => WordDetailPage(
                                      word: e,
                                      callback: () {
                                        setState(() {
                                          widget.callback();
                                        });
                                      },
                                    ))),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(width: 16.0),
                            Text(
                              '${e.correctAnswers} / ${e.totalAnswers}',
                              style: TextStyle(
                                  fontFamily: 'DIN Condensed',
                                  fontSize: 24.0,
                                  color:
                                      _WordDetailPageState._getColorFromCount(
                                          [e.correctAnswers, e.totalAnswers])),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        height: 0.0,
                      )
                    ],
                  ),
                ))
            .toList()
            .reversed,
      ]),
    );
  }
}

class WordDetailPage extends StatefulWidget {
  final Word word;
  final VoidCallback callback;

  @override
  WordDetailPage({this.word, @required this.callback});

  @override
  _WordDetailPageState createState() => _WordDetailPageState();
}

class _WordDetailPageState extends State<WordDetailPage> {
  List<double> _avg = [null, null, null, null];

  static Color _getColorFromCount(List<int> countList) {
    assert(countList.length == 2);
    int numCorrect = countList[0], numTotal = countList[1];
    if (numTotal < 2 || numCorrect / numTotal > 0.95) {
      return Colors.green;
    } else if (numCorrect / numTotal > 0.90) {
      return Colors.lightGreen;
    } else if (numCorrect / numTotal > 0.85) {
      return Colors.lime;
    } else if (numCorrect / numTotal > 0.80) {
      return Colors.yellow;
    } else if (numCorrect / numTotal > 0.75) {
      return Colors.orange;
    } else if (numCorrect / numTotal > 0.60) {
      return Colors.red;
    } else {
      return Colors.black;
    }
  }

  Color _getColorFromTime(double seconds) {
    if (seconds < 1) {
      return Colors.green;
    } else if (seconds < 2) {
      return Colors.lightGreen;
    } else if (seconds < 3) {
      return Colors.lime;
    } else if (seconds < 4) {
      return Colors.yellow;
    } else if (seconds < 5) {
      return Colors.orange;
    } else if (seconds < 10) {
      return Colors.red;
    } else {
      return Colors.black;
    }
  }

  Widget _buildDisplayData(String title, String data, Color color) => Column(
        children: [
          Text(data,
              style: TextStyle(
                  fontSize: 36.0, color: color, fontFamily: 'DIN Condensed')),
          Text(title,
              style: TextStyle(fontSize: 15.0, color: Colors.grey[700])),
        ],
      );

  @override
  void initState() {
    super.initState();
    _avg[0] = widget.word.getAverage();
    _avg[1] = widget.word.getAverage(mode: Mode.read);
    _avg[2] = widget.word.getAverage(mode: Mode.write);
    _avg[3] = widget.word.getAverage(mode: Mode.output);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: grayishWhite,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor:
                  widget.word.isDisabled ? Colors.grey[700] : widget.word.color,
              forceElevated: true,
              title: Text(
                widget.word.writtenForm,
                style: TextStyle(fontFamily: 'Hiragino Sans'),
              ),
              pinned: true,
              actions: [
                TextButton(
                  child: Text('编辑', style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => WordEditPage(
                              callback: () {
                                setState(() {});
                                widget.callback();
                              },
                              word: widget.word,
                            )));
                  },
                )
              ],
              expandedHeight: 360.0,
              flexibleSpace: FlexibleSpaceBar(
                background: Center(
                  child: Column(
                    children: [
                      SizedBox(height: 128.0),
                      Hero(
                        tag: 1,
                        child: Material(
                          color: const Color(0),
                          child: Text(widget.word.writtenForm,
                              style: TextStyle(
                                  fontSize: 36.0,
                                  color: Colors.white,
                                  fontFamily: 'Hiragino Sans',
                                  fontWeight: FontWeight.w600)),
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Hero(
                        tag: 2,
                        child: Material(
                          color: const Color(0),
                          child: Text(
                              widget.word.hiragana +
                                  widget.word.accent.fold(
                                      '',
                                      (s, accent) =>
                                          s + getCircledAccent(accent)),
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.white,
                                fontFamily: 'Hiragino Sans',
                              )),
                        ),
                      ),
                      SizedBox(height: 32.0),
                      Hero(
                        tag: 3,
                        child: Material(
                          color: const Color(0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                widget.word.posLabel,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600),
                              ),
                              SizedBox(width: 16.0),
                              Text(widget.word.meaning,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w300)),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 48.0),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: IconButton(
                            icon: Icon(widget.word.isDisabled
                                ? Icons.visibility_off
                                : Icons.visibility),
                            color: const Color(0x9fffffff),
                            iconSize: 32.0,
                            onPressed: () async {
                              setState(() {
                                widget.word.isDisabled =
                                    !widget.word.isDisabled;
                              });
                              widget.callback();
                              await save();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverList(
                delegate: SliverChildListDelegate([
              SizedBox(height: 16.0),
              ListTile(
                title: Text('用时统计'),
                leading: const Icon(Icons.timer),
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildDisplayData(
                      '书写形式',
                      _avg[1] == null ? 'N/A' : '${_avg[1]} s ',
                      _avg[1] == null
                          ? Colors.grey
                          : _getColorFromTime(_avg[1])),
                  _buildDisplayData(
                      '平假名',
                      _avg[2] == null ? 'N/A' : '${_avg[2]} s ',
                      _avg[2] == null
                          ? Colors.grey
                          : _getColorFromTime(_avg[2])),
                  _buildDisplayData(
                      '语义',
                      _avg[3] == null ? 'N/A' : '${_avg[3]} s ',
                      _avg[3] == null
                          ? Colors.grey
                          : _getColorFromTime(_avg[3])),
                  _buildDisplayData(
                      '总数',
                      _avg[0] == null ? 'N/A' : '${_avg[0]} s ',
                      _avg[0] == null
                          ? Colors.grey
                          : _getColorFromTime(_avg[0])),
                ],
              ),
              SizedBox(height: 32.0),
              ListTile(
                title: Text('正确率统计'),
                leading: const Icon(Icons.rule),
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildDisplayData(
                      '书写形式',
                      widget.word.getCount(mode: Mode.read),
                      _getColorFromCount(
                          widget.word.getCountList(mode: Mode.read))),
                  _buildDisplayData(
                      '平假名',
                      widget.word.getCount(mode: Mode.write),
                      _getColorFromCount(
                          widget.word.getCountList(mode: Mode.write))),
                  _buildDisplayData(
                      '语义',
                      widget.word.getCount(mode: Mode.output),
                      _getColorFromCount(
                          widget.word.getCountList(mode: Mode.output))),
                  _buildDisplayData('总数', widget.word.getCount(),
                      _getColorFromCount(widget.word.getCountList())),
                ],
              ),
              SizedBox(height: 32.0),
              ListTile(
                title: Text('答题记录'),
                leading: const Icon(Icons.receipt_long),
              ),
              SizedBox(height: 16.0),
              DataTable(
                  columns: [
                    DataColumn(label: Text('时间')),
                    DataColumn(label: Text('类型')),
                    DataColumn(label: Text('用时'))
                  ],
                  rows: widget.word.answers
                      .map((e) => DataRow(cells: [
                            DataCell(Text(e.time.toString())),
                            DataCell(Builder(
                              builder: (context) {
                                switch (e.type) {
                                  case Mode.read:
                                    return Text('书写形式');
                                  case Mode.write:
                                    return Text('平假名');
                                  case Mode.output:
                                    return Text('语义');
                                  default:
                                    return Text('未知');
                                }
                              },
                            )),
                            DataCell(Text(e.duration.toString()))
                          ]))
                      .toList())
            ])),
          ],
        ));
  }
}

class WordEditPage extends StatefulWidget {
  final Word word;
  final VoidCallback callback;

  @override
  WordEditPage({this.word, @required this.callback});

  @override
  _WordEditPageState createState() => _WordEditPageState(word);
}

class _WordEditPageState extends State<WordEditPage> {
  Word word;

  final _formKey = GlobalKey<FormState>();
  final _hiraganaController = TextEditingController();
  final _writtenFormController = TextEditingController();
  final _tempAccent = <int>[];
  final _tempPos = <bool>[];

  @override
  _WordEditPageState(this.word);

  @override
  void initState() {
    super.initState();
    if (word == null) word = Word();
    _hiraganaController.text = word.hiragana;
    _writtenFormController.text = word.writtenForm;
    _tempAccent.addAll(word.accent);
    _tempPos.addAll(word.pos);
  }

  @override
  void dispose() {
    _hiraganaController.dispose();
    _writtenFormController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _tempAccentList =
        List<int>.filled(_hiraganaController.text.length + 1, null);
    for (int i = 0; i < _tempAccent.length; i++)
      _tempAccentList[_tempAccent[i]] = i + 1;

    return Scaffold(
        backgroundColor: grayishWhite,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: word.isDisabled
                  ? Colors.grey[700]
                  : (_tempPos.indexOf(true) < 0
                      ? Colors.grey
                      : colors[_tempPos.indexOf(true)]),
              forceElevated: true,
              title: Text(
                widget.word == null ? '新出単語' : word.writtenForm,
                style: TextStyle(fontFamily: 'Hiragino Sans'),
              ),
              pinned: true,
              actions: [
                TextButton(
                    child: Text('保存', style: TextStyle(color: Colors.white)),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        word.accent = _tempAccent;
                        word.pos = _tempPos;
                        if (widget.word == null) wordList.add(word);
                        await save();
                        widget.callback();
                        Navigator.of(context).pop();
                      }
                    })
              ],
              expandedHeight: widget.word == null ? 0 : 360.0,
              flexibleSpace: FlexibleSpaceBar(
                background: Center(
                  child: Column(
                    children: [
                      SizedBox(height: 128.0),
                      Hero(
                        tag: 1,
                        child: Material(
                          color: const Color(0),
                          child: Text(word.writtenForm,
                              style: TextStyle(
                                fontSize: 36.0,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Hiragino Sans',
                              )),
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Hero(
                        tag: 2,
                        child: Material(
                          color: const Color(0),
                          child: Text(
                              word.hiragana +
                                  word.accent.fold(
                                      '',
                                      (s, accent) =>
                                          s + getCircledAccent(accent)),
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.white,
                                fontFamily: 'Hiragino Sans',
                              )),
                        ),
                      ),
                      SizedBox(height: 32.0),
                      Hero(
                        tag: 3,
                        child: Material(
                          color: const Color(0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                word.posLabel,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600),
                              ),
                              SizedBox(width: 16.0),
                              Text(word.meaning,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w300)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Form(
              key: _formKey,
              child: SliverList(
                  delegate: SliverChildListDelegate([
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 36.0),
                  child: TextFormField(
                    style: TextStyle(
                      fontFamily: 'Hiragino Sans',
                    ),
                    controller: _writtenFormController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      labelText: '书写形式',
                      labelStyle: TextStyle(fontFamily: ''),
                    ),
                    onSaved: (str) => word.writtenForm = str,
                    validator: (str) => str.isEmpty ? '书写形式不能为空。' : null,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 36.0),
                  child: TextFormField(
                    controller: _hiraganaController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(labelText: '平假名'),
                    onSaved: (str) => word.hiragana = str,
                    onEditingComplete: () {
                      setState(() {});
                    },
                    validator: (str) => str.isEmpty ? '平假名不能为空。' : null,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 36.0),
                  child: TextFormField(
                    initialValue: word.meaning,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                        labelText: '释义', helperText: '不同义项用分号隔开，如“寄；送”'),
                    onSaved: (str) => word.meaning = str,
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 36.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              '声调',
                              style: TextStyle(
                                  fontSize: 12.0,
                                  color: ThemeData.light().hintColor),
                            ),
                          ],
                        ),
                        SizedBox(height: 4.0),
                        SizedBox(
                          width: double.infinity,
                          child: Wrap(
                              spacing: 16.0,
                              runSpacing: 16.0,
                              children: _tempAccentList
                                  .asMap()
                                  .entries
                                  .map((e) => AccentChip(
                                        isSelected: e.value != null,
                                        accent: e.key,
                                        priority: e.value,
                                        onTap: () {
                                          if (e.value == null) {
                                            setState(() {
                                              _tempAccent.add(e.key);
                                            });
                                          } else {
                                            setState(() {
                                              _tempAccent.remove(e.key);
                                            });
                                          } // TODO Use temporary object
                                        },
                                      ))
                                  .toList()),
                        )
                      ],
                    )),
                Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 36.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              '词类',
                              style: TextStyle(
                                  fontSize: 12.0,
                                  color: ThemeData.light().hintColor),
                            ),
                          ],
                        ),
                        SizedBox(height: 4.0),
                        SizedBox(
                          width: double.infinity,
                          child: Wrap(
                            spacing: 16.0,
                            runSpacing: 16.0,
                            children: Pos.values
                                .map((e) => PosChip(
                                      isSelected: _tempPos[e.index],
                                      pos: e,
                                      onTap: () {
                                        setState(() {
                                          _tempPos[e.index] =
                                              !_tempPos[e.index];
                                        });
                                      },
                                    ))
                                .toList(),
                          ),
                        ),
                      ],
                    )),
              ])),
            )
          ],
        ));
  }
}

/// A chip for an accent. Inspired by Chip.
class AccentChip extends StatelessWidget {
  final bool isSelected;
  final int accent;
  final int priority;
  final void Function() onTap;

  @override
  AccentChip(
      {@required this.isSelected,
      @required this.accent,
      this.priority,
      this.onTap})
      : assert(isSelected != null &&
            accent != null &&
            accent >= 0 &&
            !(isSelected && (priority == null || priority <= 0)));

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        height: 32.0,
        width: 32.0,
        decoration: BoxDecoration(
            border: isSelected ? null : Border.all(width: 0.5),
            borderRadius: BorderRadius.circular(4.0),
            color: isSelected
                ? Color.lerp(Colors.grey[200], Colors.grey[800], 1.0 / priority)
                : null),
        child: Text(
          accent.toString(),
          style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16.0,
              color: isSelected ? grayishWhite : Colors.black),
        ),
      ),
    );
  }
}

/// A chip for a part of speech. Inspired by Chip.
class PosChip extends StatelessWidget {
  final bool isSelected;
  final Pos pos;
  final void Function() onTap;

  @override
  PosChip({@required this.isSelected, @required this.pos, this.onTap})
      : assert(isSelected != null && pos != null);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
        decoration: BoxDecoration(
            border: isSelected ? null : Border.all(width: 0.5),
            borderRadius: BorderRadius.circular(4.0),
            color: isSelected ? colors[pos.index] : null),
        child: Text(
          getPosChinese(pos),
          style: TextStyle(
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.normal,
              fontSize: 14.0,
              color: isSelected ? grayishWhite : Colors.black),
        ),
      ),
    );
  }
}
