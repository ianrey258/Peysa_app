import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:pyesa_app/Models/Item.dart';

class RequestItem extends StatefulWidget{
  RequestItemstate createState() => RequestItemstate();
}
class RequestItemstate extends State<RequestItem>{
  Future<File> file;
  ScrollController _sc;

  Widget requestItem(){
    return ListTile(
      contentPadding: EdgeInsets.only(bottom: 5),
      leading: Image.asset(Itemimg.getImage()[0].itemImg),
      title: Text("Location: All Region"),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Align(
            alignment: Alignment.bottomLeft,
            child: Text("Date: 07/12/2019")
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Text("Status: Open")
          )
        ],
      ),
      onTap: (){},
    );
  }

  Future<bool> requestDialog(){
    return showDialog(
      context: context,
      builder: (_){return RequestForm();},
    );
  }

   Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("Request Item"),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: Icon(FontAwesome.eye), 
                  onPressed: requestDialog
                ),
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: EdgeInsets.only(left: 5,right: 5),
        controller: _sc,
        children: <Widget>[
          requestItem(),
          requestItem(),
          requestItem(),
        ],
      ),
    );
  }
}

class RequestForm extends StatefulWidget {
  @override
  _RequestFormState createState() => _RequestFormState();
}

class _RequestFormState extends State<RequestForm> {
  List<TextEditingController> text = [];
  ScrollController _sc;
  var screenSize;

  @override
  void initState() {
    super.initState();
    setState(() {
      for(int i=0;i<5;i++){
        text.add(TextEditingController());
      }
    });
  }

  Widget form(title,i,keyboard){
    return Container(
      margin: EdgeInsets.only(bottom: 5),
      child: TextFormField(
        controller: text[i],
        keyboardType: keyboard,
        decoration: InputDecoration(
          hintText: title
        ),
      ),
    );
  }

  Widget sampleImage(image){
    return FlatButton(
      padding: EdgeInsets.only(right: 5),
      onPressed: (){}, 
      child: Image.asset(image)
    );
  }

  Widget sampleItems(){
    return Container(
      width: screenSize.width*1,
      height: screenSize.height*.5,
      child: Column(
        children: <Widget>[
         Expanded(
           child: SingleChildScrollView(
             scrollDirection: Axis.horizontal,
             child: Row(
               children: <Widget>[
                 sampleImage(Itemimg.getImage()[0].itemImg),
                 sampleImage(Itemimg.getImage()[1].itemImg),
                 sampleImage(Itemimg.getImage()[2].itemImg)
               ],
             ),
           )
         ),
         Align(
           alignment: Alignment.centerRight,
           child: RaisedButton(
             onPressed: (){},
             child: Text("Upload Image"),
           ),
         )
        ]
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return AlertDialog(
      title: Text("Request Item"),
      content: ListView(
        controller: _sc,
        children: <Widget>[
          sampleItems(),
          form("Name of Item", 0, TextInputType.text),
          form("Description", 1, TextInputType.text),
          form("Budget Price", 2, TextInputType.text),
          form("Location", 3, TextInputType.text),
        ],
      ),
      actions: <Widget>[
        RaisedButton(
          color: Colors.blueAccent,
          onPressed: (){Navigator.pop(context);}, 
          child: Text("Send")
        )
      ],
    );
  }
}