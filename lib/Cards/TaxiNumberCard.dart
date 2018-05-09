import 'package:flutter/material.dart';
import 'package:scott_and_viki/Factories/TaxiNumberFactory.dart';
import 'package:scott_and_viki/Constants/FontNames.dart';

var backgroundImage = new BoxDecoration(
  image: new DecorationImage(
    image: new AssetImage('assets/background.png'),
    fit: BoxFit.cover,
  ),
);

class TaxiNumberCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var titleText = new Text('Taxi numbers',
        style: new TextStyle(fontFamily: FontName.titleFont,
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
                      fontFamily: FontName.normalFont,
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
        boxShadow: [
          new BoxShadow(
              color: Colors.black38,
              blurRadius: 5.0,
              offset: new Offset(3.0, 5.0)
          ),
        ]
    )
    );

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
                      child: new TaxiNumberFactory(),
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