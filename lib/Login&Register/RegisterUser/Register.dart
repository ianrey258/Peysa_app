
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class RegisterUser extends StatefulWidget{
  Register createState() => Register();
}
class Register extends State<RegisterUser>{
  ScrollController _sc = ScrollController();
  List<TextEditingController> text = []; 
  final _key = GlobalKey<FormState>();
  String gender = "Male";
  @override
  initState(){
    super.initState();
    setState(() {
      for(int i=0;i<10;i++){
        text.add(new TextEditingController());
      }
    });
  }
  
  validation(){
    Navigator.pushNamed(context, 'RegUser1');
    if(_key.currentState.validate()){
      _key.currentState.save();
    }
  }

  Widget _textFormField(String name,int controller,TextInputType type){
    return Container(
      padding: EdgeInsets.all(10),
      child: TextFormField(
      keyboardType: type,
      controller: text[controller],
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(5),
        fillColor: Color.fromRGBO(255, 255, 255, 0.5),
        filled: true,
        labelText: name,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))
        ),
      validator: (val) => val.length > 0 ? null : "Invalid "+name,
      ),
    );
  }

  Widget _radioGender(String value){
    return Radio(
      value: value,
      groupValue: gender,
      onChanged: (val){setState(() {
        gender = val;
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
              child: Text("Next >>",style: TextStyle(fontSize: 18),)
            ),
          )
        ],
      ),
      body: Center(
        child: SafeArea(
          child: SingleChildScrollView(
            controller: _sc,
            child: Container(
              child: Form(
                key: _key,
                child: Column(
                  children: <Widget>[
                    _textFormField("Username",0,TextInputType.text),
                    _textFormField("Password",1,TextInputType.text),
                    _textFormField("Firstname",2,TextInputType.text),
                    _textFormField("Lastname",3,TextInputType.text),
                    _textFormField("Address",4,TextInputType.text),
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
                    _textFormField("Birthday dd-mm-yyyy",5,TextInputType.datetime),
                    _textFormField("Email Address",6,TextInputType.emailAddress),
                    _textFormField("Contact No.",7,TextInputType.phone),
                  ],
                ),
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