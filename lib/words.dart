import 'package:flutter/material.dart';
import 'package:tango_helper/memorize.dart';
import 'package:tango_helper/non_ui.dart';
import 'package:tango_helper/settings.dart';
import 'package:tango_helper/theme.dart';

/// Widgets related to words.

class WordListPage extends StatefulWidget {
  @override
  _WordListPageState createState() => _WordListPageState();
}

class _WordListPageState extends State<WordListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightColor,
      bottomNavigationBar: BottomAppBar(
        color: darkColor,
        shape: AutomaticNotchedShape(RoundedRectangleBorder(), CircleBorder()),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.menu),
              iconSize: 36.0,
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ModeSelectorPage()));
              },
              color: lightColor,
            ),
            Spacer(),
            IconButton(
                icon: const Icon(Icons.add),
                iconSize: 36.0,
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => WordEditPage(callback: () {
                            setState(() {});
                          })));
                },
                color: lightColor),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: midColor,
        child: const Icon(Icons.bolt, size: 36.0),
        onPressed: wordList.any((word) => !word.isDisabled)
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: ListView(children: [
        Container(
          color: darkColor,
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            '已启用单词',
            style: TextStyle(color: lightColor),
          ),
        ),
        ...?wordList
            .where((e) => !e.isDisabled)
            .map((e) => ListTile(
                  title: Text(e.writtenForm),
                  subtitle: Text('${e.hiragana}' +
                      e.accent.fold(
                          '', (str, accent) => str + getCircledAccent(accent))),
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
                      Icon(e.isDisabled ? Icons.visibility_off : null),
                      SizedBox(width: 16.0),
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
            .toList()
            .reversed,
        Container(
          color: darkColor,
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            '未启用单词',
            style: TextStyle(color: lightColor),
          ),
        ),
        ...?wordList
            .where((e) => e.isDisabled)
            .map((e) => ListTile(
                  title: Text(e.writtenForm),
                  subtitle: Text('${e.hiragana}' +
                      e.accent.fold(
                          '', (str, accent) => str + getCircledAccent(accent))),
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
                      Icon(e.isDisabled ? Icons.visibility_off : null),
                      SizedBox(width: 16.0),
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
  List<double> _avg = List(4);
  bool _isTimeShown = true;

  Widget _buildText(String text, double size) =>
      Text(text, style: TextStyle(color: lightColor, fontSize: size));

  Widget _buildTableLine(String text1, String text2) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildText(text1, 18.0),
            _buildText(text2, 18.0),
          ],
        ),
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
          '单词详情',
          style: TextStyle(color: darkColor),
        ),
        actions: [
          TextButton(
            child: Text('编辑', style: TextStyle(color: darkColor)),
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
      ),
      body: Column(
        children: [
          Center(
            child: Column(
              children: [
                SizedBox(height: 64.0),
                Text(widget.word.writtenForm,
                    style: TextStyle(
                      fontSize:
                          widget.word.writtenForm.length < 5 ? 72.0 : 64.0,
                      fontFamily: 'JapaneseFont',
                    )),
                SizedBox(height: 16.0),
                Text(
                    widget.word.hiragana +
                        widget.word.accent.fold(
                            '', (s, accent) => s + getCircledAccent(accent)),
                    style:
                        TextStyle(fontSize: 36.0, fontFamily: 'JapaneseFont')),
                SizedBox(height: 32.0),
                RichText(
                    text: TextSpan(
                        text: getPosLabel(widget.word.pos),
                        children: [
                          TextSpan(
                              text: widget.word.meaning,
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
                    alignment: AlignmentDirectional.bottomStart,
                    children: [
                      ListView(
                        children: [
                          SizedBox(height: 16.0),
                          _buildTableLine(
                              '回答记录',
                              _isTimeShown
                                  ? (_avg[0] == null
                                      ? '数据暂缺'
                                      : '平均 ${_avg[0]} s ')
                                  : widget.word.getCount()),
                          _buildTableLine(
                              '　展示书写形式',
                              _isTimeShown
                                  ? (_avg[1] == null
                                      ? '数据暂缺'
                                      : '平均 ${_avg[1]} s ')
                                  : widget.word.getCount(mode: Mode.read)),
                          _buildTableLine(
                              '　展示平假名',
                              _isTimeShown
                                  ? (_avg[2] == null
                                      ? '数据暂缺'
                                      : '平均 ${_avg[2]} s ')
                                  : widget.word.getCount(mode: Mode.write)),
                          _buildTableLine(
                              '　展示语义',
                              _isTimeShown
                                  ? (_avg[3] == null
                                      ? '数据暂缺'
                                      : '平均 ${_avg[3]} s ')
                                  : widget.word.getCount(mode: Mode.output)),
                          // TODO Avoid this kind of trinary
                          // operators.
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon:
                                      const Icon(Icons.swap_horizontal_circle),
                                  color: lightColor,
                                  iconSize: 64.0,
                                  onPressed: () {
                                    setState(() {
                                      _isTimeShown = !_isTimeShown;
                                    });
                                  },
                                ),

                                // TODO Use real info.
                                _buildText(_isTimeShown ? '显示次数' : '显示时间', 16.0)
                              ],
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(widget.word.isDisabled
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                  color: lightColor,
                                  iconSize: 64.0,
                                  onPressed: () async {
                                    setState(() {
                                      widget.word.isDisabled =
                                          !widget.word.isDisabled;
                                    });
                                    widget.callback();
                                    await save();
                                  },
                                ),
                                _buildText(
                                    widget.word.isDisabled ? '启用' : '禁用', 16.0)
                              ],
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.more_horiz),
                                  color: lightColor,
                                  iconSize: 64.0,
                                  onPressed: () {},
                                ),
                                _buildText('详情', 16.0)
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                )),
          )
        ],
      ),
    );
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
  final _tempAccent = List<int>();
  final _tempPos = List<bool>();

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
    final _tempAccentList = List<int>(_hiraganaController.text.length + 1);
    for (int i = 0; i < _tempAccent.length; i++)
      _tempAccentList[_tempAccent[i]] = i + 1;

    return Scaffold(
      backgroundColor: lightColor,
      appBar: AppBar(
        backgroundColor: lightColor,
        shadowColor: const Color(0),
        leading: IconButton(
            tooltip: 'Back',
            icon: BackButtonIcon(),
            color: darkColor,
            onPressed: () => Navigator.of(context).pop()),
        title: Text(widget.word == null ? '新单词' : '编辑单词',
            style: TextStyle(color: darkColor)),
        actions: [
          TextButton(
            child: Text(
              '保存',
              style: TextStyle(color: darkColor),
            ),
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
            },
          )
        ],
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  controller: _writtenFormController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(labelText: '书写形式'),
                  onSaved: (str) => word.writtenForm = str,
                  validator: (str) => str.isEmpty ? '书写形式不能为空。' : null,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  initialValue: word.meaning,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                      labelText: '释义', helperText: '不同义项用分号隔开，如“寄；送”'),
                  onSaved: (str) => word.meaning = str,
                ),
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                                    text: getPosChinese(e),
                                    onTap: () {
                                      setState(() {
                                        _tempPos[e.index] = !_tempPos[e.index];
                                      });
                                    },
                                  ))
                              .toList(),
                        ),
                      ),
                    ],
                  )),

              // TODO Use real POS info.
            ],
          ),
        ),
      ),
    );
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
            border:
                isSelected ? null : Border.all(width: 0.5, color: darkColor),
            borderRadius: BorderRadius.circular(4.0),
            color: isSelected
                ? Color.lerp(lightColor, darkColor, 1.0 / priority)
                : null),
        child: Text(
          accent.toString(),
          style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16.0,
              color: isSelected ? lightColor : Colors.black),
        ),
      ),
    );
  }
}

/// A chip for a part of speech. Inspired by Chip.
class PosChip extends StatelessWidget {
  final bool isSelected;
  final String text;
  final void Function() onTap;

  @override
  PosChip({@required this.isSelected, @required this.text, this.onTap})
      : assert(isSelected != null && text != null);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
        decoration: BoxDecoration(
            border:
                isSelected ? null : Border.all(width: 0.5, color: darkColor),
            borderRadius: BorderRadius.circular(4.0),
            color: isSelected ? darkColor : null),
        child: Text(
          text,
          style: TextStyle(
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.normal,
              fontSize: 14.0,
              color: isSelected ? lightColor : Colors.black),
        ),
      ),
    );
  }
}
