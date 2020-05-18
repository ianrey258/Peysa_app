import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Purchases extends StatefulWidget{
  Purchasesstate createState() => Purchasesstate();
}

class Purchasesstate extends State<Purchases>{
  ScrollController _sc;

  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Purchased Items"),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView(
        controller: _sc,
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(5),
            child: RaisedButton(
              color: Colors.white,
              elevation: 10,
              onPressed: (){},
              child: ListTile(
                dense: true,
                contentPadding: EdgeInsets.all(5),
                leading: Image.asset("assets/Purchased/DC_Motor.jpg",fit: BoxFit.fill,),
                title: Text("DC Motor"),
                subtitle: Text("DC 12V 5500 RPM Cylindrical Miniature Machine Magnetic Tool Motor R555"),
                trailing:  Text("P50.00"),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(5),
            child: RaisedButton(
              color: Colors.white,
              elevation: 10,
              onPressed: (){},
              child: ListTile(
                dense: true,
                contentPadding: EdgeInsets.all(5),
                leading: Image.asset("assets/Purchased/GearStick.jpg",fit: BoxFit.fill,),
                title: Text("Gear Stick"),
                subtitle: Text("DC 12V 5500 RPM Cylindrical Miniature Machine Magnetic Tool Motor R555"),
                trailing:  Text("P150.00"),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(5),
            child: RaisedButton(
              color: Colors.white,
              elevation: 10,
              onPressed: (){},
              child: ListTile(
                dense: true,
                contentPadding: EdgeInsets.all(5),
                leading: Image.asset("assets/Purchased/MotorController.jpg",fit: BoxFit.fill,),
                title: Text("Motor Speed Controller"),
                subtitle: Text("1.8v 3v 5v 6v 7.2v 12v 2A 30W DC Motor Speed Controller (PWM) 1803BK Adjustable Driver Switch - intl"),
                trailing:  Text("105.00"),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(5),
            child: RaisedButton(
              color: Colors.white,
              elevation: 10,
              onPressed: (){},
              child: ListTile(
                dense: true,
                contentPadding: EdgeInsets.all(5),
                leading: Image.asset("assets/Purchased/WindShield.jpg",fit: BoxFit.fill,),
                title: Text("Windscreen Windshield"),
                subtitle: Text("For Honda CBR600RR CBR 600 RR 2007 2008 2009 2010 2011 2012 Motorcycle Double Bubble Windscreen Windshield Shield Screen Clear"),
                trailing:  Text("750.00"),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(5),
            child: RaisedButton(
              color: Colors.white,
              elevation: 10,
              onPressed: (){},
              child: ListTile(
                dense: true,
                contentPadding: EdgeInsets.all(5),
                leading: Image.asset("assets/Purchased/Wiper.jpg",fit: BoxFit.fill,),
                title: Text("Wiper blades"),
                subtitle: Text("Wiper blades for Chevrolet Trailblazer (2013 onwards), 22' + 18', bracketless, windscreen"),
                trailing:  Text("520.00"),
              ),
            ),
          ),
        ],
      ),
    );
  }

}