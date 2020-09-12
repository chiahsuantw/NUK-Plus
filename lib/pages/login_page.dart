import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nuk_course/pages/layout.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Future<bool> _checkUserData() async {
    // await Future.delayed(Duration(seconds: 2));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('Account') != null &&
        prefs.getString('Password') != null) return true;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _checkUserData(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Text('錯誤${snapshot.error}，請重新安裝'),
              ),
            );
          } else {
            if (snapshot.data == true) {
              return Homepage();
            } else {
              return LoginPageUi();
            }
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

class LoginPageUi extends StatefulWidget {
  @override
  _LoginPageUiState createState() => _LoginPageUiState();
}

class _LoginPageUiState extends State<LoginPageUi> {
  bool _isAccountEmpty = true;
  bool _isPasswordEmpty = true;
  bool _isVisible = false;
  String _account;
  String _password;

  Future<bool> _loginUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var url = 'https://aca.nuk.edu.tw/Student2/Menu1.asp';
    var data = Map<String, String>();
    data['Account'] = _account;
    data['Password'] = _password;
    http.Response response = await http.post(url, body: data);
    if (response.headers['content-length'] != '992') {
      await prefs.setString('Account', _account);
      await prefs.setString('Password', _password);
      print('登入正確');
      return true;
    }
    print('登入失敗');
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('登入'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '同學',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '歡迎使用。',
                        style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 50),
              TextField(
                onChanged: (text) {
                  _account = text.trim();
                  setState(() {
                    if (text.isEmpty)
                      _isAccountEmpty = true;
                    else
                      _isAccountEmpty = false;
                  });
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  labelText: '教務系統帳號',
                  border: OutlineInputBorder(),
                  errorText: _isAccountEmpty ? '不可以沒有輸入帳號' : null,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^[0-9a-zA-Z]+$')),
                ],
              ),
              SizedBox(height: 12),
              TextField(
                onChanged: (text) {
                  _password = text.trim();
                  setState(() {
                    if (text.isEmpty)
                      _isPasswordEmpty = true;
                    else
                      _isPasswordEmpty = false;
                  });
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: _isVisible
                        ? Icon(Icons.visibility_off)
                        : Icon(Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _isVisible = !_isVisible;
                      });
                    },
                  ),
                  // Based on passwordVisible state choose the icon
                  labelText: '密碼',
                  border: OutlineInputBorder(),
                  errorText: _isPasswordEmpty ? '放心，我們不會偷你的密碼' : null,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^[0-9a-zA-Z]+$')),
                ],
                obscureText: !_isVisible,
              ),
              SizedBox(height: 12),
              Container(
                width: double.infinity,
                height: 45,
                child: FlatButton(
                  onPressed: _isAccountEmpty || _isPasswordEmpty
                      ? null
                      : () async {
                          print(_account + '\n' + _password);
                          Fluttertoast.showToast(
                            msg: '工作中',
                            gravity: ToastGravity.BOTTOM,
                          );
                          var result = await _loginUser();
                          if (result == true)
                            Navigator.pushReplacementNamed(context, '/fetch');
                          else {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (_) => AlertDialog(
                                title: Text('登入失敗'),
                                content: Text('教務系統說無法登入，請再試一次'),
                                actions: [
                                  FlatButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('了解'),
                                  )
                                ],
                              ),
                            );
                          }
                        },
                  color: Colors.blue,
                  disabledColor: Colors.blue[200],
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: Text('登入'),
                ),
              ),
              SizedBox(height: 100),
              Text('使用該功能即表示您同意 服務條款'),
            ],
          ),
        ),
      ),
    );
  }
}
