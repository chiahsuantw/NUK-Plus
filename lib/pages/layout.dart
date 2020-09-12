import 'package:flutter/material.dart';

import 'news_page.dart';
import 'timetable.dart';
import 'my_credits.dart';
import 'todo_page.dart';
import 'about_page.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  var _index = 0;

  List<String> _appbarTitle = [
    '主頁面',
    '個人課表',
    '我的學分',
    '代辦事項',
    '個人資訊',
  ];

  List<Widget> _bodyWidget = [
    NewsPage(),
    TimeTablePage(),
    MyCreditsPage(),
    ToDoPage(),
    AboutPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _index != 0
          ? AppBar(
              title: Text(_appbarTitle[_index]),
              actions: _index == 1
                  ? [
                      IconButton(
                        icon: Icon(Icons.refresh),
                        onPressed: () {},
                      )
                    ]
                  : null,
            )
          : PreferredSize(
              preferredSize: Size.fromHeight(0.0),
              child: Container(
                color: Colors.blue,
              ),
            ),
      body: IndexedStack(
        index: _index,
        children: _bodyWidget,
      ),
      floatingActionButton: _index == 3
          ? FloatingActionButton(
              onPressed: () {},
              child: Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('最新消息'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.class_),
            title: Text('個人課表'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.equalizer),
            title: Text('我的學分'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            title: Text('代辦事項'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text('個人資料'),
          ),
        ],
        currentIndex: _index,
        onTap: _onItemTapped,
      ),
    );
  }
}
