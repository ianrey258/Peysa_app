import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Store extends StatefulWidget{
  Storestate createState() => Storestate();
}
class Storestate extends State<Store>{
  ScrollController _sc;

  Widget build(BuildContext context){
    return Scaffold(
      body: DefaultTabController(
        initialIndex: 0,
        length: 3,
        child: CustomScrollView(
          controller: _sc,
          slivers: <Widget>[
            SliverAppBar(
              bottom: TabBar(
                tabs: <Widget>[],
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([

              ]),
            )
          ],
        ),
      ),
    );
  }

}