import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'dart:io';

class Store extends StatefulWidget {
  Storestate createState() => Storestate();
}

class Store1 extends StatefulWidget {
  Store1State createState() => Store1State();
}

class Storestate extends State<Store> {
  ScrollController _sc;
  //TabController _tb;
  GlobalKey<FormState> _key;
  List<TextEditingController> text = [];
  Future<File> imageFile;

  @override
  initState() {
    super.initState();
    _key = new GlobalKey<FormState>();
    setState(() {
      for (int i = 0; i < 10; i++) {
        text.add(new TextEditingController());
      }
    });
  }

  clearimage() {}

  gallery() {
    Navigator.pop(context);
    print(imageFile.toString());
    setState(() {
      //imageFile = ImagePicker.pickImage(source: ImageSource.gallery);
    });
  }

  camera() {
    //Navigator.pop(context);
    setState(() {
      imageFile = ImagePicker.pickImage(source: ImageSource.camera);
    });
  }

  Future<bool> showAddItem() {
    Navigator.pop(context);
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Add Item"),
            content: SingleChildScrollView(
              controller: _sc,
              child: Form(
                key: _key,
                child: Column(children: <Widget>[
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(color: Colors.yellowAccent),
                  ),
                  TextFormField(
                    controller: text[0],
                    decoration: InputDecoration(labelText: "Name Item"),
                  ),
                  TextFormField(
                    controller: text[1],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: "Qty of Stock"),
                  ),
                  TextFormField(
                    controller: text[2],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: "Price"),
                  ),
                  TextFormField(
                    controller: text[3],
                    decoration: InputDecoration(labelText: "Description"),
                  ),
                  TextFormField(
                    controller: text[3],
                    decoration: InputDecoration(labelText: "Category"),
                  ),
                  TextFormField(
                    controller: text[3],
                    decoration: InputDecoration(labelText: "Tag"),
                  ),
                ]),
              ),
            ),
            actions: <Widget>[
              Align(
                alignment: Alignment.bottomRight,
                child: FlatButton(
                  textColor: Colors.black,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Add"),
                ),
              )
            ],
          );
        });
  }

  Future<bool> showAddDialog() {
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
                        onPressed: showAddItem,
                        child: Text("       Gallery      "),
                      ),
                      Row(children: <Widget>[
                        Expanded(child: Divider()),
                        Text("or"),
                        Expanded(child: Divider()),
                      ]),
                      RaisedButton(
                        onPressed: showAddItem,
                        child: Text("Take A Photo"),
                      ),
                    ])),
          );
        });
  }

  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: CustomScrollView(
        controller: _sc,
        slivers: <Widget>[
          SliverAppBar(
            title: Text("Store Profile"),
            expandedHeight: 200,
            automaticallyImplyLeading: false,
            flexibleSpace: Container(
              child: Image.asset(
                'assets/Store/StoreProfile.jpg',
                fit: BoxFit.fill,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Row(
                children: <Widget>[
                  Text("Overview"),
                  Expanded(
                    child: Divider(),
                  )
                ],
              ),
              Card(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 30),
                          Text("Store Name : Falcon Computer"),
                          Text("Address :"),
                          Text("Contact no.: 0959021688"),
                          Text("Following : 36"),
                          Text("No. of Customer Visit : 104"),
                          Text("Photos:"),
                          Text("Description:"),
                          Text("awefaewfafedawefaef"),
                          Text("Ratings: 5 Stars"),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        margin: EdgeInsets.all(0),
                        width: size.width * .2,
                        child: RaisedButton(
                          color: Colors.white,
                          elevation: 0,
                          padding: EdgeInsets.all(1),
                          onPressed: () {},
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  "Edit",
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Icon(FontAwesome.edit)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: <Widget>[
                  Text("Item Sells"),
                  Expanded(
                    child: Divider(),
                  )
                ],
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  width: size.width * .2,
                  child: RaisedButton(
                    color: Colors.white,
                    elevation: 1,
                    padding: EdgeInsets.all(1),
                    onPressed: showAddDialog,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            "Add",
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Icon(FontAwesome.plus_square_o)
                      ],
                    ),
                  ),
                ),
              ),
            ]),
          ),
          SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return RaisedButton(
                    padding: EdgeInsets.all(1),
                    onPressed: () {},
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: Image.asset(
                            'assets/Inventory/Ram.jpg',
                            fit: BoxFit.fill,
                          ),
                        ),
                        Container(
                          child: Text("P50"),
                        )
                      ],
                    ));
              },
              childCount: 20,
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5, mainAxisSpacing: 5, crossAxisSpacing: 5),
          )
        ],
      ),
    );
  }
}

class Store1State extends State<Store1> {
  ScrollController _sc;

  Widget products() {
    return Container(
      margin: EdgeInsets.all(5),
      child: ListTile(
        leading: Image.asset(
          'assets/Inventory/Ram.jpg',
          fit: BoxFit.fill,
        ),
        title: Text("Ram DDR3 2400hz"),
        subtitle: Text("asdasdasdasdasdasdasdasda"),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text("P1200.00",style: TextStyle(fontSize: 15),),
          ],
        ),
        onTap: (){},
      ),
    );
  }

  Widget build(_) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: CustomScrollView(
        controller: _sc,
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 200,
            flexibleSpace: Image.asset(
              'assets/Store/StoreProfile.jpg',
              fit: BoxFit.fill,
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            Row(
              children: <Widget>[
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: Text("Following: 5"),
                )
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: Text("Rate: 4.5"),
                )
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: Text("Visited: 5"),
                )
              ),
            ]),
            SizedBox(height: size.height*.02,),
            products(),
            products(),
            products(),
            products(),
            products(),
            products(),
            products(),
            products(),
            products(),
            products(),
            products(),
            products(),
            products(),
          ]))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {Navigator.pushNamed(context, 'Cart');},
        child: Icon(FontAwesome.shopping_cart),
      ),
    );
  }
}
