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
            Divider(height: 0),
            SizedBox(height: 16),
            Divider(height: 0),
            SwitchListTile(
                title: Text('使用工作集'),
                tileColor: Colors.white,
                value: enableWorkSet,
                onChanged: (val) async {
                  setState(() {
                    enableWorkSet = val;
                  });
                  save();
                }),
            Divider(height: 0),
            SizedBox(height: 16),
            Divider(height: 0),
            SwitchListTile(
                title: Text('开发者模式'),
                tileColor: Colors.white,
                value: enableDebug,
                onChanged: (val) async {
                  setState(() {
                    enableDebug = val;
                  });
                  save();
                }),
            Divider(height: 0),
          ],
        ));
  }
}
