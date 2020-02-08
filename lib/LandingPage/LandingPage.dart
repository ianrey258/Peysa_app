import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:geolocation/geolocation.dart';

class LandingPage extends StatefulWidget{
  Home createState() => Home();
}
class Home extends State<LandingPage>{

  TextEditingController _search = TextEditingController();
  ScrollController _sc = ScrollController();
  MapController _mapController = MapController();
  List<bool> selected = [];

  @override
  initState(){
    super.initState();
    setState(() {
      for(int i=0;i<10;i++){
        selected.add(false);
      }
    });
  }

  select(int i){
    setState(() {
      for(int j=0;j<10;j++){
        i==j?selected[j]=true:selected[j]=false;
      }
    });
  }
  getPermission() async {
    final GeolocationResult result = await Geolocation.requestLocationPermission(
                                      permission: LocationPermission(
                                        android: LocationPermissionAndroid.fine,
                                        ios: LocationPermissionIOS.always));
      return result;
  }

  getLocation() {
    return getPermission().then((result) async {
      if(result.isSuccessful){
        final coords = await Geolocation.currentLocation(accuracy: LocationAccuracy.best);
      }
    });
  }

  buildMap(){
    getLocation().then((response){
      if(response.isSuccessful){
        response.listen((value){
          _mapController.move(LatLng(8.4977678,124.6290168), 15.0);
        });
      }
      else{
        _mapController.move(LatLng(8.4977678,124.6290168), 15.0);
      }
    });
  }


  Future<bool> showFilter() async {
    return await showDialog(
      context: context,
      builder: (_){
        return FilterDialog();
      }
    );
  }

  Widget _drawer(){
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(80),
                topLeft: Radius.circular(80)
              ),
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
                      backgroundImage: AssetImage("assets/Profile/UserProfile.jpg"),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Text("Marvin Bonani",style: TextStyle(fontSize: 15),),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height*.65,
            child: ListView(
              padding: EdgeInsets.all(0),
              controller: _sc,
              children: <Widget>[
                ListTile(
                  leading: Icon(FontAwesome.star),
                  title: Text("Rating & Review",style: TextStyle(fontSize: 20),),
                  onTap: ()  { select(0);Navigator.pushNamed(context, 'RatingReview');},
                  selected: selected[0],
                ),
                ListTile(
                  leading: Icon(FontAwesome.bell),
                  title: Text("Notifcation",style: TextStyle(fontSize: 20),),
                  onTap: ()  { select(1);Navigator.pushNamed(context, 'Notification');},
                  selected: selected[1],
                ),
                ListTile(
                  leading: Icon(FontAwesome.user),
                  title: Text("Account",style: TextStyle(fontSize: 20),),
                  onTap: ()  { select(2);Navigator.pushNamed(context, 'Account');},
                  selected: selected[2],
                ),
                ListTile(
                  leading: Icon(FontAwesome.product_hunt),
                  title: Text("Purchases",style: TextStyle(fontSize: 20),),
                  onTap: ()  { select(3);Navigator.pushNamed(context, "Purchases");},
                  selected: selected[3],
                ),
                ListTile(
                  leading: Icon(FontAwesome5Solid.store),
                  title: Text("Store",style: TextStyle(fontSize: 20),),
                  onTap: ()  { select(4);Navigator.pushNamed(context, "Store");},
                  selected: selected[4],
                ),
                ListTile(
                  leading: Icon(FontAwesome.eye),
                  title: Text("Request Spare Parts",style: TextStyle(fontSize: 20),),
                  onTap: ()  { select(5);Navigator.pushNamed(context, "RequestItem");},
                  selected: selected[5],
                ),
                ListTile(
                  leading: Icon(FontAwesome.sign_out),
                  title: Text(
                    "Logout",
                    style: TextStyle(fontSize: 20,color: Colors.red),
                  ),
                  onTap: (){
                    Navigator.pop(context);
                    Navigator.popAndPushNamed(context, '/',);
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget store(shopname,meters){
    return Card(
                    child: Container(
                      height: 200,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          FlatButton(
                            textColor: Colors.black,
                            onPressed: (){},
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                //Icon(FontAwesome5Solid.store,size:20),
                                Text(shopname,style: TextStyle(fontSize:18))
                              ]
                            )
                          ),
                          Expanded(
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              controller: _sc,
                              children: <Widget>[
                                RaisedButton(
                                  color: Colors.white,
                                  onPressed: (){},
                                  child: Column(
                                    children: <Widget>[
                                      Text("Item1"),
                                      Expanded(
                                        child: Image.asset('assets/Inventory/Ram.jpg',fit: BoxFit.fill,)
                                      ),
                                      Text("P1600.00")
                                    ],
                                  ),
                                ),
                                RaisedButton(
                                  color: Colors.white,
                                  onPressed: (){},
                                  child: Column(
                                    children: <Widget>[
                                      Text("Item2"),
                                      Expanded(
                                        child: Image.asset('assets/Inventory/Athlon_200GE.jpg',fit: BoxFit.fill,)
                                      ),
                                      Text("2500.00")
                                    ],
                                  ),
                                ),
                                RaisedButton(
                                  color: Colors.white,
                                  onPressed: (){},
                                  child: Column(
                                    children: <Widget>[
                                      Text("Item3"),
                                      Expanded(
                                        child: Image.asset('assets/Inventory/HDD_Hp.jpg',fit: BoxFit.fill,)
                                      ),
                                      Text("P2200.00")
                                    ],
                                  ),
                                ),
                                RaisedButton(
                                  color: Colors.white,
                                  onPressed: (){},
                                  child: Column(
                                    children: <Widget>[
                                      Text("Item4"),
                                      Expanded(
                                        child: Image.asset('assets/Inventory/Ram.jpg',fit: BoxFit.fill,)
                                      ),
                                      Text("P3600.00")
                                    ],
                                  ),
                                ),
                              ]
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(child: SizedBox()),
                              Text(meters)
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
  }

  Widget build(BuildContext context){
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
              width: size.width*.7,
              child: TextField(
                controller: _search,
                decoration: InputDecoration(
                  prefixIcon: Icon(FontAwesome.search),
                  contentPadding: EdgeInsets.all(5),
                  hintText: "Search Item or Store",
                  fillColor: Color.fromRGBO(255, 255, 255, 1),
                  filled: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))
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
          children: <Widget>[
            Container(
              color: Colors.transparent,
              child: ListView(
                padding: EdgeInsets.all(0),
                children: <Widget>[
                  store("Store1", "50m Away"),
                  store("Store2", "100m Away"),
                  store("Store3", "120m Away"),
                  store("Store4", "180m Away"),
                  store("Store5", "200m Away"),
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
                        center: LatLng(8.4977678,124.6290168),
                        zoom: 13
                      ),
                      layers: [
                        TileLayerOptions(
                          urlTemplate:"https://api.tiles.mapbox.com/v4/"
                            "{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}",
                          additionalOptions: {
                            'accessToken':'pk.eyJ1IjoiaWFucmV5MjU4IiwiYSI6ImNrNmJubzlwZjAxbjEza21zdW95NnQyMjEifQ.s1VIlRsbcHV6BbTQNmUHgA',
                            'id':'mapbox.streets'
                          }
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
            ),
          ],
        ),
      ),
    );
  }
}

class FilterDialog extends StatefulWidget{
  StateFilterDialog createState() => StateFilterDialog();
}
class StateFilterDialog extends State<FilterDialog>{
  ScrollController _sc = ScrollController();
  var meter = "500m",star = "5 Star",price = "Above P500",tag = "All";
  Widget radioMeter(String value){
    return Row(
      children: <Widget>[
        Radio(
          value: value,
          groupValue: meter,
          onChanged: (val){setState(() {
            meter = val;
          });},
        ),
        Text(value)
      ] 
    );
  }
  Widget radioStar(String value){
    return Row(
      children: <Widget>[
        Radio(
          value: value,
          groupValue: star,
          onChanged: (val){setState(() {
            star = val;
          });},
        ),
        Text(value)
      ] 
    );
  }
  Widget radioPrice(String value){
    return Row(
      children: <Widget>[
        Radio(
          value: value,
          groupValue: price,
          onChanged: (val){setState(() {
            price = val;
          });},
        ),
        Text(value)
      ] 
    );
  }
  Widget radioTag(String value){
    return Row(
      children: <Widget>[
        Radio(
          value: value,
          groupValue: tag,
          onChanged: (val){setState(() {
            tag = val;
          });},
        ),
        Text(value)
      ] 
    );
  }
  Widget build(_){
    return AlertDialog(
          title: Row(
            children: <Widget>[
              Icon(Icons.filter_list),
              SizedBox(width: 10,),
              Text("Filter")
            ]
          ),
          content: SingleChildScrollView(
              controller: _sc,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
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
                  Text("Tag"),
                  radioTag("All"),
                  radioTag("Bycicle"),
                  radioTag("Motorcyle"),
                  radioTag("Computer"),
                ],
              ),
            ),
          actions: <Widget>[
            FlatButton(
              color: Colors.white,
              textColor: Colors.black,
              onPressed: (){Navigator.pop(context);},
              child: Text("OK"),
            )
          ],
        );
  }
}