
import 'package:flutter/material.dart';

class RegisterUser extends StatefulWidget{
  Register createState() => Register();
}
class Register extends State<RegisterUser>{
  ScrollController _sc = ScrollController();
  List<TextEditingController> text = []; 
  GlobalKey<FormState> _key;
  String gender = "Male";
  @override
  initState(){
    super.initState();
    _key = new GlobalKey<FormState>();
    setState(() {
      for(int i=0;i<10;i++){
        text.add(new TextEditingController());
      }
    });
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
        backgroundColor: Color.fromRGBO(170, 0, 170, .7),
        title: Text("Register"),
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
                    Container(
                      padding: EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width,
                      child: RaisedButton(
                        elevation: 5,
                        child: Text("Register"),
                        onPressed: (){},
                      ),
                    ),
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