import 'package:flutter/material.dart';
import 'package:tango_helper/non_ui.dart';
import 'package:tango_helper/words.dart';

void main() async {
  await init();
  runApp(TangoHelper());
}

class TangoHelper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WordListPage(),
    );
  }
}