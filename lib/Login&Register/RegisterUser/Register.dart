
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pyesa_app/Controller/Controller.dart';
import 'package:pyesa_app/Models/User.dart';
import 'dart:math';
import 'dart:io';
class RegisterUser extends StatefulWidget{
  Register createState() => Register();
}

class Register extends State<RegisterUser>{
  ScrollController _sc = ScrollController();
  List<TextEditingController> text = []; 
  final _key = GlobalKey<FormState>();
  bool obscure = true;

  @override
  initState(){
    super.initState();
    setState(() {
      for(int i=0;i<10;i++){
        text.add(new TextEditingController());
      }
      text[6].text = "Male";
    });
  }
  
  validation() async {
    if(_key.currentState.validate()){
      _key.currentState.save();
      LoadingScreen.showLoading(context,'Loading   ');
      var result = await HpController.registerUser(text);
      Navigator.pop(context);
      Future.delayed(Duration(seconds: 1));
      if(result){
        await LoadingScreen.showResultDialog(context, "You are Now Registered!",20.0);
        Navigator.pop(context);
      } else {
        await LoadingScreen.showResultDialog(context, "Something Wrong!",20.0);
      }
    }
  }

  Widget _textFormField(String name,int controller,TextInputType type){
    var obscures = name != 'Password' ? false : obscure;
    Widget showPassword = name != 'Password' ? null : IconButton(
      icon: Icon(FontAwesome.eye_slash), 
      onPressed: (){
        setState(() {obscure = obscure ? false : true;});
      },
    );
    return Container(
      padding: EdgeInsets.all(10),
      child: TextFormField(
        obscureText: obscures,
        keyboardType: type,
        controller: text[controller],
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(5),
          fillColor: Color.fromRGBO(255, 255, 255, 0.5),
          filled: true,
          labelText: name,
          suffixIcon: showPassword,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))
          ),
        validator: (val) => val.length > 0 ? null : "Invalid "+name,
      ),
    );
  }

  Widget _radioGender(String value){
    return Radio(
      value: value,
      groupValue: text[6].text,
      onChanged: (val){setState(() {
        text[6].text = val;
      });},
    );
  }
  
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
        actions: <Widget>[
          Container(
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30)
            ),
            child: FlatButton(
              onPressed: validation, 
              child: Text("Ok",style: TextStyle(fontSize: 18),)
            ),
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _sc,
          child: Container(
            child: Form(
              key: _key,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  _textFormField("Username",0,TextInputType.text),
                  _textFormField("Password",1,TextInputType.text),
                  _textFormField("Firstname",2,TextInputType.text),
                  _textFormField("Lastname",3,TextInputType.text),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: <Widget>[
                        _radioGender("Male"),
                        Text("Male "),
                        _radioGender("Female"),
                        Text("Female "),
                      ],
                    ),
                  ),
                  _textFormField("Email Address",4,TextInputType.emailAddress),
                  _textFormField("Contact No.",5,TextInputType.phone),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Register2 extends StatefulWidget {
  @override
  _Register2State createState() => _Register2State();
}

class _Register2State extends State<Register2> {
  File image;
  String _textbutton = "Skip";

  getPicture(source) async {
    Navigator.pop(context);
    var imageFile = await ImagePicker.pickImage(source: source);
    setState(() {
      image = imageFile != null ? imageFile : null;
      _textbutton = "Register";
    });
  }

  Future<bool> selectVia(){
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          buttonPadding: EdgeInsets.all(0),
          title: Text("Choose "),
          elevation: 50,
          content: Container(
            height: MediaQuery.of(context).size.height * .2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  onPressed: (){getPicture(ImageSource.gallery);},
                  child: Text("       Gallery      "),
                ),
                Row(children: <Widget>[
                  Expanded(child: Divider()),
                  Text("or"),
                  Expanded(child: Divider()),
                ]),
                RaisedButton(
                  onPressed: (){getPicture(ImageSource.gallery);},
                  child: Text("Take A Photo"),
                ),
              ]
            )
          ),
        );
      }
    );
  }

  Widget profilePicture(size){
    return image == null ? Icon(FontAwesome.user,size: size.width*.5,)
                  : Image.file(image,fit: BoxFit.fill,);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Set Profile"),
        actions: <Widget>[
          Container(
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30)
            ),
            child: FlatButton(
              onPressed: (){
                Navigator.pop(context);
                Navigator.pop(context);
              }, 
              child: Text(""+_textbutton,style: TextStyle(fontSize: 18),)
            ),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(10),
              height: size.height*.30,
              width: size.width*.5,
              decoration: BoxDecoration(
                border: Border.all()
              ),
              child: FlatButton(
                padding: EdgeInsets.all(1),
                onPressed: (){selectVia();}, 
                child: profilePicture(size)
              ),
            ),
            RaisedButton(
              onPressed: (){selectVia();},
              child: Text("Profile Picture"),
            )
          ],
        )
      ),
    );
  }
}

class StoreRegister extends StatefulWidget {
  @override
  _StoreRegisterState createState() => _StoreRegisterState();
}

class _StoreRegisterState extends State<StoreRegister> {
  ScrollController sc;
  final _key = GlobalKey<FormState>();
  List<TextEditingController> text = [];
  UserImage tinFile = UserImage();

  @override
  initState(){
    super.initState();
    setState(() {
      for(int i=0;i<3;i++){
        text.add(TextEditingController());
      }
    });
  }
  
  validation() async {
    if(_key.currentState.validate() && tinFile.filename != null){
      _key.currentState.save();
      await showAgreement();
    }
  }

  getPicture(source) async {
    File image = await ImagePicker.pickImage(source: source);
    if(image != null){
      tinFile.filename = Random().nextInt(1000000).toString()+'_'+image.path.split('/').last;
      tinFile.binaryfile = base64Encode(image.readAsBytesSync());
    }
    Navigator.pop(context);
  }

  acceptance() async {
    Navigator.pop(context);
    LoadingScreen.showLoading(context, "Submitting Data...");
    var result = await HpController.registerStore(text, tinFile);
    Navigator.pop(context);
    if(result){
      await LoadingScreen.showResultDialog(context, "Form Submitted", 25);
      Navigator.pop(context);
    } else {
      await LoadingScreen.showResultDialog(context, "Data Sumbitting Fail", 20);
      Navigator.pop(context);
    }
  }

  Future<bool> chooseImage(){
    return showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text('Change Profile'),
          content: Container(
            height: MediaQuery.of(context).size.height*.2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  onPressed: (){getPicture(ImageSource.gallery);},
                  child: Text('Gallery'),
                ),
                Divider(),
                RaisedButton(
                  onPressed: (){getPicture(ImageSource.camera);},
                  child: Text('Camera'),
                ),
              ],
            ),
          ),
        );
      }
    );
  }

  Future<bool> showAgreement(){
    return showDialog(
      context: context,
      builder: (_){
        return AlertDialog(
          title: Text('Store Agreement'),
          content: SingleChildScrollView(
            controller: sc,
            child: Column(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height,
                  child: Text('asdasd'),
                )
              ],
            ),
          ),
          actions: <Widget>[
            RaisedButton(
               child: Text('Decline'),
               onPressed: (){Navigator.pop(context);}
             ),
             Expanded(child: Container()),
             RaisedButton(
               child: Text('Accept'),
               onPressed: acceptance
            ),
          ],
        );
      }
    );
  }

  Widget buttonUpload(){
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.all(5),
      child: RaisedButton(
        onPressed: chooseImage,
        child: Text("Upload Bussiness Permit/Tin Picture"),
      ),
    );
  }

  Widget textField(index,name){
    int lines = name == 'Store Description'? 6 :1; 
    return Container(
      margin: EdgeInsets.all(5),
      child: TextFormField(
        controller: text[index],
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(5),
          fillColor: Color.fromRGBO(255, 255, 255, 0.5),
          filled: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))
          ),
        maxLines: lines,
        validator: (val) => val.length > 0 ? null : "Invalid "+name, 
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register Store"),
        actions: <Widget>[
          Container(
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30)
            ),
            child: FlatButton(
              onPressed: validation, 
              child: Text("Submit",style: TextStyle(fontSize: 18),)
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        controller: sc,
        child: Container(
          child: Form(
            key: _key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Store Name:',style: TextStyle(fontSize: 18)),
                textField(0,'Store Name'),
                Text('Store Description:',style: TextStyle(fontSize: 18)),
                textField(1,'Store Description'),
                Text('Store Address:',style: TextStyle(fontSize: 18)),
                textField(2,'Store Address'),
                buttonUpload()
              ],
            ) 
          ),
        ),
      ),
    );
  }
}