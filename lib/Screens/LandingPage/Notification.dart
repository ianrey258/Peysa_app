import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pyesa_app/Controller/Controller.dart';
import 'package:pyesa_app/Models/User.dart';

class Notifications extends StatefulWidget{
  Notificationstate createState() => Notificationstate();
}
class Notificationstate extends State<Notifications>{
  ScrollController _sc;
  List<Map> notificationType = [];
  bool refresh = false;

  @override
  void initState(){
    super.initState();
    initNotType();
  }

  Future<Null> refreshList()async{ 
    await Future.delayed(Duration(seconds: 1));
    refreshState();
  }

  refreshState(){
    setState(() {
      refresh = !refresh ? true : false; 
    });
  }

  void initNotType() async {
    refreshState();
    notificationType = await DataController.getNotificationType();
  }

  void notBtn(UserNotification data) async {
    data.status = '9';
    if(notificationType[0]['id'] == data.notificationType){
      Navigator.popAndPushNamed(context, 'RequestItem');
    } else if(notificationType[1]['id'].toString() == data.notificationType){
      Navigator.popAndPushNamed(context, 'MyStore');
    } else if(notificationType[2]['id'] == data.notificationType){
      Navigator.popAndPushNamed(context, 'Purchases');
    } else if(notificationType[3]['id'] == data.notificationType){
      Navigator.popAndPushNamed(context, 'RequestItem');
    } else if(notificationType[4]['id'] == data.notificationType){
      return null;
    }
    await DataController.updateNotification(data.toMapWid());
  }

  Widget notificationContainer(UserNotification data){
    var title = '';
    notificationType.forEach((element){if(element['id'] == data.notificationType){title = element['notificationType'];}});
    var color = data.status != '9' ? Colors.black12 : Colors.white;
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.blue)),
        color: color
      ),
      child: ListTile(
        onTap: (){notBtn(data);},
        title: Row(
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Text(title),
            ),
            Expanded(
              child: Container(),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Text(data.dateRecieved),
            ),
          ],
        ),
        subtitle: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Text(data.message)
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
    );
  }
  

  Widget notification(){
    return RefreshIndicator(
      child: FutureBuilder<List>(
        future: DataController.getNotification(),
        builder: (_,result){
          if(result.connectionState == ConnectionState.done){
            if(result.hasData){
              List data = result.data;
              return ListView.builder(
                //reverse: true,
                controller: _sc,
                itemCount: result.data.length,
                itemBuilder: (_,i){
                  return notificationContainer(UserNotification.toObect(data[result.data.length - i -1]));
                }
              );
            }
            return Container();
          }
          return Container();
        },
      ), 
      onRefresh: refreshList
    );
  }


  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text("Notification"),
      ),
      body: notification()
    );
  }

}