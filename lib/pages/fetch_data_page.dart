import 'package:flutter/material.dart';
import 'package:nuk_course/pages/layout.dart';
import 'package:nuk_course/services/service.dart';

import 'package:shared_preferences/shared_preferences.dart';

class FetchDataPage extends StatelessWidget {
  Future<void> _checkInitData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isInit = prefs.getBool('isInit');
    print(isInit);
    if (isInit == null || isInit == true) {
      await fetchAndWriteData();
      prefs.setBool('isInit', false);
      await Future.delayed(Duration(seconds: 2));
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _checkInitData(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Text('Error');
          } else {
            return Homepage();
          }
        } else {
          return Container(
            color: Colors.white,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
