import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:pyesa_app/Screens/LandingPage/Store.dart';
import 'package:pyesa_app/Models/Store.dart';
import 'package:pyesa_app/Models/Item.dart';
import 'dart:math';
import 'package:pyesa_app/Controller/Controller.dart';
import 'package:pyesa_app/Models/User.dart';

class LandingPage extends StatefulWidget {
  Home createState() => Home();
}

class Home extends State<LandingPage> {
  TextEditingController _search = TextEditingController();
  ScrollController _sc = ScrollController();
  MapController _mapController = MapController();
  GioLocation _geoLocation = GioLocation();
  bool refresh = true;

  @override
  initState() {
    super.initState();
  }

  void refreshState(){
    setState(() {
      refresh = !refresh;
    });
    getLocation();
  }

  Future<Null> refreshStores() async {
    refreshState();
    await Future.delayed(Duration(seconds: 2));
  }
  
  //GeoSection//
  processLocation() async {
    if(!(await HpController.hasConnection())){
      Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
      setState(() {
        _geoLocation.longitude = position.longitude.toString();
        _geoLocation.latitude = position.latitude.toString();
      });
    }
  }
  getLocation(){
    processLocation();
    print(_geoLocation.latitude);
    print(_geoLocation.longitude);
    return _geoLocation.longitude != null ? LatLng(double.parse(_geoLocation.latitude), double.parse(_geoLocation.longitude)) : LatLng(0.0,0.0);
  }
  //GeoSection//

  Widget mapping(){
    return FutureBuilder(
      future: HpController.hasConnection(),
      builder: (_,snapshot){
        if(snapshot.connectionState == ConnectionState.done && snapshot.hasData){
          if(snapshot.data){
            return Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: FlutterMap(
                      mapController: _mapController,
                      options: MapOptions(
                          //center: LatLng(0.0,0.0),
                          center: getLocation(), 
                          zoom: 15.0
                        ),
                      layers: [
                        TileLayerOptions(
                          urlTemplate: "https://api.mapbox.com/styles/v1/ianrey258/ckb28ett60xnh1iry8wtx3tlx/tiles/256/{z}/{x}/{y}@2x?access_token={accessToken}",
                          additionalOptions: {
                            'accessToken': 'pk.eyJ1IjoiaWFucmV5MjU4IiwiYSI6ImNrYjI3eXF0cTA4bjgyd28yeGJta2dtNmQifQ.LtqueENclx7vVAp6IfEusA',
                            'id': 'mapbox.mapbox-streets-v8'
                          }
                        ),
                        MarkerLayerOptions(
                          markers : [
                            Marker(
                              point: getLocation(),
                              builder: (_){
                                return Container(child: Icon(Icons.person),);
                              },
                              width: 30,
                              height: 30
                            )
                          ]
                        )
                      ],
                    )
                  ),
                  // Container(
                  //   padding: EdgeInsets.all(10),
                  //   child: Align(
                  //     alignment: Alignment.bottomRight,
                  //     child: FloatingActionButton(
                  //       backgroundColor: Colors.redAccent,
                  //       child: Icon(FontAwesome.map_marker),
                  //       onPressed: (){},
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            );
          }
          return Center(child: Text('Check Internet Connection'),);
        }
        return Center(child: CircularProgressIndicator(),);
      }
    );
  }

  Future<bool> showFilter() async {
    return await showDialog(
        context: context,
        builder: (_)=>FilterDialog()
    );
  }

  profileImage() {
    return FutureBuilder(
      future: ImageController.getUserImage(),
      builder: (context,snapshot) {
        if(snapshot.connectionState == ConnectionState.done){
          return snapshot.hasData && snapshot.data['filename'] != 'null' ? Image.network(ImageController.getUserNetImage(snapshot.data['filename']),fit: BoxFit.cover,width: 120,height: 120):
           Icon(FontAwesome.user_circle_o,size: 120,);
        }
        return Icon(FontAwesome.user_circle_o,size: 120,);
      }
    );
  }

  void storeButton(destination) async {
    Store store = Store.toObject(await DataController.getStore());
    if(!await HpController.hasStore()){
      Navigator.push(context,MaterialPageRoute(builder: (BuildContext context)=>NoStoreYet()));
    } else {
      store  =  Store.toObject(await DataController.getStore());
      if(store.storeStatus == '15'){
        Navigator.push(context,MaterialPageRoute(builder: (BuildContext context)=>StoreWaiting()));
      } else if(store.storeStatus == '14'){
        Navigator.push(context,MaterialPageRoute(builder: (BuildContext context)=>StoreReApprove()));
      } else {
        Navigator.pushNamed(context, destination);
      }
    }
  }

  Widget drawerButton(name,index,destination,icon){
    return ListTile(
      leading: Icon(icon),
      title: Text(name,style: TextStyle(fontSize: 20),),
      onTap: (){
        destination == "MyStore" ? storeButton(destination) : Navigator.pushNamed(context, destination);
        refreshState();
      },
    );
  }

  Widget showDetailAccount(){
    return FutureBuilder(
      future: DataController.getUserAccount(),
      builder: (context,snapshot){
        if(snapshot.connectionState == ConnectionState.done){
          if(snapshot.hasData){
            return Align(
              alignment: Alignment.bottomRight,
              child: Text(
                snapshot.data['firstname']+" "+snapshot.data['lastname'],
                style: TextStyle(fontSize: 15),
              )
            );
          }
          return Container(width: 0.0, height: 0.0);
        }
        return Container(width: 0.0, height: 0.0);
      }
    );
  }

  Widget _drawer() {
    return FutureBuilder(
      future: DataController.getUserAccount(),
      builder: (context,data){
        if(data.connectionState == ConnectionState.done){
          return Drawer(
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(80),
                        topLeft: Radius.circular(80)),
                    color: Colors.blue,
                  ),
                  child: DrawerHeader(
                    padding: EdgeInsets.fromLTRB(15, 0, 5, 20),
                    margin: EdgeInsets.all(0),
                    child: Row(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.center,
                          child: CircleAvatar(
                            radius: 65,
                            backgroundColor: Colors.white,
                            child: ClipOval(
                              child: profileImage(),
                            ),
                          ),
                        ),
                        Expanded(
                          child: showDetailAccount(),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * .65,
                  child: ListView(
                    padding: EdgeInsets.all(0),
                    controller: _sc,
                    children: <Widget>[
                      drawerButton("Rating & Review", 0, 'RatingReview',FontAwesome.star),
                      drawerButton("Notifcation", 1, 'Notification', FontAwesome.bell),
                      drawerButton("Account", 2, 'Account', FontAwesome.user),
                      drawerButton("Purchases", 3, "Purchases", FontAwesome.product_hunt),
                      drawerButton("Store", 4, "MyStore", FontAwesome5Solid.store),
                      drawerButton("Request Spare Parts", 5, "RequestItem", FontAwesome.eye),
                      ListTile(
                        leading: Icon(FontAwesome.sign_out),
                        title: Text(
                          "Logout",
                          style: TextStyle(fontSize: 20, color: Colors.red),
                        ),
                        onTap: () async {
                          await HpController.logout();
                          Navigator.pop(context);
                          Navigator.popAndPushNamed(context,'/',);
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        }
        return Container();
      }
    );
  }

  Future<bool> showItemDetail(item) async {
    return await showDialog(
      context: context,
      builder: (_) {
        return ShowItemDetail(item: item);
      }
    );
  }

  Widget item(item,image){
    return Container(
      width: 150,
      margin: EdgeInsets.only(left: 5,right: 5),
      child: RaisedButton(
        padding: EdgeInsets.only(left: 1,right: 1),
        color: Colors.white,
        onPressed: ()async{showItemDetail(item);},
        child: Column(
          children: <Widget>[
            Text(item['itemName'],textAlign: TextAlign.center,),
            SizedBox(height: 1.0,),
            Expanded(
              child: Image.network(ImageController.getItemNetImage(image['filename']),fit: BoxFit.contain) ?? Icon(Icons.image,size: MediaQuery.of(context).size.aspectRatio*20,)
            ),
            Text("P "+item['itemPrice'])
          ],
        ),
      )
    );
  }
  
  List<Widget> generateItems(items,images){
    List<Widget> listitem = [];
    for(int i = 0;i<items.length;i++){
      listitem.add(item(items[i],images[i]));
    }
    return listitem;
  }

  Widget storeImage(image){
    return Container(
      width: 30,
      child: Image.network(ImageController.getStoreNetImage(image),fit: BoxFit.fill,width: 30,height: 30,) ?? 
            Icon(Icons.store,size: MediaQuery.of(context).size.aspectRatio*20,),
    );
  }

  Widget store(id) {
    return FutureBuilder(
      future: DataController.getStoreDetails(id),
      builder: (_,snapshot){
        if(snapshot.connectionState == ConnectionState.done){
          if(snapshot.hasData){
            return Card(
              child: Container(
                height: 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    FlatButton(
                        textColor: Colors.black,
                        onPressed: () {
                          Store store = Store.toObject(snapshot.data[0]);
                          Navigator.pushNamed(context, 'OtherStore',arguments: store);
                        },
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              storeImage(snapshot.data[1]['filename']),
                              SizedBox(width: 10,),
                              Text(snapshot.data[0]['storeName'], style: TextStyle(fontSize: 18))
                            ])),
                    Divider(indent: 5,endIndent: 5,),
                    Expanded(
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        controller: _sc,
                        children: generateItems(snapshot.data[2],snapshot.data[3])
                      ),
                    ),
                    Divider(indent: 5,endIndent: 5,),
                    // Row(
                    //   children: <Widget>[Expanded(child: SizedBox()), Text(meters)],
                    // ),
                  ],
                ),
              ),
            );
          }
        }
        return Container();
      },
    );
  }

  Widget stores(){
    return RefreshIndicator(
      onRefresh: refreshStores,
      child: FutureBuilder(
        future: DataController.getStores(),
        builder: (_,snapshot){
          if(snapshot.connectionState == ConnectionState.done){
            if(snapshot.data.isNotEmpty){
              print(snapshot.data);
              if(snapshot.data['id'] == '0')return Center(child: Text('Check Internet Connection'),);
              return Container(
                child: ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (_,index){
                    return store(snapshot.data[index]['storeId']);
                  }
                ),
              );
            }
            return Center(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.store,size: MediaQuery.of(context).devicePixelRatio*100,color: Colors.blue,),
                Text('No Available Stores in This Area',style: TextStyle(fontSize: MediaQuery.of(context).textScaleFactor*20),)
              ],
            ),);
          } 
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.blueAccent,
          actions: <Widget>[
            Container(
              padding: EdgeInsets.all(5),
              width: MediaQuery.of(context).size.width * .7,
              child: TextField(
                controller: _search,
                decoration: InputDecoration(
                    prefixIcon: Icon(FontAwesome.search),
                    contentPadding: EdgeInsets.all(5),
                    hintText: "Search Item or Store",
                    fillColor: Color.fromRGBO(255, 255, 255, 1),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)
                    )
                ),
              ),
            ),
            IconButton(
              icon: Icon(FontAwesome.filter),
              onPressed: showFilter,
            )
          ],
          bottom: TabBar(
            labelColor: Colors.blueAccent,
            unselectedLabelColor: Colors.grey,
            indicator: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              color: Colors.white,
            ),
            tabs: <Widget>[
              Tab(
                text: "Store",
              ),
              Tab(
                text: "Location",
              ),
            ],
          ),
        ),
        drawer: _drawer(),
        endDrawer: Container(),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            stores(),
            mapping(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {Navigator.pushNamed(context, 'Cart');},
          child: Icon(FontAwesome.shopping_cart),
        ),
      ),
    );
  }
}

class FilterDialog extends StatefulWidget {
  StateFilterDialog createState() => StateFilterDialog();
}

class StateFilterDialog extends State<FilterDialog> {
  ScrollController _sc = ScrollController();
  String meter = "500m", star = "5 Star", price = "Above P500", tag = "All";
  Widget radioMeter(String value) {
    return Row(children: <Widget>[
      Radio(
        value: value,
        groupValue: meter,
        onChanged: (val) {
          setState(() {
            meter = val;
          });
        },
      ),
      Text(value)
    ]);
  }

  Widget radioStar(String value) {
    return Row(children: <Widget>[
      Radio(
        value: value,
        groupValue: star,
        onChanged: (val) {
          setState(() {
            star = val;
          });
        },
      ),
      Text(value)
    ]);
  }

  Widget radioPrice(String value) {
    return Row(children: <Widget>[
      Radio(
        value: value,
        groupValue: price,
        onChanged: (val) {
          setState(() {
            price = val;
          });
        },
      ),
      Text(value)
    ]);
  }

  Widget radioTag(String value) {
    return Row(children: <Widget>[
      Radio(
        value: value,
        groupValue: tag,
        onChanged: (val) {
          setState(() {
            tag = val;
          });
        },
      ),
      Text(value)
    ]);
  }

  Widget build(_) {
    return AlertDialog(
      title: Row(children: <Widget>[
        Icon(Icons.filter_list),
        SizedBox(
          width: 10,
        ),
        Text("Filter")
      ]),
      content: SingleChildScrollView(
        controller: _sc,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Tag"),
            radioTag("All"),
            radioTag("Bycicle"),
            radioTag("Motorcyle"),
            radioTag("Computer"),
            Text("Ratings:"),
            radioStar("5 Star"),
            radioStar("4 Star"),
            radioStar("3 Star"),
            radioStar("2 Star"),
            radioStar("1 Star"),
            Text("Meters"),
            radioMeter("50m"),
            radioMeter("100m"),
            radioMeter("250m"),
            radioMeter("500m"),
            Text("Budget Price"),
            radioPrice("P0 - P50"),
            radioPrice("P50 - P100"),
            radioPrice("P100 - P250"),
            radioPrice("P250 - P500"),
            radioPrice("Above P500"),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          color: Colors.white,
          textColor: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("OK"),
        )
      ],
    );
  }
}

class ShowItemDetail extends StatefulWidget {
  final Map item;
  ShowItemDetail({Key key, this.item}) : super (key: key);

  ShowItemDetailstate createState() => ShowItemDetailstate();
}

class ShowItemDetailstate extends State<ShowItemDetail> {
  var qty=1,totalprice=0.0,itemPrice = 0.0;
  List<Widget> images =[];
  bool refresh = true;
  TextEditingController text = TextEditingController();
  ScrollController _sc;

  @override
  initState(){
    super.initState();  
    setState(() {
      text.text = qty.toString();
      itemPrice = double.parse(widget.item['itemPrice']);
      totalprice = qty*itemPrice;
      getImages();
    });
  }

  refreshState(){
    setState(() {
      refresh = refresh ? false : true;
    });
  }

  imageContainer(filename){
    return Container(
      margin: EdgeInsets.only(right: 10),
      child: Image.network(ImageController.getItemNetImage(filename),fit: BoxFit.fill,),
    );
  }

  getImages() async {
    Map data = await ImageController.getItemImages(widget.item['id']);
    data.forEach((key,value) => images.add(imageContainer(value['filename'])));
    refreshState();
  }

  Widget ratingWidget(){
    return Center(
      heightFactor: 2,
      child: RatingBar(
        itemCount: 5,
        itemSize: 15,
        initialRating: double.parse(widget.item['itemRating']),
        onRatingUpdate: (r){},
        itemBuilder: (context,_)=>Icon(
          Icons.star,
          color: Colors.amber
        ),
      ),
    );
  }

  List<Widget> actions(){
    if(false){
      return [
        RaisedButton(
          color: Colors.redAccent,
          onPressed: (){},
          child: Text("Remove")
        ),
        RaisedButton(
          color: Colors.blueAccent,
          onPressed: (){Navigator.pop(context);},
          child: Text("OK")
        )
      ];
    } else {
      return [RaisedButton(
        color: Colors.blueAccent,
        onPressed: (){Navigator.pop(context);},
        child: Row(
          children: <Widget>[
            Icon(FontAwesome.cart_plus),
            SizedBox(width: 5,),
            Text("Add to Cart")
          ],
        ),
      )];
    }
  }

  Widget build(_) {
    return AlertDialog(
      title: Center(child: Text(widget.item['itemName']),),
      content: Container(
        height: MediaQuery.of(context).size.height*.5,
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height*.25,
              width: MediaQuery.of(context).size.width*.75,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: images,
                ),
              ),
            ),
            ratingWidget(),
            SizedBox(height: 15,),
            Row(
              children: <Widget>[
                Expanded(
                  child: Text("Description: "+widget.item['itemDescription'])
                )
              ],
            ),
            SizedBox(height: 5,),
            Row(
              children: <Widget>[
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Price:",style: TextStyle(fontSize: 15))
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text("P"+widget.item['itemPrice'],style: TextStyle(fontSize: 15))
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Quatity:",style: TextStyle(fontSize: 15))
                  ),
                ),
                IconButton(
                  padding: EdgeInsets.all(0),
                  icon: Icon(Icons.remove_circle_outline), onPressed: (){setState(() {
                    if(qty>1){
                      qty -=1;
                      text.text = qty.toString();
                      totalprice = qty*itemPrice;
                    }
                  });}
                ),
                Container(
                  width: 15,
                  child: TextField(
                    readOnly: true,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                    controller: text,
                  ),
                ),
                IconButton(
                  padding: EdgeInsets.all(0),
                  icon: Icon(Icons.add_circle_outline), onPressed: (){setState(() {
                    if(qty< int.parse(widget.item['itemStack'])){
                      qty +=1;
                      text.text = qty.toString();
                      totalprice = qty*itemPrice;
                    }
                  });}
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Total Price:",style: TextStyle(fontSize: 15))
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text("P"+totalprice.toString(),style: TextStyle(fontSize: 15))
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: actions()
    );
  }
}