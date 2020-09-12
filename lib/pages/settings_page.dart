import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('設定'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 20),
            child: Text('版本資訊'),
          ),
          ListTile(
            onTap: () {},
            title: Text('應用程式版本'),
            subtitle: Text('0.1.6'),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
            child: Text('系統功能'),
          ),
          ListTile(
            title: Text('深色主題'),
            trailing: Switch(
              value: _isDarkMode,
              onChanged: (value) {
                setState(() {
                  _isDarkMode = !_isDarkMode;
                });
              },
            ),
          ),
          ListTile(
            onTap: () {},
            title: Text('重新整理數據'),
          ),
          ListTile(
            onTap: () {},
            title: Text('登出'),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
            child: Text('關於高大校務通'),
          ),
          ListTile(
            onTap: () {},
            title: Text('分享給朋友'),
          ),
          ListTile(
            onTap: () {
              showAboutDialog(
                  context: context,
                  applicationIcon: Image.asset(
                    'assets/images/icon/nukplus_icon.png',
                    width: 50,
                  ),
                  applicationVersion: '0.1.6',
                  applicationLegalese: 'NUK+ APP\n作者：JiaxuanTW');
            },
            title: Text('關於'),
          ),
        ],
      ),
    );
  }
}
