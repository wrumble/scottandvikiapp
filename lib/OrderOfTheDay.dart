import 'package:flutter/material.dart';
import 'package:scott_and_viki/Text/TitleText.dart';
import 'package:flutter/services.dart';

var backgroundImage = new BoxDecoration(
  image: new DecorationImage(
    image: new AssetImage('assets/background.png'),
    fit: BoxFit.cover,
  ),
);

class OrderOfTheDay extends StatefulWidget {

  @override
  OrderOfTheDayState createState() {
    return new OrderOfTheDayState();
  }
}

class OrderOfTheDayState extends State<OrderOfTheDay> {

  @override void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  Widget build(BuildContext context) {

    var titleText = new TitleText('Order of the day', 30.0);

    var ceremonyContainer = new Container(
        child: new Text("12:30 - Wedding ceremony at St Dunstan’s Church, Mayfield",
            style: new TextStyle(
                fontFamily: 'DancingScript-Regular',
                fontSize: 30.0,
                color: Colors.black
            )
        ),
        margin: new EdgeInsets.only(left: 8.0, top: 16.0, right: 8.0, bottom: 8.0),
        padding: new EdgeInsets.only(left: 8.0, top: 8.0, right: 4.0, bottom: 4.0),
        decoration: new BoxDecoration(
            color: Colors.white,
            boxShadow: [
              new BoxShadow(
                  color: Colors.black38,
                  blurRadius: 5.0,
                  offset: new Offset(3.0, 5.0)
              ),
            ]
        )
    );

    var canapesContainer = new Container(
        child: new Text("14:30 Drinks reception with canapes at Juddwood Farm",
          style: new TextStyle(
              fontFamily: 'DancingScript-Regular',
              fontSize: 30.0,
              color: Colors.black
          ),
        ),
        margin: new EdgeInsets.all(8.0),
        padding: new EdgeInsets.only(left: 8.0, top: 8.0, right: 4.0, bottom: 4.0),
        decoration: new BoxDecoration(
            color: Colors.white,
            boxShadow: [
              new BoxShadow(
                  color: Colors.black38,
                  blurRadius: 5.0,
                  offset: new Offset(3.0, 5.0)
              ),
            ]
        )
    );

    var breakfastContainer = new Container(
        child: new Text("16:15 Wedding breakfast",
          style: new TextStyle(
              fontFamily: 'DancingScript-Regular',
              fontSize: 30.0,
              color: Colors.black
          ),
        ),
        margin: new EdgeInsets.all(8.0),
        padding: new EdgeInsets.only(left: 8.0, top: 8.0, right: 4.0, bottom: 4.0),
        decoration: new BoxDecoration(
            color: Colors.white,
            boxShadow: [
              new BoxShadow(
                  color: Colors.black38,
                  blurRadius: 5.0,
                  offset: new Offset(3.0, 5.0)
              ),
            ]
        )
    );

    var eveningContainer = new Container(
        child: new Text("19:30 Evening reception begins",
          style: new TextStyle(
              fontFamily: 'DancingScript-Regular',
              fontSize: 30.0,
              color: Colors.black
          ),
        ),
        margin: new EdgeInsets.all(8.0),
        padding: new EdgeInsets.only(left: 8.0, top: 8.0, right: 4.0, bottom: 4.0),
        decoration: new BoxDecoration(
            color: Colors.white,
            boxShadow: [
              new BoxShadow(
                  color: Colors.black38,
                  blurRadius: 5.0,
                  offset: new Offset(3.0, 5.0)
              ),
            ]
        )
    );

    var cakeContainer = new Container(
        child: new Text("19:45 Cutting the cake, followed by the first dance",
          style: new TextStyle(
              fontFamily: 'DancingScript-Regular',
              fontSize: 30.0,
              color: Colors.black
          ),
        ),
        margin: new EdgeInsets.all(8.0),
        padding: new EdgeInsets.only(left: 8.0, top: 8.0, right: 4.0, bottom: 4.0),
        decoration: new BoxDecoration(
            color: Colors.white,
            boxShadow: [
              new BoxShadow(
                  color: Colors.black38,
                  blurRadius: 5.0,
                  offset: new Offset(3.0, 5.0)
              ),
            ]
        )
    );

    var bandsContainer = new Container(
        child: new Text("19:45 Onwards - Mikey Gray and BringYour Sisters will be playing into the late evening. A small buffet will be served to keep your dancing energy up!",
          style: new TextStyle(
              fontFamily: 'DancingScript-Regular',
              fontSize: 30.0,
              color: Colors.black
          ),
        ),
        margin: new EdgeInsets.all(8.0),
        padding: new EdgeInsets.only(left: 8.0, top: 8.0, right: 4.0, bottom: 4.0),
        decoration: new BoxDecoration(
            color: Colors.white,
            boxShadow: [
              new BoxShadow(
                  color: Colors.black38,
                  blurRadius: 5.0,
                  offset: new Offset(3.0, 5.0)
              ),
            ]
        )
    );

    var barContainer = new Container(
        child: new Text("00:00 A cash bar will be open throughout the evening to close at midnight",
          style: new TextStyle(
              fontFamily: 'DancingScript-Regular',
              fontSize: 30.0,
              color: Colors.black
          ),
        ),
        margin: new EdgeInsets.all(8.0),
        padding: new EdgeInsets.only(left: 8.0, top: 8.0, right: 4.0, bottom: 4.0),
        decoration: new BoxDecoration(
            color: Colors.white,
            boxShadow: [
              new BoxShadow(
                  color: Colors.black38,
                  blurRadius: 5.0,
                  offset: new Offset(3.0, 5.0)
              ),
            ]
        )
    );

    var listContainers = [
      ceremonyContainer,
      canapesContainer,
      breakfastContainer,
      eveningContainer,
      cakeContainer,
      bandsContainer,
      barContainer
    ];

    var listView = new ListView.builder(
        itemCount: listContainers.length,
        itemBuilder: (BuildContext context, int index) {
          return new Container(
              child: listContainers[index]
          );
        });

    var mainContainer = new Container(
        height: double.infinity,
        width: double.infinity,
        decoration: backgroundImage,
        child: new Container(
          child: listView,
        )
    );

    return new Scaffold(
        appBar: new AppBar(
          title: titleText,
          backgroundColor: Colors.black,
          centerTitle: true,

        ),
        body: mainContainer
    );
  }
}