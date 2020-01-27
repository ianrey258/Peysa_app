import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class LandingPage extends StatefulWidget{
  Home createState() => Home();
}
class Home extends State<LandingPage>{

  TextEditingController _search = TextEditingController();
  ScrollController _sc = ScrollController();
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
  Widget _drawer(){
    return Drawer(
      child: ListView(
        padding: EdgeInsets.all(0),
        controller: _sc,
        children: <Widget>[
          Container(
            color: Color.fromRGBO(170, 0, 170, 1),
            child: DrawerHeader(
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.white,
                      child: Icon(FontAwesome.user_circle_o,size: 50,),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text("Ianrey J Acampado",style: TextStyle(fontSize: 15),),
                  ),
                ],
              ),
            ),
          ),
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
            onTap: ()  { select(2);},
            selected: selected[2],
          ),
          ListTile(
            leading: Icon(FontAwesome.product_hunt),
            title: Text("Purchases",style: TextStyle(fontSize: 20),),
            onTap: ()  { select(3);},
            selected: selected[3],
          ),
          ListTile(
            leading: Icon(FontAwesome5Solid.store),
            title: Text("Store",style: TextStyle(fontSize: 20),),
            onTap: ()  { select(4);},
            selected: selected[4],
          ),
          ListTile(
            leading: Icon(FontAwesome.eye),
            title: Text("Find Spare Parts",style: TextStyle(fontSize: 20),),
            onTap: ()  { select(5);},
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
          backgroundColor: Color.fromRGBO(170, 0, 170, 1),
          actions: <Widget>[
            Container(
              padding: EdgeInsets.all(5),
              width: size.width*.7,
              child: TextField(
                controller: _search,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(5),
                  hintText: "Search",
                  fillColor: Color.fromRGBO(255, 255, 255, 1),
                  filled: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))
                ),
              ),
            ),
            IconButton(
              icon: Icon(FontAwesome.filter),
              onPressed: (){},
            )
          ],
          bottom: TabBar(
            labelColor: Color.fromRGBO(170, 0, 170, 1),
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
              color: Colors.white,
            ),
            Container(
              color: Colors.white,
              width: size.width,
              height: size.height,
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Container()
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: FloatingActionButton(
                          backgroundColor: Colors.redAccent,
                          child: Icon(FontAwesome.map_marker),
                          onPressed: (){},
                        ),
                      ),
                    )
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}