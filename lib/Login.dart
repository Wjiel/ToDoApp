import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/MainScreen.dart';

class LoginActivity extends StatefulWidget {
  @override
  State<LoginActivity> createState() => _LoginActivityState();
}

var _margine = 10.0;
var _password = "";
var _savePassword = "";
var IController = TextEditingController();
var IController1 = TextEditingController();
var IController2 = TextEditingController();
var IController3 = TextEditingController();

var _focus = FocusNode();
var _focus1 = FocusNode();
var _focus2 = FocusNode();
var _focus3 = FocusNode();

bool isPassword = false;
bool Password = false;

void TextStart() {
  _focus.requestFocus();
}

void RemovePassword() {
  if (_focus.hasFocus == false) {
    _focus.previousFocus();

    _password = _password.substring(0, _password.length - 1);

    print(_password);

    if (_focus3.hasFocus) {
      IController3.text = "";
    } else if (_focus2.hasFocus) {
      IController2.text = "";
    } else if (_focus1.hasFocus) {
      IController1.text = "";
    }

    return;
  }

  _password = "";

  IController.text = "";
}

void NextFocus(int ind) {
  if (_focus3.hasFocus == false) {
    _focus.nextFocus();
    _password += ind.toString();

    print(_password);
    IController.text = _password[0];
    IController1.text = _password[1];
    IController2.text = _password[2];
    IController3.text = _password[3];

    return;
  }

  if (_password.length < 4) {
    _password += ind.toString();

    print(_password);

    IController3.text = _password[3];
  }
}

Future LoadSave() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  _savePassword = prefs.getString("PasswordText")!;
  isPassword = prefs.getBool("isPassword")!;

  print(_savePassword);
  print(isPassword);
}

void TapSend() async {
  if (IController3.text != null) {
    if (isPassword == false) {
      _savePassword = _password;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool("isPassword", true);
      prefs.setString("PasswordText", _savePassword);

      Password = true;
      print("save");
    }

    if (_password == _savePassword) {
      Password = true;

      print("truePassword");
    } else {
      //wrong password
      print("wrongPassword");

      _focus.requestFocus();
      _password = "";
      IController.text = "";
      IController1.text = "";
      IController2.text = "";
      IController3.text = "";
    }
  }
}

class _LoginActivityState extends State<LoginActivity> {
  @override
  void initState() {
    super.initState();

    _focus.requestFocus();
    LoadSave();
  }

  @override
  Widget build(BuildContext context) {
    return Password == false
        ? MaterialApp(
            home: Scaffold(
                body: Center(
              child: Column(
                children: [
                  SizedBox(
                    height: 170,
                    width: 170,
                  ),
                  Text(
                    isPassword == false
                        ? "Создайте ПИН-Код"
                        : "Введите ПИН-Код",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 70,
                    width: 70,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        margin: EdgeInsets.symmetric(horizontal: _margine),
                        decoration: BoxDecoration(
                          color: Color(0xFF8F8F8F),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: TextField(
                          readOnly: true,
                          controller: IController,
                          textAlign: TextAlign.center,
                          focusNode: _focus,
                          textInputAction: TextInputAction.next,
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        width: 60,
                        height: 60,
                        margin: EdgeInsets.symmetric(horizontal: _margine),
                        decoration: BoxDecoration(
                          color: Color(0xFF8F8F8F),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: TextField(
                          readOnly: true,
                          controller: IController1,
                          focusNode: _focus1,
                          textInputAction: TextInputAction.next,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        width: 60,
                        height: 60,
                        margin: EdgeInsets.symmetric(horizontal: _margine),
                        decoration: BoxDecoration(
                          color: Color(0xFF8F8F8F),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: TextField(
                          readOnly: true,
                          controller: IController2,
                          focusNode: _focus2,
                          textInputAction: TextInputAction.next,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        width: 60,
                        height: 60,
                        margin: EdgeInsets.symmetric(horizontal: _margine),
                        decoration: BoxDecoration(
                          color: Color(0xFF8F8F8F),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: TextField(
                          readOnly: true,
                          controller: IController3,
                          focusNode: _focus3,
                          textInputAction: TextInputAction.next,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 200,
                    width: 200,
                  ),
                  Transform.scale(
                    scale: 1.8,
                    child: Column(children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FloatingActionButton(
                            onPressed: () {
                              setState(() {
                                NextFocus(1);
                              });
                            },
                            backgroundColor: Colors.white,
                            child: Text(
                              "1",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          FloatingActionButton(
                            onPressed: () {
                              setState(() {
                                NextFocus(2);
                              });
                            },
                            backgroundColor: Colors.white,
                            child: Text(
                              "2",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          FloatingActionButton(
                            onPressed: () {
                              NextFocus(3);
                            },
                            backgroundColor: Colors.white,
                            child: Text(
                              "3",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FloatingActionButton(
                            onPressed: () {
                              NextFocus(4);
                            },
                            backgroundColor: Colors.white,
                            child: Text(
                              "4",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          FloatingActionButton(
                            onPressed: () {
                              NextFocus(5);
                            },
                            backgroundColor: Colors.white,
                            child: Text(
                              "5",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          FloatingActionButton(
                            onPressed: () {
                              NextFocus(6);
                            },
                            backgroundColor: Colors.white,
                            child: Text(
                              "6",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FloatingActionButton(
                            onPressed: () {
                              NextFocus(7);
                            },
                            backgroundColor: Colors.white,
                            child: Text(
                              "7",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          FloatingActionButton(
                            onPressed: () {
                              NextFocus(8);
                            },
                            backgroundColor: Colors.white,
                            child: Text(
                              "8",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          FloatingActionButton(
                            onPressed: () {
                              NextFocus(9);
                            },
                            backgroundColor: Colors.white,
                            child: Text(
                              "9",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FloatingActionButton(
                            onPressed: () {
                              RemovePassword();
                            },
                            child: Icon(
                              CupertinoIcons.delete_left,
                              color: Colors.white,
                            ),
                            backgroundColor: Colors.black,
                          ),
                          FloatingActionButton(
                            onPressed: () {
                              NextFocus(0);
                            },
                            backgroundColor: Colors.white,
                            child: Text(
                              "0",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          FloatingActionButton(
                            onPressed: () {
                              setState(() {
                                TapSend();
                              });
                            },
                            child: Icon(
                              Icons.send,
                              color: Colors.white,
                            ),
                            backgroundColor: Colors.black,
                          ),
                        ],
                      ),
                    ]),
                  ),
                ],
              ),
            ),
            ),
          )
        : MainActivity();
  }
}
