import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:pyesa_app/Models/Item.dart';
import 'package:pyesa_app/Models/Store.dart';
import 'package:pyesa_app/LandingPage/LandingPage.dart';
import 'package:pyesa_app/Controller/Controller.dart';
import 'package:pyesa_app/Models/User.dart';
import 'package:toast/toast.dart';
import 'dart:math';
import 'dart:io';


class MyStore extends StatefulWidget {
  MyStorestate createState() => MyStorestate();
}

class MyStorestate extends State<MyStore> {
  ScrollController _sc;
  GlobalKey<FormState> _key;
  List<TextEditingController> text = [];
  Store store;

  @override
  initState() {
    super.initState();
    _key = new GlobalKey<FormState>();
    setState(() {
      for (int i=0;i<10;i++) {
        text.add(new TextEditingController());
      }
    });
    initializeStore();
  }

  initializeStore() async {

    if(!await HpController.hasStore()){
      Navigator.pop(context);
      Navigator.push(context,MaterialPageRoute(builder: (BuildContext context)=>NoStoreYet()));
    } else {
      store  =  Store.toObject(await DataController.getStore());
      if(store.storeStatus == '15'){
        Navigator.pop(context);
        Navigator.push(context,MaterialPageRoute(builder: (BuildContext context)=>StoreWaiting()));
      }
    }
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
                  onPressed: (){getPicture(ImageSource.camera);},
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
                    onPressed: (){},
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

  Widget build(BuildContext context) {
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

class NoStoreYet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("No Store"),
        actions: <Widget>[
          Container(
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30)
            ),
            child: FlatButton(
              onPressed: ()=>Navigator.popAndPushNamed(context, 'StoreRegister'), 
              child: Text("Register",style: TextStyle(fontSize: 18),)
            ),
          )
        ],
      ),
      body: Center(child: Text("Dont Have Store Yet!",style: TextStyle(fontSize: 25),)),
    );
  }
}

class StoreWaiting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Store"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Your Store has been Process.\n Please wait for an Approval. ",style: TextStyle(fontSize: 25)),
            Text('\n\nThank You!',style: TextStyle(fontSize: 25))
          ]
        ),
        //child: Text("Your Store has been Process.\n Please wait for an Approval. \n\n\t\t\tThank You! ",style: TextStyle(fontSize: 25),)
      ),
    );
  }
}


class EditStoreDetail extends StatefulWidget {
  @override
  _EditStoreState createState() => _EditStoreState();
}

class _EditStoreState extends State<EditStoreDetail> {
  List<TextEditingController> text = []; 
  GlobalKey<FormState> _key = new GlobalKey<FormState>();
  Store _store = Store();
  GioLocation _gioLocation = GioLocation();
  List<UserImage> storeImage = []; 
  ScrollController sc;
  bool loadStore = false,loadlocation = false,loadStoreImages = false;

  @override
  initState(){
    super.initState();
    setState(() {
      for(int i=0;i<3;i++){
        text.add(TextEditingController());
      }
    });
  }

  validate() async {
    if(_key.currentState.validate()){
      _key.currentState.save();
      savingDetail();
      LoadingScreen.showLoading(context, 'Saving Store');
      await DataController.savingStoreDetail(_store.toMapWid(), _gioLocation.toMapWid());
      Navigator.pop(context);
      LoadingScreen.showResultDialog(context, 'Saved!', 25);
      Navigator.pop(context);
    }
  }

  savingDetail(){
    _store.storeName = text[0].text;
    _store.storeInfo = text[1].text;
    _store.storeAddress = text[2].text;
  }

  Widget textFormField(name,indext,keytype){
    return Container(
      margin: EdgeInsets.only(bottom: 5),
      child: TextFormField(
        keyboardType: keytype,
        decoration: InputDecoration(
          labelText: name
        ),
        validator: (val) => val.length > 0 ? null : 'Invalid Input '+name,
      ),
    );
  }

  findLocation(){
    setState((){
      _gioLocation.longitude = (Random().nextInt(1000000) / Random().nextInt(1000000)).toString();
      _gioLocation.latitude = (Random().nextInt(1000000) / Random().nextInt(1000000)).toString();
    });
  }

  Widget location(){
    return FutureBuilder(
      future: DataController.getLocation(),
      builder: (_,result){
        if(result.connectionState == ConnectionState.done && result.hasData){
          if(!loadlocation){_gioLocation =GioLocation.toOject(result.data);}
          loadlocation = false;
          return Container(
            child: Row(
              children: <Widget>[
                Text('Store Giolocation : ('+_gioLocation.longitude+','+_gioLocation.latitude+')'),
                Expanded(child: Container()),
                RaisedButton(
                  onPressed: findLocation,
                  child: Text('Set Location'),
                )
              ]
            ),
          );
        }
        return Container();
      },
    );
  }

  getPicture(source){
    addImage(UserImage(parentId: _store.id,filename: Random().nextInt(10000000).toString()+'.jpg').toMapWOid());
  }

  Future<bool> chooseImage(){
    return showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text('Choose'),
          content: Container(
            height: MediaQuery.of(context).size.height*.2,
            child: Column(
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

  deleteImage(index) async {
    LoadingScreen.showLoading(context, 'Deleting ...');
    var result = await ImageController.removeStoreImage(storeImage[index]);
    Navigator.pop(context);
    Toast.show(result,context,duration: 3,gravity: Toast.BOTTOM);
  }

  addImage(image) async {
    LoadingScreen.showLoading(context, 'Uploading ...');
    var result = await ImageController.addStoreImage(image);
    Navigator.pop(context);
    Toast.show(result,context,duration: 3,gravity: Toast.BOTTOM);
  }

  Widget imageContainer(index){
    return SizedBox(
      height: 100,
      width: 80,
      child: Column(
        children: <Widget>[
          Expanded(
            child: Center(
              child: Text(''+storeImage[index].filename),
            ),
          ),
          FlatButton(
            child: Text('Remove'),
            onPressed: deleteImage(index)
          )
        ],
      )
    );
  }

  loadStoreImage(List storeimages){
    for(int i = 0;i<storeimages.length;i++){
      storeImage.add(UserImage.toObject(storeimages[i]));
    }
    loadStoreImages =true;
  }

  Widget storePicture(){
    return FutureBuilder(
      future: ImageController.getStoreImages(),
      builder: (_,result){
        if(result.connectionState == ConnectionState.done && result.hasData){
          loadStoreImage(result.data);
          if(result.data.isNotEmpty){
            return Container(
              child: ListView(
                scrollDirection: Axis.horizontal,
                controller: sc,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      ListView.builder(
                        scrollDirection:Axis.horizontal,
                        itemCount: storeImage.length,
                        itemBuilder: (_,index){
                          return imageContainer(index);
                        }
                      ),
                      SizedBox(
                        height: 100,
                        width: 80,
                        child: FlatButton(
                          color: Colors.black12,
                          child: Icon(FontAwesome.plus_circle),
                          onPressed: chooseImage,
                        ),
                      )
                    ],
                  ),
                ]
              )
            );
          } else {
            return Container(
              padding: EdgeInsets.only(right:MediaQuery.of(context).size.width*.75),
              child: SizedBox(
                height: 100,
                width: 80,
                child: FlatButton(
                  color: Colors.black12,
                  child: Icon(FontAwesome.plus_circle),
                  onPressed: chooseImage,
                ),
              ),
            ); 
          }
        }
        return Container();
      },
    );
  }

  initStoreData(){
    text[0].text = _store.storeName;
    text[1].text = _store.storeInfo;
    text[2].text = _store.storeAddress;
    loadStore = true;
  }

  Widget editForm(){
    return FutureBuilder(
      future: DataController.getStore(),
      builder: (_,result){
        if(result.connectionState == ConnectionState.done && result.hasData){
          _store = Store.toObject(result.data);
          if(!loadStore){initStoreData();}
          return Container(
            child: Form(
              child: Column(
                children: <Widget>[
                  textFormField('Store Name', 0, TextInputType.text),
                  textFormField('Store Description', 1, TextInputType.multiline),
                  textFormField('Store Address', 2, TextInputType.text),
                  SizedBox(width: 5,),
                  location(),
                  SizedBox(width: 5,),
                  storePicture()
                ],
              )
            ),
          );
        }
        return Container();
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Store'),
        actions: <Widget>[
          Container(
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30)
            ),
            child: FlatButton(
              onPressed: validate, 
              child: Text("Save",style: TextStyle(fontSize: 18),)
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        controller: sc,
        child: Container(
          child: editForm(),
        )
      ),
    );
  }
}