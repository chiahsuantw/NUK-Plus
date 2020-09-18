import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class NewsPage extends StatefulWidget {
  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 30), (Timer t) {
      //確認是否在停留在該頁面
      if (mounted) {
        setState(() {});
      }
    });
  }

  Future<Map<String, Map<String, String>>> _getUbikeData() async {
    var uBikeDataList = new Map<String, Map<String, String>>();
    http.Response response = await http.get(
        'https://api.kcg.gov.tw/api/service/Get/b4dd9c40-9027-4125-8666-06bef1756092');
    var uBikeData = json.decode(response.body);

    //校門口站
    uBikeDataList['0'] = {
      'sbi': uBikeData['data']['retVal'][354]['sbi'],
      'bemp': uBikeData['data']['retVal'][354]['bemp']
    };
    //大學西路口站
    uBikeDataList['1'] = {
      'sbi': uBikeData['data']['retVal'][624]['sbi'],
      'bemp': uBikeData['data']['retVal'][624]['bemp']
    };
    //大學西路側站
    uBikeDataList['2'] = {
      'sbi': uBikeData['data']['retVal'][615]['sbi'],
      'bemp': uBikeData['data']['retVal'][615]['bemp']
    };
    return uBikeDataList;
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {});
      },
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              overflow: Overflow.visible,
              alignment: Alignment.topCenter,
              children: [
                Container(
                  color: Colors.blue,
                  width: double.infinity,
                  height: 150,
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'NUK+ APP',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            '高大校務通',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.share,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 100,
                  ),
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
                        padding: const EdgeInsets.fromLTRB(20, 12, 24, 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  'assets/images/weather/weather_1.png',
                                  width: 80,
                                ),
                                SizedBox(width: 24),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('降雨率'),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          '45',
                                          style: TextStyle(
                                            color: Colors.blue,
                                            fontSize: 44,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8, bottom: 8),
                                          child: Text(
                                            '%',
                                            style: TextStyle(
                                              fontSize: 24,
                                              color: Colors.blue,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Container(
                              height: 50,
                              child: VerticalDivider(
                                thickness: 2,
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('今天共有'),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '3',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 44,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8, bottom: 8),
                                      child: Text('堂課'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.amberAccent,
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.notifications,
                      color: Colors.grey[700],
                    ),
                    Expanded(
                      child: Text(
                        '金管系碩士陳長毅 發現股票未來報酬率預測工具 獲崇越、富邦人壽論文大獎雙重肯定',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Chip(
                label: Text('YouBike 可借車輛餘額'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
              child: FutureBuilder(
                future: _getUbikeData(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return Text('ERROR${snapshot.error}');
                    } else {
                      return Flex(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        direction: Axis.horizontal,
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.place,
                                      size: 18,
                                      color: Colors.blue,
                                    ),
                                    Text('西路側'),
                                  ],
                                ),
                                Text(
                                  '${snapshot.data['2']['sbi']}',
                                  style: TextStyle(
                                    color: Colors.lightGreen,
                                    fontSize: 40,
                                  ),
                                ),
                                Text('可停${snapshot.data['2']['bemp']}台'),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.place,
                                      size: 18,
                                      color: Colors.blue,
                                    ),
                                    Text('西路口'),
                                  ],
                                ),
                                Text(
                                  '${snapshot.data['1']['sbi']}',
                                  style: TextStyle(
                                    color: Colors.lightGreen,
                                    fontSize: 40,
                                  ),
                                ),
                                Text('可停${snapshot.data['1']['bemp']}台'),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.place,
                                      size: 18,
                                      color: Colors.blue,
                                    ),
                                    Text('校門'),
                                  ],
                                ),
                                Text(
                                  '${snapshot.data['0']['sbi']}',
                                  style: TextStyle(
                                    color: Colors.lightGreen,
                                    fontSize: 40,
                                  ),
                                ),
                                Text('可停${snapshot.data['0']['bemp']}台'),
                              ],
                            ),
                          ),
                          Image.asset(
                            'assets/images/ubike.png',
                            width: 130,
                          ),
                        ],
                      );
                    }
                  } else {
                    return Flex(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      direction: Axis.horizontal,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.place,
                                    size: 18,
                                    color: Colors.blue,
                                  ),
                                  Text('西路側'),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(13.5),
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 1.5,
                                  ),
                                ),
                              ),
                              Text('可停0台'),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.place,
                                    size: 18,
                                    color: Colors.blue,
                                  ),
                                  Text('西路口'),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(13.5),
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 1.5,
                                  ),
                                ),
                              ),
                              Text('可停0台'),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.place,
                                    size: 18,
                                    color: Colors.blue,
                                  ),
                                  Text('校門'),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(13.5),
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 1.5,
                                  ),
                                ),
                              ),
                              Text('可停0台'),
                            ],
                          ),
                        ),
                        Image.asset(
                          'assets/images/ubike.png',
                          width: 130,
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Chip(
                    label: Text('校園快訊'),
                  ),
                  InkWell(
                    onTap: () {},
                    child: SizedBox(
                      width: 60,
                      height: 30,
                      child: Center(
                        child: Text('更多'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 4, right: 4),
              child: Column(
                children: [
                  ListTile(
                    title: Text('2020-09-03'),
                    subtitle: Text(
                        '本校學生註冊繳款單訂於109年8月31日(一)開放線上列印，109年9月14日(一)為繳款截止日，敬請依限繳費。'),
                    isThreeLine: true,
                  ),
                  ListTile(
                    title: Text('2020-09-03'),
                    subtitle: Text(
                        '本校學生註冊繳款單訂於109年8月31日(一)開放線上列印，109年9月14日(一)為繳款截止日，敬請依限繳費。'),
                    isThreeLine: true,
                  ),
                  ListTile(
                    title: Text('2020-09-03'),
                    subtitle: Text(
                        '本校學生註冊繳款單訂於109年8月31日(一)開放線上列印，109年9月14日(一)為繳款截止日，敬請依限繳費。'),
                    isThreeLine: true,
                  ),
                  ListTile(
                    title: Text('2020-09-03'),
                    subtitle: Text(
                        '本校學生註冊繳款單訂於109年8月31日(一)開放線上列印，109年9月14日(一)為繳款截止日，敬請依限繳費。'),
                    isThreeLine: true,
                  ),
                  ListTile(
                    title: Text('2020-09-03'),
                    subtitle: Text(
                        '本校學生註冊繳款單訂於109年8月31日(一)開放線上列印，109年9月14日(一)為繳款截止日，敬請依限繳費。'),
                    isThreeLine: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
