import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:path_provider/path_provider.dart';

class MyCreditsPage extends StatefulWidget {
  @override
  _MyCreditsPageState createState() => _MyCreditsPageState();
}

class _MyCreditsPageState extends State<MyCreditsPage> {
  Future<dynamic> _getData() async {
    Directory directory = await getApplicationDocumentsDirectory();

    var studentInfoData = await json.decode(
        File('${directory.path}/studentInfoData.json').readAsStringSync());
    var courseData = await json
        .decode(File('${directory.path}/courseData.json').readAsStringSync());
    var progressData = await json
        .decode(File('${directory.path}/progressData.json').readAsStringSync());

    double totalGeneralCredits = 0.0;
    int coreGeneralIndex = 0;
    int sideGeneralIndex = 0;

    //計算通識總學分
    for (int i = 1; i <= 6; i++) totalGeneralCredits += progressData['B$i'];
    for (int i = 1; i <= 3; i++) totalGeneralCredits += progressData['C$i'];
    if (progressData['D0'] > 6)
      totalGeneralCredits += 6;
    else
      totalGeneralCredits += progressData['D0'];

    //計算核心向度
    for (int i = 1; i <= 6; i++)
      if (progressData['B$i'] > 0) coreGeneralIndex++;

    //計算博雅向度
    for (int i = 1; i <= 3; i++)
      if (progressData['C$i'] > 0) sideGeneralIndex++;

    var data = new Map();
    data['studentInfoData'] = studentInfoData;
    data['courseData'] = courseData;
    data['progressData'] = progressData;
    data['totalGeneralCredits'] = totalGeneralCredits;
    data['coreGeneralIndex'] = coreGeneralIndex;
    data['sideGeneralIndex'] = sideGeneralIndex;
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getData(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Text('Error:${snapshot.error}');
          } else {
            return ListView(
              padding: EdgeInsets.all(10),
              children: [
                Card(
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '共同必修',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text('應修 8 學分'),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: CircularPercentIndicator(
                                radius: 70.0,
                                lineWidth: 6.0,
                                percent:
                                    snapshot.data['progressData']['AC'] / 4,
                                center: Text('中文'),
                                footer: Text(
                                    '${snapshot.data['progressData']['AC'].round()} / 4'),
                                progressColor:
                                    Color.fromARGB(255, 244, 143, 177),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: CircularPercentIndicator(
                                radius: 70.0,
                                lineWidth: 6.0,
                                percent:
                                    snapshot.data['progressData']['AE'] / 4,
                                center: Text('英文'),
                                footer: Text(
                                    '${snapshot.data['progressData']['AE'].round()} / 4'),
                                progressColor:
                                    Color.fromARGB(255, 244, 143, 177),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Divider(),
                        buildCourseDataList(snapshot, 'AC'),
                        buildCourseDataList(snapshot, 'AE'),
                        buildCourseDataList(snapshot, 'A3'),
                      ],
                    ),
                  ),
                ),
                Card(
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(height: 80),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '通識選修',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text('應修 24 學分'),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: CircularPercentIndicator(
                                radius: 70.0,
                                lineWidth: 6.0,
                                percent:
                                    snapshot.data['totalGeneralCredits'] / 24,
                                center: Text('全部'),
                                footer: Text(
                                    '${snapshot.data['totalGeneralCredits']} / 24'),
                                progressColor:
                                    Color.fromARGB(255, 255, 204, 128),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: CircularPercentIndicator(
                                radius: 70.0,
                                lineWidth: 6.0,
                                percent: snapshot.data['coreGeneralIndex'] / 4,
                                center: Text('核心\n向度'),
                                footer: Text(
                                    '${snapshot.data['coreGeneralIndex']} / 4'),
                                progressColor:
                                    Color.fromARGB(255, 255, 204, 128),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: CircularPercentIndicator(
                                radius: 70.0,
                                lineWidth: 6.0,
                                percent: snapshot.data['sideGeneralIndex'] / 3,
                                center: Text('博雅\n向度'),
                                footer: Text(
                                    '${snapshot.data['sideGeneralIndex']} / 3'),
                                progressColor:
                                    Color.fromARGB(255, 255, 204, 128),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Divider(),
                        SizedBox(height: 8),
                        Text(
                          '核心通識',
                          style: TextStyle(fontSize: 22),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 8),
                          child: Text(
                            '思維方法',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        buildCourseDataList(snapshot, 'B1'),
                        Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 8),
                          child: Text(
                            '美學素養',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        buildCourseDataList(snapshot, 'B2'),
                        Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 8),
                          child: Text(
                            '公民素養',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        buildCourseDataList(snapshot, 'B3'),
                        Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 8),
                          child: Text(
                            '文化素養',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        buildCourseDataList(snapshot, 'B4'),
                        Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 8),
                          child: Text(
                            '科學素養',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        buildCourseDataList(snapshot, 'B5'),
                        Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 8),
                          child: Text(
                            '倫理素養',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        buildCourseDataList(snapshot, 'B6'),
                        SizedBox(height: 8),
                        Divider(),
                        SizedBox(height: 8),
                        Text(
                          '博雅通識',
                          style: TextStyle(fontSize: 22),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 8),
                          child: Text(
                            '人文科學類',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        buildCourseDataList(snapshot, 'C1'),
                        Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 8),
                          child: Text(
                            '社會科學類',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        buildCourseDataList(snapshot, 'C2'),
                        Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 8),
                          child: Text(
                            '自然科學類',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        buildCourseDataList(snapshot, 'C3'),
                        SizedBox(height: 8),
                        Divider(),
                        SizedBox(height: 8),
                        Text(
                          '跨院選修與微學分',
                          style: TextStyle(fontSize: 22),
                        ),
                        buildCourseDataList(snapshot, 'D0'),
                      ],
                    ),
                  ),
                ),
                Card(
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '系必修',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                      '應修 ${snapshot.data['studentInfoData']['系所必修學分數']}'),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: CircularPercentIndicator(
                                radius: 70.0,
                                lineWidth: 6.0,
                                percent: snapshot.data['progressData']['A1'] /
                                    int.parse(snapshot.data['studentInfoData']
                                            ['系所必修學分數']
                                        .substring(
                                            0,
                                            snapshot
                                                    .data['studentInfoData']
                                                        ['系所必修學分數']
                                                    .length -
                                                3)),
                                center: Text('必修'),
                                footer: Text(
                                    '${snapshot.data['progressData']['A1'].round()} / ${snapshot.data['studentInfoData']['系所必修學分數'].substring(0, snapshot.data['studentInfoData']['系所必修學分數'].length - 3)}'),
                                progressColor:
                                    Color.fromARGB(255, 144, 202, 249),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Divider(),
                        buildCourseDataList(snapshot, 'A1'),
                        SizedBox(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '系選修',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                      '應修 ${snapshot.data['studentInfoData']['系所選修學分數']}'),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: CircularPercentIndicator(
                                radius: 70.0,
                                lineWidth: 6.0,
                                percent: snapshot.data['progressData']['A2'] /
                                    int.parse(snapshot.data['studentInfoData']
                                            ['系所選修學分數']
                                        .substring(
                                            0,
                                            snapshot
                                                    .data['studentInfoData']
                                                        ['系所選修學分數']
                                                    .length -
                                                3)),
                                center: Text('選修'),
                                footer: Text(
                                    '${snapshot.data['progressData']['A2'].round()} / ${snapshot.data['studentInfoData']['系所選修學分數'].substring(0, snapshot.data['studentInfoData']['系所選修學分數'].length - 3)}'),
                                progressColor:
                                    Color.fromARGB(255, 174, 213, 129),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Divider(),
                        buildCourseDataList(snapshot, 'A2'),
                      ],
                    ),
                  ),
                ),
                Card(
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '其他',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Divider(),
                        buildCourseDataList(snapshot, 'D1'),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
        } else {
          return LinearProgressIndicator();
        }
      },
    );
  }

  Column buildCourseDataList(AsyncSnapshot snapshot, String category) {
    return Column(
      children: [
        for (int i = 0; i < snapshot.data['courseData'].length; i++)
          if (snapshot.data['courseData'][i]['category'] == category)
            ListTile(
              title: Text(
                snapshot.data['courseData'][i]['name'],
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Text(snapshot.data['courseData'][i]['score']),
            )
      ],
    );
  }
}
