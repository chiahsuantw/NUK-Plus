import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nuk_course/pages/settings_page.dart';
import 'package:nuk_course/pages/webview_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  Future<void> _logoutUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('Account');
    prefs.remove('Password');
    prefs.remove('isInit');
  }

  Future<void> _deleteFiles() async {
    Directory directory = await getApplicationDocumentsDirectory();

    final file1 = File('${directory.path}/studentInfoData.json');
    final file2 = File('${directory.path}/courseData.json');
    final file3 = File('${directory.path}/progressData.json');
    final file4 = File('${directory.path}/courseTableData.json');

    file1.delete(recursive: false);
    file2.delete(recursive: false);
    file3.delete(recursive: false);
    file4.delete(recursive: false);
  }

  Future<dynamic> _getInfo() async {
    var data = new Map();
    double nowTotalPassCredits = 0.0;
    Directory directory = await getApplicationDocumentsDirectory();
    var studentInfoData = await json.decode(
        File('${directory.path}/studentInfoData.json').readAsStringSync());
    var progressData = await json
        .decode(File('${directory.path}/progressData.json').readAsStringSync());

    //加總目前已修學分數
    progressData.forEach((key, value) => nowTotalPassCredits += value);

    data['dept'] = studentInfoData['student_aca'];
    data['name'] = studentInfoData['student_name'];
    data['lowPass'] = studentInfoData['最低畢業學分數']
        .substring(0, studentInfoData['最低畢業學分數'].length - 3);
    // data['deptNecessary'] = studentInfoData['系所必修學分數']
    //     .substring(0, studentInfoData['系所必修學分數'].length - 3);
    // data['deptOptional'] = studentInfoData['系所選修學分數']
    //     .substring(0, studentInfoData['系所選修學分數'].length - 3);
    data['nowPass'] = nowTotalPassCredits;
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        FutureBuilder(
          future: _getInfo(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Text('Error:${snapshot.error}');
              } else {
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 75,
                            height: 75,
                            child: CircleAvatar(
                              backgroundColor: Colors.indigo,
                              child: Image.asset(
                                  'assets/images/avatar/avatar1.png'),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                snapshot.data['name'],
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                snapshot.data['dept'],
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(height: 25),
                      Flex(
                        direction: Axis.horizontal,
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    blurRadius: 50,
                                    spreadRadius: -30,
                                  ),
                                ],
                              ),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        snapshot.data['nowPass'].toString(),
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 26,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        '目前已修學分數',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 4),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    blurRadius: 50,
                                    spreadRadius: -30,
                                  ),
                                ],
                              ),
                              child: Card(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        snapshot.data['lowPass'],
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 26,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        '最低畢業學分數',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }
            } else {
              return LinearProgressIndicator();
            }
          },
        ),
        InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => WebviewPage(
                          url: 'https://nukcourse.herokuapp.com/',
                        )));
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
            child: Row(
              children: [
                Image.asset(
                  'assets/images/icon/nukcourse_icon.png',
                  width: 26,
                ),
                SizedBox(width: 12),
                Column(
                  children: [
                    Text(
                      '高大選課工具',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 4),
                  ],
                ),
              ],
            ),
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => WebviewPage(
                          url: 'https://www.nuk.edu.tw/',
                        )));
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
            child: Row(
              children: [
                Icon(
                  Icons.language,
                  color: Colors.cyan,
                ),
                SizedBox(width: 12),
                Column(
                  children: [
                    Text(
                      '國立高雄大學官網',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 4),
                  ],
                ),
              ],
            ),
          ),
        ),
        InkWell(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: Colors.cyan,
                ),
                SizedBox(width: 12),
                Column(
                  children: [
                    Text(
                      '行事曆',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 4),
                  ],
                ),
              ],
            ),
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SettingsPage()));
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
            child: Row(
              children: [
                Icon(
                  Icons.settings,
                  color: Colors.cyan,
                ),
                SizedBox(width: 12),
                Column(
                  children: [
                    Text(
                      '設定',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 4),
                  ],
                ),
              ],
            ),
          ),
        ),
        InkWell(
          onTap: () {
            _logoutUser();
            _deleteFiles();
            Navigator.pushReplacementNamed(context, '/login');
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
            child: Row(
              children: [
                Icon(
                  Icons.exit_to_app,
                  color: Colors.cyan,
                ),
                SizedBox(width: 12),
                Column(
                  children: [
                    Text(
                      '登出',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 4),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
