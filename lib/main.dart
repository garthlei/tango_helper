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
      // locale: Locale('zh', 'CN'),
      // supportedLocales: [
      //   const Locale.fromSubtags(languageCode: 'zh'),
      //   const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'),
      //   const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
      //   const Locale.fromSubtags(
      //       languageCode: 'zh', scriptCode: 'Hans', countryCode: 'CN'),
      //   const Locale.fromSubtags(
      //       languageCode: 'zh', scriptCode: 'Hant', countryCode: 'TW'),
      //   const Locale.fromSubtags(
      //       languageCode: 'zh', scriptCode: 'Hant', countryCode: 'HK'),
      // ],
    );
  }
}
