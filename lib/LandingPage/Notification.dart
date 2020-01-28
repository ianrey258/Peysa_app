import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Notifications extends StatefulWidget{
  Notificationstate createState() => Notificationstate();
}
class Notificationstate extends State<Notifications>{
  ScrollController _sc;

  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text("Notification"),
      ),
      body: ListView(
        controller: _sc,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.blue))),
            child: ListTile(
              onTap: (){},
              title: Text("New Store"),
              subtitle: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Congratulations! You can now Sell your Scrap Things Using this App.')
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text("Click for details",
                      style: TextStyle(
                        fontSize: 10
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.blue))),
            child: ListTile(
              onTap: (){},
              title: Text("New Store"),
              subtitle: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('There is new Store Nearby.')
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text("Click for details",
                      style: TextStyle(
                        fontSize: 10
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.blue))),
            child: ListTile(
              onTap: (){},
              title: Text("Request Item"),
              subtitle: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Marvin Bonani Requested an item.')
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text("Click for details",
                      style: TextStyle(
                        fontSize: 10
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(border: Border(bottom: BorderSide(color:Colors.blue))),
            child: ListTile(
              onTap: (){},
              title: Text("Reserve Item"),
              subtitle: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Vergar Dagondon Cash an item via Online Payment')
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text("Click for details",
                      style: TextStyle(
                        fontSize: 10
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

}