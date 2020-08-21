import 'package:flutter/material.dart';
import 'package:pyesa_app/Screens/LandingPage/Account.dart';
import 'package:pyesa_app/Screens/LandingPage/LandingPage.dart';
import 'package:pyesa_app/Screens/LandingPage/Purchases.dart';
import 'package:pyesa_app/Screens/LandingPage/Rating&Reviews.dart';
import 'package:pyesa_app/Screens/LandingPage/Notification.dart';
import 'package:pyesa_app/Screens/LandingPage/RequestItem.dart';
import 'package:pyesa_app/Screens/LandingPage/Store.dart';
import 'package:pyesa_app/Screens/LandingPage/Cart.dart';
import 'package:pyesa_app/Screens/Login&Register/Login.dart';
import 'package:pyesa_app/Screens/Login&Register/RegisterUser/Register.dart';
import 'package:pyesa_app/Controller/Controller.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  String _intialRoute;
  MyApp() {
    WidgetsFlutterBinding.ensureInitialized();
    checkSession();
  }
  checkSession() async {
    _intialRoute = await SharedPref.isLogin() ? 'Home' : '/';
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pyesa_App',
      theme:
          ThemeData(primarySwatch: Colors.blue, buttonColor: Colors.grey[300]),
      initialRoute: _intialRoute,
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => Login(),
        'RegUser': (BuildContext context) => RegisterUser(),
        'RegUser1': (BuildContext context) => Register2(),
        'StoreRegister': (BuildContext context) => StoreRegister(),
        'Home': (BuildContext context) => LandingPage(),
        'RatingReview': (BuildContext context) => RatingReviews(),
        'Notification': (BuildContext context) => Notifications(),
        'Account': (BuildContext context) => Account(),
        'EditProfile': (BuildContext context) => EditProfile(),
        'Purchases': (BuildContext context) => Purchases(),
        'MyStore': (BuildContext context) => MyStore(),
        'EditStore': (BuildContext context) => EditStoreDetail(),
        'OtherStore': (BuildContext context) => OtherStore(),
        'Cart': (BuildContext context) => Cart(),
        'RequestItem': (BuildContext context) => RequestItem(),
        'Bidding': (BuildContext context) => Bidding(),
        'BidChat': (BuildContext context) => BidChatScreen(),
      },
    );
  }
}
