import 'package:flutter/material.dart';
import 'package:pyesa_app/LandingPage/LandingPage.dart';
import 'package:pyesa_app/Login&Register/Login.dart';
import 'package:pyesa_app/Login&Register/RegisterUser/Register.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pyesa_App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: <String ,WidgetBuilder>{
        '/' : (BuildContext context) => Login(),
        'RegUser' : (BuildContext context) => RegisterUser(),
        'Home' : (BuildContext context) => LandingPage(),
      },
    );
  }
}

