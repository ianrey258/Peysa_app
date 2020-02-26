import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'dart:io';
import 'package:pyesa_app/Models/Item.dart';
import 'package:pyesa_app/Models/Store.dart';
import 'package:pyesa_app/LandingPage/LandingPage.dart';

class MyStore extends StatefulWidget {
  MyStorestate createState() => MyStorestate();
}

class MyStorestate extends State<MyStore> {
  ScrollController _sc;
  //TabController _tb;
  GlobalKey<FormState> _key;
  List<TextEditingController> text = [];

  @override
  initState() {
    super.initState();
    _key = new GlobalKey<FormState>();
    setState(() {
      for (int i=0;i<10;i++) {
        text.add(new TextEditingController());
      }
    });
  }

  getPicture(source) async {
    var imageFile = await ImagePicker.pickImage(source: source);
    imageFile != null ? await showAddItem(imageFile) : null;
  }

  Future<bool> showAddItem(picture) {
    Navigator.pop(context);
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_)=>RegisterItem(picture: picture)
    );
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
class OtherStore extends StatefulWidget {
  final int id;
  OtherStore({Key key,this.id}):super(key: key);
  OtherStoreState createState() => OtherStoreState();
}

class OtherStoreState extends State<OtherStore> {
  ScrollController _sc;
  Store store;

  @override
  initState(){
    super.initState();
    print('num of stores '+Store.getListStore().length.toString());
  }

  setStore(id){
    setState(() {
      Store.getListStore().forEach((element) {element.id == id? store = element: null;});
    });
  }

  Future<bool> showItemDetail(Item item) async {
    return await showDialog(
      context: context,
      builder: (_) {
        return ShowItemDetail(item: item,quantity: 0,isEdit: false,);
        }
      );
  }

  Widget products(Item item){
    return Container(
      margin: EdgeInsets.all(5),
      child: ListTile(
        leading: Image.asset(
          item.images[item.id].itemImg,
          fit: BoxFit.fill,
        ),
        title: Text(item.itemName),
        subtitle: Text(item.itemDescription),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text("P"+item.itemPrice.toString(),style: TextStyle(fontSize: 15),),
          ],
        ),
        onTap: (){showItemDetail(item);},
      ),
    );
  }

  Widget build(_) {
    final OtherStore argu = ModalRoute.of(context).settings.arguments;
    setStore(argu.id);
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: CustomScrollView(
        controller: _sc,
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 200,
            flexibleSpace: Image.asset(
              store.images[0].images,
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
                  child: Text("Following: "+store.storeFollowers),
                )
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: Text("Rate: "+store.storeRating),
                )
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: Text("Visited: "+store.storeVisited),
                )
              ),
            ]),
            SizedBox(height: size.height*.02,),
            products(Item.getItemList()[0]),
            products(Item.getItemList()[1]),
            products(Item.getItemList()[2]),
            products(Item.getItemList()[3]),
            products(Item.getItemList()[4]),
            products(Item.getItemList()[5]),
            products(Item.getItemList()[0]),
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

class RegisterItem extends StatefulWidget {
  final File picture;

  RegisterItem({Key key,this.picture}) : super(key: key);
  @override
  _RegisterItemState createState() => _RegisterItemState();
}

class _RegisterItemState extends State<RegisterItem> {
  ScrollController _sc;
  List<TextEditingController> text;
  GlobalKey<FormState> _key;
  File image;

  @override
  void initState() {
    super.initState();
    image = widget.picture;
    text = [];
    for(int i = 0; i < 10; i++){
      text.add(TextEditingController());
    }
  }

  Widget inputField(textlabel,controller,keyboardType){
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(labelText: textlabel),
    );
  }
  Widget imageView(){
    return image != null ? Image.file(image,width: 200,height: 200,) : Text("No Image");
  }


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Register Item"),
      content: SingleChildScrollView(
        controller: _sc,
        child: Form(
          key: _key,
          child: Column(
            children: <Widget>[
              Center(
                child: FlatButton(
                  padding: EdgeInsets.all(0),
                  child: imageView(), 
                  onPressed: (){}
                )
              ),
              inputField("Name Item",text[0],TextInputType.text),
              inputField("Qty of Stock",text[1],TextInputType.number),
              inputField("Price", text[2], TextInputType.number),
              inputField("Description", text[3], TextInputType.text),
              inputField("Category", text[4], TextInputType.text),
              inputField("Tag", text[5], TextInputType.text),
            ]
          ),
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
  }
}
