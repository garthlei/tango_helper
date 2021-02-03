import 'package:flutter/material.dart';
import 'package:tango_helper/non_ui.dart';

/// Settings-related widgets.

class ModeSelectorPage extends StatefulWidget {
  @override
  _ModeSelectorPageState createState() => _ModeSelectorPageState();
}

class _ModeSelectorPageState extends State<ModeSelectorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('模式选择'),
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
