import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class Cart extends StatefulWidget{
  CartState createState() => CartState();
}
class CartState extends State<Cart>{

  Widget build(_){
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Icon(FontAwesome.shopping_cart),
            SizedBox(width: 10,),
            Text("Cart")
          ],
        ),
      ),
      body: Column(),
    );
  }
}