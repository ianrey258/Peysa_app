import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pyesa_app/Models/Store.dart';
import 'package:pyesa_app/Models/image.dart';
import 'package:pyesa_app/Screens/LandingPage/LandingPage.dart';
import 'package:pyesa_app/Controller/Controller.dart';
import 'package:pyesa_app/Models/User.dart';
import 'package:geolocator/geolocator.dart';
import 'package:toast/toast.dart';
import 'dart:math';
import 'dart:io';


class MyStore extends StatefulWidget {
  MyStorestate createState() => MyStorestate();
}

class MyStorestate extends State<MyStore> {
  ScrollController _sc;
  List<TextEditingController> text = [];
  Store store = Store();
  UserAccount user = UserAccount();
  List<ImageData> storeImages = [];

  @override
  initState() {
    super.initState();
    setState(() {
      for (int i=0;i<10;i++) {
        text.add(new TextEditingController());
      }
    });
  }


  getPicture(source) async {
    var imageFile = await ImagePicker.pickImage(source: source);
    imageFile != null && imageFile.lengthSync()<5000000 ? await showAddItem(imageFile):invalidImageSize();
  }

  invalidImageSize() async {
    Navigator.pop(context);
    LoadingScreen.showResultDialog(context, 'Image Size Must not exceed to 5mb',20);
  }

  Future<bool> showAddItem(picture) {
    Navigator.pop(context);
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_)=>RegisterItem(picture: picture)
    );
  }

  Future<bool> showEditItem(id) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_)=>EditStoreItem(id: id)
    );
  }

  Future<bool> showAddDialog(){
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
              mainAxisAlignment: MainAxisAlignment.center,
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

  Widget storeImage(){
    return FutureBuilder(
      future: ImageController.getStoreImages(),
      builder: (_,result){
        if(result.connectionState == ConnectionState.done && result.hasData){
          if(result.data.isNotEmpty){
            print(result.data[0]['filename']);
            return Container(
              child: Image.network(ImageController.getStoreNetImage(result.data[0]['filename']),fit: BoxFit.cover),
            );
          }
          return Container(color: Colors.blue,);
        }
        return Container();
      }
    );
  }

  Widget storePhotos(){
    return FutureBuilder<List>(
      future: ImageController.getStoreImages(),
      builder: (_,result){
        if(result.connectionState == ConnectionState.done && result.hasData){
          if(result.data.isNotEmpty){
            return SingleChildScrollView(
              controller: _sc,
              scrollDirection: Axis.horizontal,
              child: Container(
                child: Row(
                  children: result.data.map((e){
                    return Container(
                      padding: EdgeInsets.only(right: 10),
                      child: Image.network(ImageController.getStoreNetImage(e['filename']),
                      fit: BoxFit.fill,
                      width: MediaQuery.of(context).size.width*.20,
                      height: MediaQuery.of(context).size.height*.15,
                      ),
                    );
                  }).toList(),
                )
              ),
            );
          }return Container();
        }
        return Container();
      }
    );
  }
  
  Widget giolocation(){
    return FutureBuilder(
      future: DataController.getLocation(),
      builder: (_,result){
        if(result.connectionState == ConnectionState.done && result.hasData){
          if(result.data.isNotEmpty){
            return textHolder('Store GeoLocation : ',result.data['latitude'] +','+result.data['longitude']);
          }
          return Text('GioLocation : (0,-0)');
        }
        return Text('GioLocation : (0,-0)');
      },
    );
  }

  Widget textHolder(String title,String text){
    return Container(
      margin: EdgeInsets.only(bottom: 3.5),
      child: Row(
        children: [
          Text(title,style: TextStyle(fontWeight: FontWeight.w300,)),
          Text(text),
        ],
      ),
    );
  }

  Widget storeDetail(){
    return FutureBuilder(
      future: DataController.getStore(),
      builder: (_,result){
        if(result.connectionState == ConnectionState.done){
          return Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 30),
                textHolder("Store Name : ",result.data['storeName']),
                textHolder("Address : ",result.data['storeAddress']),
                textHolder("Followers :",result.data['storeFollowers']),
                textHolder("Description : ",result.data['storeInfo']),
                giolocation(),
                textHolder("Ratings : ",result.data['storeRating']),
                SizedBox(height: 10,),
                textHolder("Photos : ",''),
                storePhotos(),
                SizedBox(height: 10),
              ],
            ),
          );
        }
        return Container();
      }
    );
  }

  itemImage(id){
    return FutureBuilder<List>(
      future:  ImageController.getItemImg(id),
      builder: (_,result){
        if(result.connectionState == ConnectionState.done && result.hasData){
          print(result.data);
          if(result.data.isNotEmpty){
            return Image.network(ImageController.getItemNetImage(result.data[0]['filename']),fit: BoxFit.fill,);
          }
          return Icon(Icons.image,size: MediaQuery.of(context).size.aspectRatio*100,);
        }
        return Icon(Icons.image,size: MediaQuery.of(context).size.aspectRatio*100,);
      },
    );
  }
  
  Widget itemContainer(data){
    return RaisedButton(
      padding: EdgeInsets.all(0),
      child: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                child: itemImage(data['id']),
              )
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Text('P '+data['itemPrice']),
            ),
          ],
        )
      ),
      onPressed: ()=>showEditItem(data['id']),
    );
  }

  Widget itemsSell(){
    return FutureBuilder<List>(
      future: DataController.getStoreItem(),
      builder: (_,result){
        if(result.connectionState == ConnectionState.done){
          if(result.hasData){
            if(result.data.isNotEmpty){
              return Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: GridView.count(
                  crossAxisCount: 5,
                  children: result.data.map(
                    (data){
                      return itemContainer(data);
                    }
                  ).toList(),
                )
              );
            }
            return Center(child: Text('No Item Yet'),);
          }
        }
        return Container();
      }
    );
  }

  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("My Store"),
      ),
      body: ListView(
        controller: _sc,
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height*.3,
            child: storeImage(),
          ),
          Row(
              children: <Widget>[
                Text("  Overview",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20)),
                Expanded(
                  child: Divider(),
                )
              ],
            ),
          Card(
            child: Container(
              padding: EdgeInsets.only(left: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  storeDetail(),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      margin: EdgeInsets.all(0),
                      width: size.width * .2,
                      child: RaisedButton(
                        color: Colors.white,
                        elevation: 0,
                        padding: EdgeInsets.all(1),
                        onPressed: () {Navigator.pushNamed(context, 'EditStore');},
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Text("Edit",textAlign: TextAlign.right,),
                            ),
                            SizedBox(width: 5,),
                            Icon(FontAwesome.edit)
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Row(
            children: <Widget>[
              Text("  Item Sells",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20)),
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
                      child: Text("Add",textAlign: TextAlign.center,),
                    ),
                    Icon(FontAwesome.plus_square_o)
                  ],
                ),
              ),
            ),
          ),
          itemsSell()
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
  final _key = GlobalKey<FormState>();
  List<File> images = [];
  List<String> category = [];
  List<String> tags = [];
  var cat = 'Other',tag = 'Other',refresh = true;

  @override
  void initState() {
    super.initState();
    initCatags();
    text = [];
    for(int i = 0; i < 10; i++){
      text.add(TextEditingController());
    }
    setState(() {
      images.add(widget.picture);
      checkImages();
    });
  }

  void refreshState(){
    setState(() {
      refresh = !refresh;
    });
  }

  void initCatags() async {
    List list1 = await DataController.getCategory();
    List list2 = await DataController.getTags();
    list1.forEach((element) {category.add(element['categoryName']);});
    list2.forEach((element) {tags.add(element['tagName']);});
    refreshState();
  }

  Widget itemCategory(){
    return DropdownButtonFormField(
      items: category.map((data){
        return DropdownMenuItem(
          value: data,
          child: Text(data)
        );
      }).toList(), 
      onChanged: (val){cat = val;},
      value: 'Other' ?? category[0],
    );
  }

  Widget itemTags(){
    return DropdownButtonFormField(
      items: tags.map((data){
        return DropdownMenuItem(
          value: data,
          child: Text(data)
        );
      }).toList(), 
      onChanged: (val){tag = val;},
      value: 'Other' ?? tags[0],
    );
  }

  Future<String> findIdCategory(cat) async {
    List list1 = await DataController.getCategory();
    String id;
    list1.forEach((element) {if(element['categoryName'] == cat){id=element['id'];}});
    return id;
  }

  Future<String> findIdTag(tag) async {
    List list2 = await DataController.getTags();
    String id;
    list2.forEach((element) {if(element['tagName'] == tag){id=element['id'];}});
    return id;
  }

  Future<List> file2Object() async {
    List<ImageData> imageList = [];
    images.forEach((element) {
      if(element.path != 'null'){
        ImageData item = ImageData();
        item.filename = Random().nextInt(1000000).toString()+'_'+element.path.split('/').last;
        item.binaryfile = base64Encode(element.readAsBytesSync());
        imageList.add(item);
      }
    });
    return imageList;
  }

  validate() async {
    if(_key.currentState.validate()){
      _key.currentState.save();
      text[4].text = await findIdCategory(cat);
      text[5].text = await findIdTag(tag);
      if((await file2Object()).isNotEmpty){
        LoadingScreen.showLoading(context, 'Registering Item');
        var result = await DataController.registerItem(text,await file2Object());
        Navigator.pop(context);
        if(result == 'Item Registered'){
          await LoadingScreen.showResultDialog(context, result, 20);
          Navigator.pop(context);
          Navigator.popAndPushNamed(context,'MyStore');
        } else {
          await LoadingScreen.showResultDialog(context, result, 15);
        }
      }else {
        await LoadingScreen.showResultDialog(context, 'Must Have 1 Sample for the Item To be registered', 15);
      }
      
    }
  }

  Widget inputField(textlabel,controller,keyboardType){
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(labelText: textlabel),
      validator: (val)=>val.length > 0 ? null : 'Required '+textlabel,
    );
  }

  _getPicture(source) async {
    File _item = await ImagePicker.pickImage(source: source);
    print(_item.lengthSync);
    if(_item != null && _item.lengthSync()<5000000){
      setState(() {
        images.removeLast();
        images.add(_item);
        checkImages();
        refreshState();
      });
      Navigator.pop(context);
    }
    else{invalidImageSize();}
  }

  invalidImageSize() async {
    Navigator.pop(context);
    LoadingScreen.showResultDialog(context, 'Image Size Must not exceed to 5mb',20);
  }

  Future<bool> chooseUpload(){
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Choose"),
        content: Container(
          height: MediaQuery.of(context).size.height * .2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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

  checkImages(){
    var isNull = false;
    if(images.length < 5){
      for(int i = 0;i<images.length;i++){
        if(images[i].path == 'null'){
          isNull = true;
          break;
        }
      }
      if(!isNull){
        images.add(File('null'));
      }
    }
  }

  deleteImage(image){
    images.removeAt(images.indexOf(image));
    checkImages();
    refreshState();
    Navigator.pop(context);
  }

  Future<bool> imageFullSize(image){
    return showDialog(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.only(bottom: 50),
          child: Column(
            children: <Widget>[
              images.length >2? Align(
                alignment: Alignment.centerRight,
                child: RaisedButton(
                  onPressed: (){deleteImage(image);},
                  child: Text('Remove'),
                ),
              ):Container(),
              Expanded(
                child: Image.file(image),
              )
            ],
          ),
        );
      },
    );
  }
  
  Widget imageView(){
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      controller: _sc,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: images.map(((image){
          if(image.path == 'null'){
            return Container(
              width: 250,
              height: 200,
              child: FlatButton(
                padding: EdgeInsets.all(0),
                child: Icon(Icons.add_a_photo,size: 50,), 
                onPressed: (){chooseUpload();}
              )
            );
          }
          return Center(
            child: FlatButton(
              padding: EdgeInsets.all(0),
              child: image != null ? Image.file(image,width: 250,height: 200,) : Text("No Image"), 
              onPressed: (){imageFullSize(image);}
            )
          );
        })
        ).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Register Item"),
      content: Container(
        width: MediaQuery.of(context).size.width*.5,
        child: SingleChildScrollView(
          controller: _sc,
          child: Form(
            key: _key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                imageView(),
                inputField("Name Item",text[0],TextInputType.text),
                inputField("Qty of Stock",text[1],TextInputType.numberWithOptions(signed: false,decimal: false)),
                inputField("Price", text[2], TextInputType.numberWithOptions(signed: false,decimal: true)),
                inputField("Description", text[3], TextInputType.text),
                Text('Select Category'),
                itemCategory(),
                Text('Select Tags'),
                itemTags()
              ]
            ),
          ),
        ),
      ),
      actions: <Widget>[
        Align(
          alignment: Alignment.bottomRight,
          child: FlatButton(
            textColor: Colors.black,
            onPressed: validate,
            child: Text("Add"),
          ),
        )
      ],
    );
  }
}

class EditStoreItem extends StatefulWidget {
  final String id;
  EditStoreItem({Key key,this.id}):super(key: key);
  @override
  _EditStoreItemState createState() => _EditStoreItemState();
}

class _EditStoreItemState extends State<EditStoreItem> {
  ScrollController _sc;
  List<TextEditingController> text = [];
  final _key = GlobalKey<FormState>();
  StoreItem item = StoreItem();
  List<ImageData> images = [];
  List<String> category = [];
  List<String> tags = [];
  List<Map> map ;
  var cat = 'Other',tag = 'Other',refresh = true,update = false;

  @override
  initState(){
    super.initState();
    text = [];
    for(int i = 0; i < 10; i++){
      text.add(TextEditingController());
    }
    initCatags();
  }

  void refreshState(){
    setState(() {
      refresh = !refresh;
    });
  }
  
  void initCatags() async {
    List list1 = await DataController.getCategory();
    List list2 = await DataController.getTags();
    list1.forEach((element) {category.add(element['categoryName']);});
    list2.forEach((element) {tags.add(element['tagName']);});
    refreshState();
  }

  //Function Util Section
  validate() async {
    if(_key.currentState.validate()){
      _key.currentState.save();
      LoadingScreen.showLoading(context, 'Saving Item Details');
      await savingState();
      String result = await DataController.savingItemDetail(item.toMapWid());
      Navigator.pop(context);
      if(result != 'Item Updated'){
        await LoadingScreen.showResultDialog(context, result, 20);
      } else {
        await LoadingScreen.showResultDialog(context, result, 20);
        Navigator.pop(context);
      }
    }
  }

  savingState() async {
    item.itemName = text[0].text;
    item.itemStack = text[1].text;
    item.itemPrice = text[2].text;
    item.itemDescription= text[3].text;
    item.categoryId = await findCatId(cat);
    item.tagId = await findTagId(tag);
  }

  Future<String> findCatId(name) async {
    String id;
    List mapCategory = await DataController.getCategory();
    mapCategory.forEach((element) => element['categoryName'] == name ? id = element['id'] : null);
    return id;
  }

  Future<String> findTagId(name) async {
    String id;
    List mapTag = await DataController.getTags();
    mapTag.forEach((element) => element['tagName'] == name ? id = element['id'] : null);
    return id;
  }

  removeItem() async {
    LoadingScreen.showLoading(context, 'Removing Item ...');
    images.removeAt(images.length-1);
    String result = await DataController.removeItem(item.toMapWid(), images);
    Navigator.pop(context);
    if(result != 'Item Deleted'){
      Toast.show(result, context,gravity: Toast.BOTTOM,duration: 2);
    } else{
      Navigator.pop(context);
      Navigator.popAndPushNamed(context, 'MyStore');
      Toast.show(result, context,gravity: Toast.BOTTOM,duration: 2);
    }
  }

  //itemImages Section
  Widget itemImages(){
    return FutureBuilder<List>(
      future: ImageController.getItemImg(widget.id),
      builder: (_,result){
        if(result.connectionState == ConnectionState.done && result.hasData){
          if(result.data.isNotEmpty){
            initImages(result.data);
            print(result.data);
            return Container(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                controller: _sc,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: images.map(((image){
                    if(image.id == null){
                      return Container(
                        width: 250,
                        height: 200,
                        child: FlatButton(
                          padding: EdgeInsets.all(0),
                          child: Icon(Icons.add_a_photo,size: 50,), 
                          onPressed: (){chooseUpload();}
                        )
                      );
                    }
                    return Center(
                      child: FlatButton(
                        padding: EdgeInsets.all(0),
                        child: image.id != null ? Image.network(ImageController.getItemNetImage(image.filename),width: 250,height: 200,) : Text("No Image"), 
                        onPressed: (){imageFullSize(image);}
                      )
                    );
                  })
                  ).toList(),
                ),
              ),
            );
          } else {
            return Container();
          }
        }
        return Container();
      },
    );
  }

  initImages(List dataImages){
    images.clear();
    if(dataImages.length < 5){
      dataImages.forEach((element)=>images.add(ImageData.toObject(element)));
      images.add(ImageData(id: null));
    } else {
      dataImages.forEach((element)=>images.add(ImageData.toObject(element)));
    }
  }

  _getPicture(source) async {
    Navigator.pop(context);
    File _item = await ImagePicker.pickImage(source: source);
    ImageData image = ImageData();
    if(_item != null){
      image.parentId = item.id;
      image.filename = Random().nextInt(1000000).toString()+'_'+_item.path.split('/').last;
      image.binaryfile = base64Encode(_item.readAsBytesSync());
      LoadingScreen.showLoading(context, 'Uploading ...');
      String result = await  ImageController.addStoreItemImage(image);
      if(result!='Image Added'){
        Navigator.pop(context);
        await LoadingScreen.showResultDialog(context, result, 20);
      }
      Navigator.pop(context);
      refreshState();
    }
  }

  Future<bool> chooseUpload(){
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Choose"),
        content: Container(
          height: MediaQuery.of(context).size.height * .2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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

  Future<bool> imageFullSize(image){
    return showDialog(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.only(bottom: 50),
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.centerRight,
                child: RaisedButton(
                  onPressed:()=>removingImage(image),
                  child: Text('Remove'),
                ),
              ),
              Expanded(
                child: Image.network(ImageController.getItemNetImage(image.filename)),
              )
            ],
          ),
        );
      },
    );
  }

  removingImage(ImageData image) async {
    Navigator.pop(context);
    if(images.length == 2){
      await LoadingScreen.showResultDialog(context, 'Sorry Last Image cant Delete', 20);
    } else{
      LoadingScreen.showLoading(context, 'Removing Image ...');
      String result = await ImageController.removeStoreItemImage(image);
      if(result != 'Image Deleted'){
        Navigator.pop(context);
        await LoadingScreen.showResultDialog(context, result, 20);
      }
      Navigator.pop(context);
      refreshState();
    }
  }

  //inputFields Section
  Widget inputFields(){
    return FutureBuilder(
      future: DataController.getItemById(widget.id),
      builder: (_,result){
        if(result.hasData){
          if(!update){
            initData(result.data);
          }
          return Container(
            child: Column(
              children: <Widget>[
                inputField("Name Item",text[0],TextInputType.text),
                inputField("Qty of Stock",text[1],TextInputType.numberWithOptions(signed: false,decimal: false)),
                inputField("Price", text[2], TextInputType.numberWithOptions(signed: false,decimal: true)),
                inputField("Description", text[3], TextInputType.text),
                Text('Select Category'),
                itemCategory(),
                Text('Select Tags'),
                itemTags()
              ],
            ),
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      }
    );
  }

  Widget inputField(textlabel,controller,keyboardType){
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(labelText: textlabel),
      validator: (val) => val.length > 0 ? null : 'Required '+textlabel,
    );
  }

  initData(data) async {
    item = StoreItem.toObject(data);
    cat = await getCategory(item.categoryId);
    tag = await getTag(item.tagId);
    text[0].text = item.itemName;
    text[1].text = item.itemStack;
    text[2].text = item.itemPrice;
    text[3].text = item.itemDescription;
    update = !update;
  }

  Widget itemCategory(){
    return FutureBuilder(
      future: DataController.getCategory(),
      builder: (_,result){
        if(result.connectionState == ConnectionState.done && result.hasData){
          return DropdownButtonFormField(
            items: category.map((data){
              return DropdownMenuItem(
                value: data,
                child: Text(data)
              );
            }).toList(), 
            onChanged: (val){cat = val;},
            value: cat,
          );
        }
        return SizedBox(height: 40,);
      }
    );
  }

  Widget itemTags(){
    return FutureBuilder(
      future: DataController.getCategory(),
      builder: (_,result){
        if(result.connectionState == ConnectionState.done && result.hasData){
          return DropdownButtonFormField(
            items: tags.map((data){
              return DropdownMenuItem(
                value: data,
                child: Text(data)
              );
            }).toList(), 
            onChanged: (val){tag = val;},
            value: tag,
          );
        }
        return SizedBox(height: 40,);
      }
    );
  }

  Future<String> getCategory(id) async {
    String categoryName;
    List mapCategory = await DataController.getCategory();
    mapCategory.forEach((element) => element['id'] == id ? categoryName = element['categoryName'] : null);
    return categoryName;
  }

  Future<String> getTag(id) async {
    String tagName;
    List mapTags = await DataController.getTags();
    mapTags.forEach((element) => element['id'] == id ? tagName = element['tagName'] : null);
    return tagName;
  }

  @override
  Widget build(BuildContext context){
    return AlertDialog(
      title: Row(
        children: <Widget>[
          Text("Edit Item"),
          Expanded(child: Container()),
          RaisedButton(
            padding: EdgeInsets.all(0),
            child: Row(
              children: <Widget>[
                Text('Remove'),
                Icon(Icons.delete_forever)
              ],
            ),
            onPressed: (){removeItem();},
          )
        ],
      ),
      content: Container(
        width: MediaQuery.of(context).size.width*.5,
        child: SingleChildScrollView(
          controller: _sc,
          child: Form(
            key: _key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                itemImages(),
                inputFields()
              ]
            ),
          ),
        ),
      ),
      actions: <Widget>[
        Align(
          alignment: Alignment.bottomRight,
          child: FlatButton(
            textColor: Colors.black,
            onPressed: validate,
            child: Text("Save"),
          ),
        )
      ],
    );
  }
}

class OtherStore extends StatefulWidget {
  // final Map store;
  // OtherStore({Key key, this.store}):super(key: key);

  OtherStoreState createState() => OtherStoreState();
}

class OtherStoreState extends State<OtherStore> {
  ScrollController _sc;
  Store store;
  List<Widget> items = [];

  @override
  initState(){
    super.initState();
  }

  Future<Null> refreshStore() async {
    await Future.delayed(Duration(seconds: 1));
  }

  Future<bool> showItemDetail(item) async {
    return await showDialog(
      context: context,
      builder: (_) {
        return ShowItemDetail(item: item);
        }
      );
  }

  Widget products(StoreItem item,ImageData image){
    return Container(
      margin: EdgeInsets.all(5),
      child: ListTile(
        leading: Image.network(ImageController.getItemNetImage(image.filename)),
        title: Text(item.itemName),
        subtitle: Text(item.itemDescription),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text("P"+item.itemPrice.toString(),style: TextStyle(fontSize: 15),),
          ],
        ),
        onTap: (){showItemDetail(item.toMapWid());},
      ),
    );
  }

  List<Widget> generateItems(items,images){
    List<Widget> listitem = [];
    for(int i = 0;i<items.length;i++){
      listitem.add(products(StoreItem.toObject(items[i]),ImageData.toObject(images[i])));
    }
    return listitem;
  }

  Widget build(BuildContext context) {
    store = ModalRoute.of(context).settings.arguments;
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: RefreshIndicator(
        child: FutureBuilder(
          future: DataController.getFullStoreDetails(store.id),
          builder: (_,snapshot){
            if(snapshot.connectionState == ConnectionState.done){
              if(snapshot.hasData){
                return CustomScrollView(
                  controller: _sc,
                  slivers: <Widget>[
                    SliverAppBar(
                      expandedHeight: MediaQuery.of(context).size.height*.3,
                      flexibleSpace: snapshot.data[1].isNotEmpty? Image.network(ImageController.getStoreNetImage(snapshot.data[1]['filename']),fit: BoxFit.cover,) : 
                        Container(decoration: BoxDecoration(color: Colors.blueAccent),),
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
                      Column(children: generateItems(snapshot.data[2],snapshot.data[3]),)
                    ]))
                  ],
                );
              }
            }
            return Container();
          }
        ), 
        onRefresh: refreshStore
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
      ),
    );
  }
}

class StoreReApprove extends StatefulWidget {
  @override
  _StoreReApproveState createState() => _StoreReApproveState();
}

class _StoreReApproveState extends State<StoreReApprove> {
  ImageData tinFile = ImageData();
  File image;

  @override
  initState(){
    super.initState();
    initApprovalImage();
  }

  initApprovalImage() async {
    tinFile = ImageData.toObject(await ImageController.getApprovalImage());
  }

  void validation() async {
    if(image != null){
      LoadingScreen.showLoading(context, 'Submitting ...');
      var result = await HpController.reApprove(tinFile);
      Navigator.pop(context);
      if(result){
        await LoadingScreen.showResultDialog(context, 'Image Submitted', 25);
        Navigator.pop(context);
      } else {
        await LoadingScreen.showResultDialog(context, 'Error Submitting', 25);
      }
    }
  }

  getPicture(source) async {
    image = await ImagePicker.pickImage(source: source);
    if(image != null){
      tinFile.filename = Random().nextInt(1000000).toString()+'_'+image.path.split('/').last;
      tinFile.binaryfile = base64Encode(image.readAsBytesSync());
    }
    Navigator.pop(context);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Store'),
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Sorry Your Store Cant be Activate due to your Unclear Picture That you Send'),
            RaisedButton(
              onPressed: chooseImage,
              child: Text('Resend Here'),
            )
          ],
        )
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
  GioLocation _geoLocation = GioLocation();
  List<ImageData> storeImage = []; 
  ScrollController sc;
  bool loadStore = false,loadlocation = false,loadStoreImages = false,refresh = true;

  @override
  initState(){
    super.initState();
    setState(() {
      for(int i=0;i<3;i++){
        text.add(TextEditingController());
      }
    });
  }

  getLocation() async {
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _geoLocation.longitude = position.longitude.toString();
      _geoLocation.latitude = position.latitude.toString();
    });
  }

  validate() async {
    if(_key.currentState.validate()){
      _key.currentState.save();
      savingDetail();
      LoadingScreen.showLoading(context, 'Saving Store');
      await DataController.savingStoreDetail(_store.toMapWid(), _geoLocation.toMapWid());
      Navigator.pop(context);
      await LoadingScreen.showResultDialog(context, 'Data Saved!', 25);
      Navigator.pop(context);
      Navigator.popAndPushNamed(context, 'MyStore');
    }
  }

  refreshState(){
    setState(() {
      refresh = !refresh;
    });
  }

  savingDetail(){
    _store.storeName = text[0].text;
    _store.storeInfo = text[1].text;
    _store.storeAddress = text[2].text;
  }

  Widget textFormField(name,index,keytype){
    return Container(
      margin: EdgeInsets.only(bottom: 5),
      child: TextFormField(
        controller: text[index],
        keyboardType: keytype,
        decoration: InputDecoration(
          labelText: name
        ),
        validator: (val) => val.length > 0 ? null : 'Invalid Input '+name,
      ),
    );
  }

  Widget location(){
    return FutureBuilder(
      future: DataController.getLocation(),
      builder: (_,result){
        if(result.connectionState == ConnectionState.done && result.hasData){
          if(!loadlocation){_geoLocation =GioLocation.toOject(result.data);}
          loadlocation = true;
          return Container(
            child: Row(
              children: <Widget>[
                Text('Store Geolocation : ('+_geoLocation.latitude+','+_geoLocation.longitude+')'),
                Expanded(child: Container()),
                RaisedButton(
                  onPressed: getLocation,
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

  getPicture(source) async {
    Navigator.pop(context);
    var image = await ImagePicker.pickImage(source: source);
    if(image != null && image.lengthSync()<5000000){
      ImageData storeImage = ImageData();
      storeImage.parentId = _store.id;
      storeImage.filename = Random().nextInt(10000000).toString()+'_'+image.path.split('/').last;
      storeImage.binaryfile = base64Encode(image.readAsBytesSync());
      addImage(storeImage.toMapWOidUpload());
    }else {
      invalidImageSize();
    }
  }

  invalidImageSize() async {
    Navigator.pop(context);
    LoadingScreen.showResultDialog(context, 'Image Size Must not exceed to 5mb', MediaQuery.of(context).textScaleFactor*15);
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

  Future<bool> deleteImage(image) {
    return showDialog( 
      context: context,
      builder: (_){
        return AlertDialog(
          content: Container(
            height: MediaQuery.of(context).size.height*.2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Are You Sure?'),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    RaisedButton(
                      child: Text('Yes'),
                      onPressed: () async {
                        Navigator.pop(context);
                        LoadingScreen.showLoading(context, 'Deleting ...');
                        var result = await ImageController.removeStoreImage(image);
                        Navigator.pop(context);
                        Toast.show(result,context,duration: 3,gravity: Toast.BOTTOM);
                        refreshState();
                      }
                    ),
                    RaisedButton(
                      child: Text('No'),
                      onPressed: (){Navigator.pop(context);}
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      }
    );
  }

  addImage(image) async {
    LoadingScreen.showLoading(context, 'Uploading ...');
    var result = await ImageController.addStoreImage(image);
    Navigator.pop(context);
    Toast.show(result,context,duration: 3,gravity: Toast.BOTTOM);
    refreshState();
  }

  Widget imageContainer(ImageData image){
    return SizedBox(
      child: Column(
        children: <Widget>[
          Expanded(
            child: Center(
              child: Image.network(ImageController.getStoreNetImage(image.filename),fit: BoxFit.fill,),
            ),
          ),
          FlatButton(
            child: Text('Remove'),
            onPressed: (){deleteImage(image);}
          )
        ],
      )
    );
  }

  loadStoreImage(List storeimages){
    storeImage = [];
    for(int i = 0;i<storeimages.length;i++){
      storeImage.add(ImageData.toObject(storeimages[i]));
    }
    if(storeimages.length < 5 || storeImage == []){
      storeImage.add(ImageData(id: null));
    }
  }

  Widget storePicture(){
    return FutureBuilder<List>(
      future: ImageController.getStoreImages(),
      builder: (_,result){
        if(result.connectionState == ConnectionState.done && result.hasData){
          if(result.hasData){
            loadStoreImage(result.data);
            return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: GridView.count(
                padding: EdgeInsets.all(2),
                crossAxisSpacing: 2.0,
                mainAxisSpacing: 2.0,
                addAutomaticKeepAlives: true,
                crossAxisCount: 3,
                controller: sc,
                children: storeImage.map((image){
                  if(storeImage.elementAt(storeImage.length-1).id ==  null && storeImage.elementAt(storeImage.length-1) == image){
                    return SizedBox(
                      height: 200,
                      child: FlatButton(
                        color: Colors.black12,
                        child: Icon(FontAwesome.plus_circle),
                        onPressed: chooseImage,
                      ),
                    );
                  }
                  return imageContainer(image);
                }).toList(),
              )
            );
          } 
        }
        return Container();
      },
    );
  }

  initStoreData(data){
    _store = Store.toObject(data);
    text[0].text = _store.storeName;
    text[1].text = _store.storeInfo;
    text[2].text = _store.storeAddress;
    loadStore = true;
  }

  editForm(){
    return FutureBuilder(
      future: DataController.getStore(),
      builder: (_,result){
        if(true){
          if(result.hasData){
            if(!loadStore){initStoreData(result.data);}
            return Container(
              child: Form(
                key: _key,
                child: Column(
                  children: <Widget>[
                    textFormField('Store Name', 0, TextInputType.text),
                    textFormField('Store Description', 1, TextInputType.multiline),
                    textFormField('Store Address', 2, TextInputType.text),
                    SizedBox(width: 5,),
                    location(),
                    SizedBox(width: 5,),
                    Text('Store Picture',style: TextStyle(fontSize: 20),),
                    storePicture()
                  ],
                )
              ),
            );
          }
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