import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Account extends StatefulWidget{
  Accountstate createState() => Accountstate();
}
class Accountstate extends State<Account>{
  ScrollController _sc;
  List<TextEditingController> text = []; 
  GlobalKey<FormState> _key = new GlobalKey<FormState>();
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
      body: CustomScrollView(
        controller: _sc,
        scrollDirection: Axis.vertical,
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Colors.transparent,
            forceElevated: false,
            expandedHeight: 150,
            pinned: false,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.all(10),
              centerTitle: true,
              title: CircleAvatar(
                radius: 35,
                backgroundColor: Colors.white,
                child: ClipOval(
                  child: Image.asset(
                    "assets/Profile/UserProfile.jpg",
                    fit: BoxFit.fill,
                    width: 65,
                    height: 65,
                  ),
                ),
              ),
              background: Image.asset("assets/Store/StoreProfile.jpg",fit: BoxFit.fill,),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Container(
                child: Form(
                  key: _key,
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Divider(),
                          ),
                          Text("Personal Info's"),
                          Expanded(
                            child: Divider(),
                          ),
                        ],
                      ),
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
                        color: Colors.blueAccent,
                        elevation: 5,
                        child: Text("Save"),
                        onPressed: (){},
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ]),
          ),
        ],
      ),
    );
  }

}