import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class Login extends StatefulWidget{
  LoginPage createState() => new LoginPage();
}

class LoginPage extends State<Login>{

  ScrollController _sc;
  TextEditingController username;
  TextEditingController password;
  final _key = new GlobalKey<FormState>();

  Widget facebookLogin(){
    return FloatingActionButton(
      heroTag: "facebook",
      tooltip: "facebook",
      backgroundColor: Colors.transparent,
      elevation: 20,
      child: Icon(FontAwesome.facebook_official,size: 40),
      onPressed: (){},
    );
  }

  Widget googleLogin(){
    return FloatingActionButton(
      heroTag: "google",
      tooltip: "Google",
      elevation: 30,
      backgroundColor: Colors.transparent,
      child: Icon(FontAwesome.google_plus_official,size: 50,),
      onPressed: (){},
    );
  }
  Widget helpButton(){
    return SpeedDial(
      backgroundColor: Colors.transparent,
      elevation: 2,
      curve: Curves.bounceIn,
      overlayColor: Color.fromRGBO(0, 0, 0, 1),
      child: Icon(FontAwesome.question_circle_o,size: 60,),
      children: [
        SpeedDialChild(
          label: "About Us",
          child: Icon(FontAwesome.info_circle,size: 30,),
        ),
        SpeedDialChild(
          backgroundColor: Colors.redAccent,
          label: "Report Bug",
          child: Icon(FontAwesome.bug,size: 30,),
        ),
        SpeedDialChild(
          backgroundColor: Colors.blueGrey,
          label: "Forget Password",
          child: Icon(FontAwesome.question,size: 30,),
        ),
      ],
    );
  }

  Widget build(BuildContext context){
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        controller: _sc,
        child: Container(
          color: Colors.blueAccent,
          height: size.height,
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 4,
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Center(
                    child: Container(
                      width: size.width*.9,
                      height: size.height*.8,
                      child: Image.asset("assets/logos/Logo.png"),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Container(
                  //color: Colors.purpleAccent,
                  padding: EdgeInsets.all(10),
                  child: Form(
                    key: _key,
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.all(2),
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(50),
                                                    color: Colors.white70
                                                   ),
                          child: Row(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.fromLTRB(0,0,5,0),
                                child: Icon(FontAwesome.user,size: 20,)
                              ),
                              Expanded(
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(color: Color.fromRGBO(168, 168, 168, 0.5),
                                    borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(30),
                                      topRight: Radius.circular(30)
                                    )
                                  ),
                                  child: TextFormField(
                                    controller: username,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(8),
                                      hintText: "Username or Email",
                                      border: UnderlineInputBorder(borderSide: BorderSide.none),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(2),
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(50),
                                                    color: Colors.white70
                                                   ),
                          child: Row(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.fromLTRB(0,0,5,0),
                                child: Icon(Icons.vpn_key,size: 20,)
                              ),
                              Expanded(
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(color: Color.fromRGBO(168, 168, 168, 0.5),
                                    borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(30),
                                      topRight: Radius.circular(30)
                                    )
                                  ),
                                  child: TextFormField(
                                    obscureText: true,
                                    controller: password,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(8),
                                      hintText: "Password",
                                      border: UnderlineInputBorder(borderSide: BorderSide.none),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.all(5),
                                child: Material(
                                  color: Colors.green,
                                  elevation: 8.0,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(30),
                                    topLeft: Radius.circular(30)
                                  ),
                                  child: FlatButton(
                                    onPressed: ()=>Navigator.pushNamed(context, 'RegUser'),
                                    child: Text("Register",textScaleFactor: 1,),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.all(5),
                                child: Material(
                                  color: Color.fromRGBO(255, 131, 70, 1.0),
                                  elevation: 8.0,
                                  borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(30),
                                    topRight: Radius.circular(30)
                                  ),
                                  child: FlatButton(
                                    onPressed: ()=>Navigator.popAndPushNamed(context, 'Home'),
                                    child: Text("Login",textScaleFactor: 1,),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Divider(thickness: 1.5,),
                            ),
                            Text("   Alternative Account   "),
                            Expanded(
                              child: Divider(thickness: 1.5,),
                            ),
                          ],
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: googleLogin(),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: facebookLogin(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      //floatingActionButton: helpButton(),
    );
  }

}