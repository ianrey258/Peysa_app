import 'package:flutter/material.dart';
import 'package:pyesa_app/LandingPage/Account.dart';
import 'package:pyesa_app/LandingPage/LandingPage.dart';
import 'package:pyesa_app/LandingPage/Purchases.dart';
import 'package:pyesa_app/LandingPage/Rating&Reviews.dart';
import 'package:pyesa_app/LandingPage/Notification.dart';
import 'package:pyesa_app/LandingPage/RequestItem.dart';
import 'package:pyesa_app/LandingPage/Store.dart';
import 'package:pyesa_app/LandingPage/Cart.dart';
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
        'RegUser1' : (BuildContext context) => Register2(),
        'Home' : (BuildContext context) => LandingPage(),
        'RatingReview' : (BuildContext context) => RatingReviews(),
        'Notification' : (BuildContext context) => Notifications(),
        'Account' : (BuildContext context) => Account(),
        'Purchases' : (BuildContext context) => Purchases(),
        'MyStore' : (BuildContext context) => MyStore(),
        'OtherStore' : (BuildContext context) => OtherStore(),
        'Cart' : (BuildContext context) => Cart(),
        'RequestItem' : (BuildContext context) => RequestItem(),
        'Bidding' : (BuildContext context) => Bidding(),
        'BidChat' : (BuildContext context) => BidChat(),
      },
    );
  }
}

