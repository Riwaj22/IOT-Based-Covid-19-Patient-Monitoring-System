import 'package:flutter/material.dart';
import 'aftersignup.dart';
import 'afterlogin.dart';
import 'login.dart';

void main() {
  runApp(MaterialApp(
    home: Login(),
    initialRoute: 'initial',
    routes: {
      'register': (context) => MyRegister(),
      'login': (context) => MyLogin(),
      'initial': (context) => Login(),
    },
  ));
}