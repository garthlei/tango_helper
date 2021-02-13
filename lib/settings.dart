import 'package:flutter/material.dart';
import 'package:tango_helper/non_ui.dart';
import 'package:tango_helper/theme.dart';

/// Settings-related widgets.

class ModeSelectorPage extends StatefulWidget {
  @override
  _ModeSelectorPageState createState() => _ModeSelectorPageState();
}

class _ModeSelectorPageState extends State<ModeSelectorPage> {
  @override
  Widget build(BuildContext context) {
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
          title: Text('模式选择', style: TextStyle(color: darkColor)),
        ),
        body: ListView(
          children: [
            RadioListTile(
              value: Mode.read,
              groupValue: mode,
              onChanged: (newValue) async {
                setState(() {
                  mode = newValue;
                });
                await save();
              },
              title: Text('展示一般写法'),
            ),
            RadioListTile(
              value: Mode.write,
              groupValue: mode,
              onChanged: (newValue) async {
                setState(() {
                  mode = newValue;
                });
                await save();
              },
              title: Text('展示平假名'),
            ),
            RadioListTile(
              value: Mode.output,
              groupValue: mode,
              onChanged: (newValue) async {
                setState(() {
                  mode = newValue;
                });
                await save();
              },
              title: Text('展示语义'),
            ),
            RadioListTile(
              value: Mode.mixed,
              groupValue: mode,
              onChanged: (newValue) async {
                setState(() {
                  mode = newValue;
                });
                await save();
              },
              title: Text('混合模式'),
            ),
          ],
        ));
  }
}
