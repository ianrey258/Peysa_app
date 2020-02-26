import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:geolocation/geolocation.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:pyesa_app/LandingPage/Store.dart';
import 'package:pyesa_app/Models/Store.dart';
import 'package:pyesa_app/Models/Item.dart';
import 'dart:math';

class LandingPage extends StatefulWidget {
  Home createState() => Home();
}

class Home extends State<LandingPage> {
  TextEditingController _search = TextEditingController();
  ScrollController _sc = ScrollController();
  MapController _mapController = MapController();

  @override
  initState() {
    super.initState();
  }

  getPermission() async {
    final GeolocationResult result =
        await Geolocation.requestLocationPermission(
            permission: LocationPermission(
                android: LocationPermissionAndroid.fine,
                ios: LocationPermissionIOS.always));
    return result;
  }

  getLocation() {
    return getPermission().then((result) async {
      if (result.isSuccessful) {
        final coords =
            await Geolocation.currentLocation(accuracy: LocationAccuracy.best);
      }
    });
  }

  buildMap() {
    getLocation().then((response) {
      if (response.isSuccessful) {
        response.listen((value) {
          _mapController.move(LatLng(8.4977678, 124.6290168), 15.0);
        });
      } else {
        _mapController.move(LatLng(8.4977678, 124.6290168), 15.0);
      }
    });
  }

  Future<bool> showFilter() async {
    return await showDialog(
        context: context,
        builder: (_)=>FilterDialog()
    );
  }

  Widget drawerButton(name,index,destination,icon){
    return ListTile(
      leading: Icon(icon),
      title: Text(
        name,
        style: TextStyle(fontSize: 20),
      ),
      onTap: () {
        Navigator.pushNamed(context, destination);
      },
    );
  }

  Widget _drawer() {
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
                      backgroundImage:
                          AssetImage("assets/Profile/UserProfile.jpg"),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        "Marvin Bonani",
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
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
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.popAndPushNamed(
                      context,
                      '/',
                    );
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<bool> showItemDetail(Item item) async {
    return await showDialog(
      context: context,
      builder: (_) {
        return ShowItemDetail(item: item,quantity: 0,isEdit: false,);
        }
      );
  }

  Widget item(Item item) {
    return RaisedButton(
      color: Colors.white,
      onPressed: ()async{showItemDetail(item);},
      child: Column(
        children: <Widget>[
          Text(item.itemName),
          Expanded(
            child: Image.asset(item.images[item.id].itemImg,fit: BoxFit.fill)
          ),
          Text("P"+item.itemPrice.toString())
        ],
      ),
    );
  }
  List<Widget> generateItems(){
    List<Widget> listitem = [];
    for(int i = 0;i<Random().nextInt(5);i++){
      while(true){
        var random = Random().nextInt(5);
        if(random>0){
          listitem.add(item(Item.getItemList()[random]));
          break;
        } 
      }
    }
    return listitem;
  }

  Widget store(Store store, meters) {
    return Card(
      child: Container(
        height: 200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            FlatButton(
                textColor: Colors.black,
                onPressed: () {
                  Navigator.pushNamed(context, 'OtherStore',arguments: OtherStore(id: store.id));
                },
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Image.asset(
                        store.images[0].images,
                        fit: BoxFit.fill,
                        width: 30,
                        height: 30,
                      ),
                      SizedBox(width: 10,),
                      Text(store.storeName, style: TextStyle(fontSize: 18))
                    ])),
            Divider(indent: 5,endIndent: 5,),
            Expanded(
              child: ListView(
                scrollDirection: Axis.horizontal,
                controller: _sc,
                children: generateItems()
              ),
            ),
            Divider(indent: 5,endIndent: 5,),
            Row(
              children: <Widget>[Expanded(child: SizedBox()), Text(meters)],
            ),
          ],
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
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
              width: size.width * .7,
              child: TextField(
                controller: _search,
                decoration: InputDecoration(
                    prefixIcon: Icon(FontAwesome.search),
                    contentPadding: EdgeInsets.all(5),
                    hintText: "Search Item or Store",
                    fillColor: Color.fromRGBO(255, 255, 255, 1),
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8))),
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
          children: <Widget>[
            Container(
              color: Colors.transparent,
              child: ListView(
                padding: EdgeInsets.all(0),
                children: <Widget>[
                  store(Store.getListStore()[0], "50m Away"),
                  store(Store.getListStore()[1], "100m Away"),
                  store(Store.getListStore()[2], "120m Away"),
                  store(Store.getListStore()[3], "180m Away"),
                  store(Store.getListStore()[4], "200m Away"),
                ],
              ),
            ),
            Container(
              color: Colors.white,
              width: size.width,
              height: size.height,
              child: Column(
                children: <Widget>[
                  Expanded(
                      child: FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                        center: LatLng(8.4977678, 124.6290168), zoom: 13),
                    layers: [
                      TileLayerOptions(
                          urlTemplate: "https://api.tiles.mapbox.com/v4/"
                              "{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}",
                          additionalOptions: {
                            'accessToken':
                                'pk.eyJ1IjoiaWFucmV5MjU4IiwiYSI6ImNrNmJubzlwZjAxbjEza21zdW95NnQyMjEifQ.s1VIlRsbcHV6BbTQNmUHgA',
                            'id': 'mapbox.streets'
                          })
                    ],
                  )),
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
            ),
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
  final Item item;
  final int quantity;
  @required bool isEdit = false;
  ShowItemDetail({Key key, this.item,this.quantity,this.isEdit}) : super (key: key);

  ShowItemDetailstate createState() => ShowItemDetailstate();
}

class ShowItemDetailstate extends State<ShowItemDetail> {
  var qty=1,totalprice=0.0;
  TextEditingController text = TextEditingController();
  ScrollController _sc;

  @override
  initState(){
    super.initState();
    setState(() {
      qty = widget.quantity;
      text.text = qty.toString();
      totalprice = qty*widget.item.itemPrice;
    });
  }
  Widget ratingWidget(){
    return Center(
      heightFactor: 2,
      child: RatingBar(
        itemCount: 5,
        itemSize: 15,
        initialRating: widget.item.itemRating,
        onRatingUpdate: (r){},
        itemBuilder: (context,_)=>Icon(
          Icons.star,
          color: Colors.amber
        ),
      ),
    );
  }

  List<Widget> actions(){
    if(widget.isEdit){
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
      title: Center(child: Text(widget.item.itemName),),
      content: Container(
        height: MediaQuery.of(context).size.height*.5,
        child: ListView(
          controller: _sc,
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height*.25,
              child: Center(child:Image.asset(widget.item.images[widget.item.id].itemImg,fit: BoxFit.fill,)),
            ),
            ratingWidget(),
            SizedBox(height: 15,),
            Row(
              children: <Widget>[
                Expanded(
                  child: Text("Description: "+widget.item.itemDescription)
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
                    child: Text("P"+widget.item.itemPrice.toString(),style: TextStyle(fontSize: 15))
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
                      totalprice = qty*widget.item.itemPrice;
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
                    if(qty<=widget.item.itemStack){
                      qty +=1;
                      text.text = qty.toString();
                      totalprice = qty*widget.item.itemPrice;
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