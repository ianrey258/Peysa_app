import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:pyesa_app/Models/Item.dart';
import 'package:pyesa_app/Screens/LandingPage/LandingPage.dart';

class Cart extends StatefulWidget{
  CartState createState() => CartState();
}
class CartState extends State<Cart>{

  ScrollController _sc;


  Future<bool> editItem(){
    return showDialog(
      context: context,
      builder: (context)=>ShowItemDetail(item: Item.getItemList()[0],quantity: 5,isEdit: true,)
    );
  }

  Future<bool> selectCheckout(){
    return showDialog(
      context: context,
      builder: (context)=>AlertDialog(
        title: Text("Select Store"),
        content: SingleChildScrollView(
          controller: _sc,
          child: Column(
            children: <Widget>[
              RaisedButton(
                child: Text("Store1"),
                onPressed: (){Navigator.pop(context);checkoutDetails();}
              )
            ],
          ),
        ),
      )
    );
  }

  Future<bool> checkoutDetails(){
    return showDialog(
      context: context,
      builder: (context)=>AlertDialog(
        title: Text("Checkout Detail"),
        actions: <Widget>[
          RaisedButton(
            child: Text("Checkout"),
            onPressed: (){Navigator.pop(context);viaPayment();}
          )
        ],
      )
    );
  }

  Future<bool> viaPayment(){
    return showDialog(
      context: context,
      builder: (context)=>AlertDialog(
        title: Text("Payment Method"),
        content: Container(
          child: RaisedButton(
            child: Text("PayaMaya"),
            onPressed: (){Navigator.pop(context);}
          ),
        ),
      )
      
    );
  }

  Widget storeItem(){
    return ListTile(
      leading: Container(
        height: 80,
        width: 80,
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage(Itemimg.getImage()[0].itemImg),fit: BoxFit.fill)
        ),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Text("P300")
        )
      ),
      title: Text("Ram 1600hz"),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text("Quantity"),
          Text("5")
        ],
      ),
      onTap: (){editItem();},
    );
  }

  Widget storeCart(){
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text("  Store1",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
              Expanded(child: Divider())
            ],
          ),
          storeItem()
        ],
      ),
    );
  }

  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Icon(FontAwesome.shopping_cart),
            SizedBox(width: 10,),
            Text("Cart")
          ],
        ),
        actions: <Widget>[
          Container(
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(30)
            ),
            child: FlatButton(
              onPressed: (){selectCheckout();}, 
              child: Text("Checkout",style: TextStyle(color: Colors.white,fontSize: 20),)
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        controller: _sc,
        child: Column(
          children: <Widget>[
            storeCart()
          ],
        ),
      ),
    );
  }
}

class CheckoutDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Checkout Detail"),
      actions: <Widget>[
        RaisedButton(
          child: Text("Checkout"),
          onPressed: (){}
        )
      ],
    );
  }
}

