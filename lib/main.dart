import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nuk_course/pages/fetch_data_page.dart';
import 'package:nuk_course/pages/layout.dart';
import 'package:nuk_course/pages/login_page.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '高大校務通',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: AppBarTheme(
          elevation: 0,
        ),
      ),
      home: LoginPage(),
      routes: {
        '/home': (context) => Homepage(),
        '/login': (context) => LoginPage(),
        '/fetch': (context) => FetchDataPage(),
      },
    );
  }
}
