import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Store extends StatefulWidget{
  Storestate createState() => Storestate();
}
class Storestate extends State<Store>{
  ScrollController _sc;
  //TabController _tb;

  Widget build(BuildContext context){
    return Scaffold(
      body: DefaultTabController(
        initialIndex: 0,
        length: 3,
        child: CustomScrollView(
          controller: _sc,
          slivers: <Widget>[
            SliverAppBar(
              title: Text("Store Profile"),
              expandedHeight: 200,
              automaticallyImplyLeading: false,
              flexibleSpace: Container(
                child: Image.asset('assets/Store/StoreProfile.jpg',fit: BoxFit.fill,),
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
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Store Name : Falcon Computer"),
                            Text("Address :"),
                            Text("Contact no.: 0959021688"),
                            Text("Following : 36"),
                            Text("No. of Customer Visit : 104"),
                            Text("Photos:"),

                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Description:"),
                            Text("awefaewfafedawefaef"),
                            Text("Ratings:"),
                            
                          ],
                        ),
                      )
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
                Container(
                  child: SliverGrid.count(
                    childAspectRatio: 2,
                    crossAxisCount: 3,
                    children: <Widget>[

                    ],
                  ),
                )
              ]),
            )
          ],
        ),
      ),
    );
  }

}