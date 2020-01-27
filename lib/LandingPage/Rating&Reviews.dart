import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RatingReviews extends StatefulWidget{
  RR createState() => RR();
}

class RR extends State<RatingReviews>{
  ScrollController _sc;

  Widget ratingWidget(int i,int vote){
    return Row(
      children: <Widget>[
        Expanded(
          child: RatingBar(
            itemCount: i,
            itemSize: 15,
            initialRating: double.parse(i.toString()),
            onRatingUpdate: (r){},
            itemBuilder: (context,_)=>Icon(
              Icons.star,
              color: Colors.amber
            ),
          ),
        ),
        Text(vote.toString())
      ],
    );
  }

  Widget build(BuildContext context){
  var size = MediaQuery.of(context).size;
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Color.fromRGBO(170, 0, 170, .7),
      title: Text("Reviews & Rating"),
      ),
      body: ListView(
        padding: EdgeInsets.all(0),
        controller: _sc,
        scrollDirection: Axis.vertical,
        children: <Widget>[
          Container(
            height: size.height*.4,
            //color: Color.fromRGBO(170, 0, 170, 1),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text("My Store",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w600
                    ),
                  ),
                ),
                Material(
                  elevation: 10,
                  child: Image.asset('assets/Store/StoreProfile.jpg',
                    fit: BoxFit.fill,
                    width: size.width*.8,
                    height: size.height*.25,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: RatingBar(
                    itemCount: 5,
                    itemSize: 20,
                    initialRating: 4.5,
                    glowRadius: 2.0,
                    allowHalfRating: true,
                    onRatingUpdate: (rating){},
                    itemBuilder: (context,_)=>Icon(
                      Icons.stars,
                      color: Colors.amber,
                    ),
                  ),
                ),
                Text("Rating 4.5")
              ],
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(child: Divider()),
              Text("Items Rate & Review",
                style: TextStyle(
                  fontWeight: FontWeight.w600
                ),
              ),
              Expanded(child: Divider())
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: RaisedButton(
              padding: EdgeInsets.all(5),
              onPressed: (){},
              elevation: 5,
              child: Container(
                height: MediaQuery.of(context).size.height*.2,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Image.asset('assets/Inventory/Athlon_200GE.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 5,),
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Text("Name : Athlon 200GE"),
                          ratingWidget(5, 5),
                          ratingWidget(4, 3),
                          ratingWidget(3, 6),
                          ratingWidget(2, 0),
                          ratingWidget(1, 0),
                          Text("Overall 14")
                        ],
                      ),
                    ),
                    Expanded(
                      child: Center(child: Text("Rating\n  3.9")),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: RaisedButton(
              padding: EdgeInsets.all(5),
              onPressed: (){},
              elevation: 5,
              child: Container(
                height: MediaQuery.of(context).size.height*.2,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Image.asset('assets/Inventory/HDD_Hp.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 5,),
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Text("Name : Toshiba 500gb"),
                          ratingWidget(5, 15),
                          ratingWidget(4, 3),
                          ratingWidget(3, 1),
                          ratingWidget(2, 0),
                          ratingWidget(1, 0),
                          Text("Overall 19")
                        ],
                      ),
                    ),
                    Expanded(
                      child: Center(child: Text("Rating\n  4.7")),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: RaisedButton(
              padding: EdgeInsets.all(5),
              onPressed: (){},
              elevation: 5,
              child: Container(
                height: MediaQuery.of(context).size.height*.2,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Image.asset('assets/Inventory/Ram.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 5,),
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Text("Name : DDR4 3600mhz"),
                          ratingWidget(5, 10),
                          ratingWidget(4, 5),
                          ratingWidget(3, 6),
                          ratingWidget(2, 0),
                          ratingWidget(1, 1),
                          Text("Overall 22")
                        ],
                      ),
                    ),
                    Expanded(
                      child: Center(child: Text("Rating\n  4.0")),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}