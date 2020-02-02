import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RequestItem extends StatefulWidget{
  RequestItemstate createState() => RequestItemstate();
}
class RequestItemstate extends State<RequestItem>{

   Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Requested Item"),
      ),
      body: Container(

      ),
    );
  }

}