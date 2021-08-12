import 'package:flutter/material.dart';
import 'package:tango_helper/home_screen.dart';
import 'package:tango_helper/non_ui.dart';

void main() async {
  await init();
  runApp(TangoHelper());
}

class TangoHelper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}
