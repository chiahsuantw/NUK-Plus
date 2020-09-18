import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class TimeTablePage extends StatefulWidget {
  @override
  _TimeTablePageState createState() => _TimeTablePageState();
}

class _TimeTablePageState extends State<TimeTablePage> {
  Future<dynamic> _getTable() async {
    Directory directory = await getApplicationDocumentsDirectory();
    var courseTable = await json.decode(
        File('${directory.path}/courseTableData.json').readAsStringSync());
    return courseTable;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getTable(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Text('${snapshot.error}');
          } else {
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
                        buildCourseTable(snapshot, 1),
                        buildCourseTable(snapshot, 2),
                        buildCourseTable(snapshot, 3),
                        buildCourseTable(snapshot, 4),
                        buildCourseTable(snapshot, 5),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        } else {
          return LinearProgressIndicator();
        }
      },
    );
  }

  ListView buildCourseTable(AsyncSnapshot snapshot, int day) {
    List<String> beginTime = [
      '07:05',
      '08:05',
      '09:05',
      '10:10',
      '11:10',
      '13:10',
      '14:10',
      '15:15',
      '16:20',
      '17:20',
      '18:20',
      '19:15',
      '20:10',
      '21:05',
    ];
    List<String> endTime = [
      '07:55',
      '08:55',
      '09:55',
      '11:00',
      '12:00',
      '14:00',
      '15:00',
      '16:05',
      '17:10',
      '18:10',
      '19:10',
      '20:05',
      '21:00',
      '21:55',
    ];

    void _showCourseDetail(snapshot, index, day) {
      showModalBottomSheet(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          context: context,
          builder: (context) {
            return Container(
              height: 350,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      snapshot.data[index]['name'],
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Divider(
                    indent: 20,
                    endIndent: 20,
                    height: 0,
                    color: Colors.grey,
                  ),
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.all(24),
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.access_time),
                            SizedBox(width: 4),
                            Column(
                              children: [
                                Text(
                                  '時間 :',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 5),
                              ],
                            ),
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Text(
                                    beginTime[int.parse(snapshot.data[index]
                                            ['time'][day][1][0])] +
                                        ' ～ ' +
                                        endTime[int.parse(snapshot.data[index]
                                                ['time'][day][1][0]) +
                                            snapshot.data[index]['time'][day][1]
                                                .length -
                                            1],
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                                SizedBox(height: 5),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.timer),
                            SizedBox(width: 4),
                            Column(
                              children: [
                                Text(
                                  '堂數 :',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 5),
                              ],
                            ),
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Text(
                                    snapshot.data[index]['time'][day][1].length
                                        .toString(),
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                                SizedBox(height: 5),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.perm_identity),
                            SizedBox(width: 4),
                            Column(
                              children: [
                                Text(
                                  '老師 :',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 5),
                              ],
                            ),
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Text(
                                    snapshot.data[index]['teacher'],
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                                SizedBox(height: 5),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.room),
                            SizedBox(width: 4),
                            Column(
                              children: [
                                Text(
                                  '地點 :',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 5),
                              ],
                            ),
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Text(
                                    snapshot.data[index]['location'][0],
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                                SizedBox(height: 5),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.pie_chart_outlined),
                            SizedBox(width: 4),
                            Column(
                              children: [
                                Text(
                                  '學分 :',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 5),
                              ],
                            ),
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Text(
                                    snapshot.data[index]['credit'].toString(),
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                                SizedBox(height: 5),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          });
    }

    return ListView(
      children: ListTile.divideTiles(
        context: context,
        tiles: [
          for (int period = 0; period < 14; period++)
            for (int courseIndex = 0;
                courseIndex < snapshot.data.length;
                courseIndex++)
              for (int j = 0;
                  j < snapshot.data[courseIndex]['time'].length;
                  j++)
                if (period.toString() ==
                    snapshot.data[courseIndex]['time'][j][1][0])
                  if (snapshot.data[courseIndex]['time'][j][0] == day)
                    ListTile(
                      onLongPress: () =>
                          _showCourseDetail(snapshot, courseIndex, j),
                      leading: Text(
                        beginTime[int.parse(
                            snapshot.data[courseIndex]['time'][j][1][0])],
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      title: Text(
                        snapshot.data[courseIndex]['name'],
                        style: TextStyle(fontSize: 22),
                      ),
                      subtitle: Text(snapshot.data[courseIndex]['location'][0]),
                    ),
        ],
      ).toList(),
    );
  }
}
