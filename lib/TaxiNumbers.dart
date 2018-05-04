import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

var backgroundImage = new BoxDecoration(
  image: new DecorationImage(
    image: new AssetImage('assets/background.png'),
    fit: BoxFit.cover,
  ),
);

class TaxiNumbers extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var titleText = new Text('Taxi numbers',
        style: new TextStyle(fontFamily: 'CallingAngelsPersonalUse',
            fontSize: 30.0,
            color: Colors.white)
    );

    var tapToCall = new Container(
      width: MediaQuery.of(context).size.width,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Container(
              child: new Text("Tap a Number to call it",
                  textAlign: TextAlign.center,
                  style: new TextStyle(
                      fontFamily: 'CallingAngelsPersonalUse',
                      fontSize: 30.0,
                      color: Colors.white,
                  )
              ),
              margin: new EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0, bottom: 8.0),
            )
          ],
        ),
        margin: new EdgeInsets.only(top: 16.0),
        decoration: new BoxDecoration(
            color: Colors.black,
        )
    );

    var number1 = new Container(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              child: new InkWell(
                child: new Text("Keller Kars - 01892 541589",
                    textAlign: TextAlign.left,
                    style: new TextStyle(
                        fontFamily: 'DancingScript-Regular',
                        fontSize: 25.0,
                        color: Colors.black)
                ),
                onTap: () => launch("tel:01892 541589"),
              ),
              margin: new EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0, bottom: 8.0),
            )
          ],
        ),
        margin: new EdgeInsets.only(left: 8.0, top: 16.0, right: 8.0, bottom: 8.0),
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

    var number2 = new Container(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              child: new InkWell(
                child: new Text("Skyline Taxi - 01732 400200",
                    textAlign: TextAlign.left,
                    style: new TextStyle(
                        fontFamily: 'DancingScript-Regular',
                        fontSize: 25.0,
                        color: Colors.black)
                ),
                onTap: () => launch("tel:01732 400200"),
              ),
              margin: new EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0, bottom: 8.0),
            )
          ],
        ),
        margin: new EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0, bottom: 8.0),
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


    var number3 = new Container(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              child: new InkWell(
                child: new Text("Castle Cars - 01732 363637",
                    textAlign: TextAlign.left,
                    style: new TextStyle(
                        fontFamily: 'DancingScript-Regular',
                        fontSize: 25.0,
                        color: Colors.black)
                ),
                onTap: () => launch("tel:01732 363637"),
              ),
              margin: new EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0, bottom: 8.0),
            )
          ],
        ),
        margin: new EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0, bottom: 8.0),
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



    var number4 = new Container(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              child: new InkWell(
                child: new Text("Station Taxis - 01732 363636",
                    textAlign: TextAlign.left,
                    style: new TextStyle(
                        fontFamily: 'DancingScript-Regular',
                        fontSize: 25.0,
                        color: Colors.black)
                ),
                onTap: () => launch("tel:01732 363636"),
              ),
              margin: new EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0, bottom: 8.0),
            )
          ],
        ),
        margin: new EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0, bottom: 8.0),
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


    var number5 = new Container(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              child: new InkWell(
                child: new Text("Royal Cars - 01892 646646",
                    textAlign: TextAlign.left,
                    style: new TextStyle(
                        fontFamily: 'DancingScript-Regular',
                        fontSize: 25.0,
                        color: Colors.black)
                ),
                onTap: () => launch("tel:01892 646646"),
              ),
              margin: new EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0, bottom: 8.0),
            )
          ],
        ),
        margin: new EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0, bottom: 8.0),
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


    var number6 = new Container(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              child: new InkWell(
                child: new Text("AK Taxi - 01892 802803",
                    textAlign: TextAlign.left,
                    style: new TextStyle(
                        fontFamily: 'DancingScript-Regular',
                        fontSize: 25.0,
                        color: Colors.black)
                ),
                onTap: () => launch("tel:01892 802803"),
              ),
              margin: new EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0, bottom: 8.0),
            )
          ],
        ),
        margin: new EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0, bottom: 8.0),
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

    var number7 = new Container(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              child: new InkWell(
                child: new Text("Premier Cars - 01892 535535",
                    textAlign: TextAlign.left,
                    style: new TextStyle(
                        fontFamily: 'DancingScript-Regular',
                        fontSize: 25.0,
                        color: Colors.black)
                ),
                onTap: () => launch("tel:01892 535535"),
              ),
              margin: new EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0, bottom: 8.0),
            )
          ],
        ),
        margin: new EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0, bottom: 8.0),
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

    var number8 = new Container(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              child: new InkWell(
                child: new Text("Reliable Taxi - 07821 579982",
                    textAlign: TextAlign.left,
                    style: new TextStyle(
                        fontFamily: 'DancingScript-Regular',
                        fontSize: 25.0,
                        color: Colors.black)
                ),
                onTap: () => launch("tel:07821 579982"),
              ),
              margin: new EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0, bottom: 8.0),
            )
          ],
        ),
        margin: new EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0, bottom: 8.0),
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

    var number9 = new Container(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              child: new InkWell(
                child: new Text("Express Cars - 01892 535735",
                    textAlign: TextAlign.left,
                    style: new TextStyle(
                        fontFamily: 'DancingScript-Regular',
                        fontSize: 25.0,
                        color: Colors.black)
                ),
                onTap: () => launch("tel:01892 535735"),
              ),
              margin: new EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0, bottom: 8.0),
            )
          ],
        ),
        margin: new EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0, bottom: 8.0),
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

    var number9 = new Container(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              child: new InkWell(
                child: new Text("Joe's Taxi Service - 07941 504678",
                    textAlign: TextAlign.left,
                    style: new TextStyle(
                        fontFamily: 'DancingScript-Regular',
                        fontSize: 25.0,
                        color: Colors.black)
                ),
                onTap: () => launch("tel:07941 504678"),
              ),
              margin: new EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0, bottom: 8.0),
            )
          ],
        ),
        margin: new EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0, bottom: 8.0),
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

    var taxiList = [
      number1,
      number2,
      number3,
      number4,
      number5,
      number6,
      number7,
      number8,
      number9,
      number10
    ];

    var listView = new ListView.builder(
        itemCount: taxiList.length,
        itemBuilder: (BuildContext context, int index) {
          return new Container(
              child: taxiList[index]
          );
        });

    var mainContainer = new Container(
      height: double.infinity,
      width: double.infinity,
      decoration: backgroundImage,
      child: new Column(
        children: <Widget>[
          new Expanded(
            child: new Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                tapToCall,
                new Expanded(
                    child: new Container(
                      child: listView,
                    )
                )
              ],
            ),
          )
        ],
      ),
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