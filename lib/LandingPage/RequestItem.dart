import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:pyesa_app/Models/Item.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class RequestItem extends StatefulWidget{
  RequestItemstate createState() => RequestItemstate();
}
class RequestItemstate extends State<RequestItem>{
  Future<File> file;
  ScrollController _sc;

  Widget requestItem(){
    return ListTile(
      contentPadding: EdgeInsets.only(bottom: 5,left: 5,right: 5),
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
      onTap: (){Navigator.pushNamed(context, 'Bidding');},
    );
  }

  Future<bool> requestDialog(){
    return showDialog(
      context: context,
      builder: (_) => RequestForm()
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
  List<String> locations = ["All Region","Cagayan de Oro","Iligan City","Bukidnon"];
  var selectedLoc = "All Region";
  var screenSize;
  List<File> images = [];

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

  Widget dropDownLocation(){
    return DropdownButtonFormField(
      items: locations.map((String item){
          return DropdownMenuItem(
            value: item,
            child: Text(item)
          );
        }
      ).toList(), 
      onChanged: (String val){
        setState(() {
          selectedLoc = val;
        });
      },
      value: selectedLoc,
    );
  }

  _getPicture(source) async {
    File _item = await ImagePicker.pickImage(source: source);
    setState(() {
      _item != null ? images.add(_item) : null;
    });
    Navigator.pop(context);
  }

  Future<bool> chooseUpload(){
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Choose Upload"),
        content: Container(
          height: MediaQuery.of(context).size.height * .2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                onPressed: (){_getPicture(ImageSource.gallery);},
                child: Text("       Gallery      "),
              ),
              Row(children: <Widget>[
                Expanded(child: Divider()),
                Text("or"),
                Expanded(child: Divider()),
              ]),
              RaisedButton(
                onPressed: (){_getPicture(ImageSource.camera);},
                child: Text("Take A Photo"),
              ),
            ]
          )
        ),
      ),
    );
  }

  Widget sampleImage(image){
    return FlatButton(
      padding: EdgeInsets.only(right: 5),
      onPressed: (){}, 
      child: Image.file(image)
    );
  }

  List<Widget> getImages(){
    return images.isEmpty ? [Center(child: Text("No Sample Image"))]
                          : images.map((e) => sampleImage(e)).toList();
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
               children: getImages(),
             ),
           )
         ),
         Align(
           alignment: Alignment.centerRight,
           child: RaisedButton(
             onPressed: chooseUpload,
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
          form("Budget Price", 2, TextInputType.number),
          dropDownLocation()
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

class Bidding extends StatefulWidget {
  @override
  _BiddingState createState() => _BiddingState();
}

class _BiddingState extends State<Bidding> {
  ScrollController _sc;

  Widget itemImages(){
    return Container(
      height: MediaQuery.of(context).size.height*.4,
      child: SingleChildScrollView(
        controller: _sc,
        scrollDirection: Axis.horizontal,
        child: Row(
          children: <Widget>[
            Image.asset(Itemimg.getImage()[0].itemImg),
            Image.asset(Itemimg.getImage()[1].itemImg),
            Image.asset(Itemimg.getImage()[2].itemImg),
          ],
        ),
      ),
    );
  }

  Widget bidItemDetail(){
    return Container(
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Name: Ram DDR2 1600hz"),
                Text("Description: Bahalag ThirdHand")
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text("Budget Money: P500"),
                Text("Status: Open")
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget bidders(){
    return ListTile(
      contentPadding: EdgeInsets.all(5),
      leading: CircleAvatar(
        radius: 30,
        child: Text("I"),
        backgroundColor: Colors.red,
      ),
      onTap: (){Navigator.pushNamed(context, "BidChat");},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Bid Item"),),
      body: ListView(
        controller: _sc,
        children: <Widget>[
          itemImages(),
          bidItemDetail(),
          Divider(),
          bidders(),
          bidders()
        ],
      ),
    );
  }
}

class BidChat extends StatefulWidget {
  @override
  _BidChatState createState() => _BidChatState();
}

class _BidChatState extends State<BidChat> {
  ScrollController _sc;
  TextEditingController text = TextEditingController();
  List<Widget> conversation =[];

  @override
  initState(){
    super.initState();
    setState(() {
      conversation.add(other("Hi!"));
      conversation.add(you("Low"));
    });
  }

  Widget other(text){
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(30)
          ),
          child: Text(text),
        )
      ],
    );
  }

  Widget you(text){
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(30)
          ),
          child: Text(text,softWrap: true,),
        )
      ],
    );
  }

  List<Widget> conversationDisplay(){
    return conversation;
  }

  Widget inputText(){
    return Material(
      elevation: 10,
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(FontAwesome.image),
            onPressed: (){}
          ),
          Expanded(
            child: TextField(
              controller: text,
              decoration: InputDecoration(
                hintText: "Text Here"
              ),
            )
          ),
          IconButton(
            icon: Icon(FontAwesome.send),
            onPressed: (){
              setState(() {
                conversation.add(you(text.text));
                text.text = "";
              });
            }
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                controller: _sc,
                child: Container(
                  height: MediaQuery.of(context).size.height*.8,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: conversationDisplay(),
                  ),
                )
              )
            ),
            inputText()
          ],
        ),
      )
    );
  }
}