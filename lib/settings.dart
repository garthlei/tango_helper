import 'package:flutter/material.dart';
import 'package:tango_helper/non_ui.dart';
import 'package:tango_helper/theme.dart';

/// Settings-related widgets.

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: grayishWhite,
        appBar: AppBar(
          backgroundColor: Colors.grey[700],
          // shadowColor: const Color(0),
          // leading: IconButton(
          //     tooltip: 'Back',
          //     icon: BackButtonIcon(),
          //     color: darkColor,
          //     onPressed: () => Navigator.of(context).pop()),
          title: Text('设置'),
        ),
        body: ListView(
          children: [
            ListTile(
                title: Text(
              '记忆设置',
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
            Divider(height: 0),
            ListTile(
              tileColor: Colors.white,
              onTap: () async {
                setState(() {
                  mode = Mode.read;
                });
                await save();
              },
              title: Text('展示一般写法'),
              trailing:
                  mode == Mode.read ? const Icon(Icons.check) : SizedBox(),
            ),
            Divider(height: 0),
            ListTile(
              tileColor: Colors.white,
              onTap: () async {
                setState(() {
                  mode = Mode.write;
                });
                await save();
              },
              title: Text('展示平假名'),
              trailing:
                  mode == Mode.write ? const Icon(Icons.check) : SizedBox(),
            ),
            Divider(height: 0),
            ListTile(
              tileColor: Colors.white,
              onTap: () async {
                setState(() {
                  mode = Mode.output;
                });
                await save();
              },
              title: Text('展示语义'),
              trailing:
                  mode == Mode.output ? const Icon(Icons.check) : SizedBox(),
            ),
            Divider(height: 0),
            ListTile(
              tileColor: Colors.white,
              onTap: () async {
                setState(() {
                  mode = Mode.mixed;
                });
                await save();
              },
              title: Text('混合模式'),
              trailing:
                  mode == Mode.mixed ? const Icon(Icons.check) : SizedBox(),
            ),
          ],
        ));
  }
}

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
