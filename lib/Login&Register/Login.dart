import 'dart:async';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:toast/toast.dart';
import 'package:pyesa_app/Controller/Controller.dart';

class Login extends StatefulWidget{
  LoginPage createState() => new LoginPage();
}

class LoginPage extends State<Login>{
  ScrollController _sc;
  List<TextEditingController> text;
  final _key = GlobalKey<FormState>();
  var isObscure = true;

  @override
  initState(){
    super.initState();
    text = [];
    for(int i=0;i<2;i++){
      text.add(TextEditingController());
    }
  }

  _validate() async {
    if(_key.currentState.validate()){
      _key.currentState.save();
      LoadingScreen.showLoading(context, 'Loggin in ...');
      Map result = await HpController.loginUser(text);
      if(result[1].isNotEmpty){
        Timer(Duration(seconds: 1), (){
          Navigator.pop(context);
          Navigator.popAndPushNamed(context, 'Home');
        });
      } else {
        Navigator.pop(context);
        Toast.show(result[0]['result'], context,duration: 3,gravity: Toast.BOTTOM);
      }
      print(result);
    }
  }

  Widget _facebookLogin(){
    return FloatingActionButton(
      heroTag: "facebook",
      tooltip: "facebook",
      backgroundColor: Colors.transparent,
      elevation: 20,
      child: Icon(FontAwesome.facebook_official,size: 40),
      onPressed: (){},
    );
  }

  Widget _googleLogin(){
    return FloatingActionButton(
      heroTag: "google",
      tooltip: "Google",
      elevation: 30,
      backgroundColor: Colors.transparent,
      child: Icon(FontAwesome.google_plus_official,size: 50,),
      onPressed: (){},
    );
  }
  Widget _helpButton(){
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


  Widget _inputField(hintText,controller,icon){
    var obscure = hintText != "Password" ? false : isObscure;
    Widget seePass = hintText != "Password" ? null : IconButton(
      icon: Icon(FontAwesome.eye_slash), 
      onPressed: (){setState((){isObscure = isObscure ? false : true;});}
    );
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.all(5),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0),
          fillColor: Color.fromRGBO(168, 168, 168, 0.5),
          filled: true,
          hintText: hintText,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30),borderSide: BorderSide.none),
          suffixIcon: seePass,
          prefixIcon: Icon(icon),
        ),
        validator: (val)=> val.length > 0 ? null : "Invalid "+hintText,
      ),
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
                        _inputField("Username", text[0],FontAwesome.user,),
                        _inputField("Password", text[1],FontAwesome.lock),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                height: 45,
                                margin: EdgeInsets.all(5),
                                child: Material(
                                  color: Colors.orange,
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
                                height: 45,
                                margin: EdgeInsets.all(5),
                                child: Material(
                                  color: Colors.green,
                                  elevation: 8.0,
                                  borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(30),
                                    topRight: Radius.circular(30)
                                  ),
                                  child: FlatButton(
                                    onPressed: _validate,
                                    child: Text("Login",textScaleFactor: 1,),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        // Row(
                        //   children: <Widget>[
                        //     Expanded(
                        //       child: Divider(thickness: 1.5,),
                        //     ),
                        //     Text("   Alternative Account   "),
                        //     Expanded(
                        //       child: Divider(thickness: 1.5,),
                        //     ),
                        //   ],
                        // ),
                        // Container(
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.center,
                        //     children: <Widget>[
                        //       Padding(
                        //         padding: const EdgeInsets.all(8.0),
                        //         child: _googleLogin(),
                        //       ),
                        //       Padding(
                        //         padding: const EdgeInsets.all(8.0),
                        //         child: _facebookLogin(),
                        //       ),
                        //     ],
                        //   ),
                        // ),
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