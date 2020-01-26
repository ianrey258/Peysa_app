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
      child: Icon(FontAwesome.facebook_f,size: 40,),
      onPressed: (){},
    );
  }

  Widget googleLogin(){
    return FloatingActionButton(
      heroTag: "google",
      tooltip: "Google",
      backgroundColor: Colors.redAccent,
      child: Icon(FontAwesome.google_plus_official,size: 50,),
      onPressed: (){},
    );
  }
  Widget helpButton(){
    return SpeedDial(
      backgroundColor: Colors.greenAccent,
      curve: Curves.bounceIn,
      overlayColor: Color.fromRGBO(0, 0, 0, 1),
      child: Icon(FontAwesome.question_circle_o,size: 50,),
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
          color: Color.fromRGBO(170, 0, 170, .7),
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
                          margin: EdgeInsets.all(5),
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(3),
                                                    color: Color.fromRGBO(255, 255, 255, 0.7)
                                                   ),
                          child: Row(
                            children: <Widget>[
                              Container(child: Icon(FontAwesome.user,size: 40,)),
                              Expanded(
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(color: Color.fromRGBO(168, 168, 168, 0.5),
                                    borderRadius: BorderRadius.circular(5)
                                  ),
                                  child: TextFormField(
                                    controller: username,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(2),
                                      hintText: "Username",
                                      border: UnderlineInputBorder(borderSide: BorderSide.none),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(5),
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(3),
                                                    color: Color.fromRGBO(255, 255, 255, 0.7)
                                                   ),
                          child: Row(
                            children: <Widget>[
                              Container(child: Icon(Icons.vpn_key,size: 40,)),
                              Expanded(
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(color: Color.fromRGBO(168, 168, 168, 0.5),
                                    borderRadius: BorderRadius.circular(5)
                                  ),
                                  child: TextFormField(
                                    obscureText: true,
                                    controller: password,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(2),
                                      hintText: "Password",
                                      border: UnderlineInputBorder(borderSide: BorderSide.none),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: size.width,
                          padding: EdgeInsets.fromLTRB(40,5,40,0),
                          child: Material(
                            color: Color.fromRGBO(50, 50, 250, 0.8),
                            elevation: 8.0,
                            borderRadius: BorderRadius.circular(30),
                            child: FlatButton(
                              onPressed: ()=>Navigator.popAndPushNamed(context, 'Home'),
                              child: Text("Login",textScaleFactor: 1,),
                            ),
                          ),
                        ),
                        Container(
                          width: size.width,
                          height: size.height*.05,
                          padding: EdgeInsets.fromLTRB(70,5,70,0),
                          child: Material(
                            color: Color.fromRGBO(50, 250, 50, 0.6),
                            elevation: 8.0,
                            borderRadius: BorderRadius.circular(30),
                            child: FlatButton(
                              onPressed: ()=>Navigator.pushNamed(context, 'RegUser'),
                              child: Text("Register"),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
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
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
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
      floatingActionButton: helpButton(),
    );
  }

}