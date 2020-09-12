import 'package:flutter/material.dart';

class TimeTablePage extends StatefulWidget {
  @override
  _TimeTablePageState createState() => _TimeTablePageState();
}

class _TimeTablePageState extends State<TimeTablePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      initialIndex: 0,
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            width: double.infinity,
            color: Colors.blue,
            child: TabBar(
              labelColor: Colors.white,
              unselectedLabelColor: Colors.blue[900],
              indicatorWeight: 1,
              isScrollable: true,
              labelStyle: TextStyle(fontSize: 14),
              tabs: <Widget>[
                Tab(text: '星期一'),
                Tab(text: '星期二'),
                Tab(text: '星期三'),
                Tab(text: '星期四'),
                Tab(text: '星期五'),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: TabBarView(
              children: [
                Center(
                  child: Text('星期一'),
                ),
                Center(
                  child: Text('星期二'),
                ),
                Center(
                  child: Text('星期三'),
                ),
                Center(
                  child: Text('星期四'),
                ),
                Center(
                  child: Text('星期五'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
