import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<File> get _courseDataFile async {
  final path = await _localPath;
  return File('$path/courseData.json');
}

Future<File> get _progressDataFile async {
  final path = await _localPath;
  return File('$path/progressData.json');
}

Future<File> get _studentInfoDataFile async {
  final path = await _localPath;
  return File('$path/studentInfoData.json');
}

Future<File> writeToFile(Future<File> file, String data) async {
  final myFile = await file;
  return myFile.writeAsString(data);
}

Future<String> readFromFile(Future<File> file) async {
  try {
    final myFile = await file;
    return await myFile.readAsString();
  } catch (e) {
    print(e);
    return e;
  }
}

Future<void> fetchAndWriteData() async {
  //fetch courseData json from api server
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String account = prefs.getString('Account');
  String password = prefs.getString('Password');
  Response response;

  response =
      await get('https://nukcourse.herokuapp.com/getCourse/$account&$password');
  await writeToFile(_courseDataFile, utf8.decode(response.bodyBytes));

  response =
      await get('https://nukcourse.herokuapp.com/getInfo/$account&$password');
  await writeToFile(_studentInfoDataFile, utf8.decode(response.bodyBytes));

  response = await get(
      'https://nukcourse.herokuapp.com/getProgress/$account&$password');
  await writeToFile(_progressDataFile, utf8.decode(response.bodyBytes));
  print('fetching and writing files finished');
}
