import 'package:flutter/material.dart';

var backgroundImage = new BoxDecoration(
  image: new DecorationImage(
    image: new AssetImage('assets/background.png'),
    fit: BoxFit.cover,
  ),
);

class OrderOfTheDay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    var titleText = new Text('Order of the day',
        style: new TextStyle(fontFamily: 'CallingAngelsPersonalUse',
            fontSize: 30.0,
            color: Colors.white)
    );
    var mainContainer = new Container(
        height: double.infinity,
        width: double.infinity,
        decoration: backgroundImage,
        child: new Column(
            children: <Widget>[
              new Container(
                  child: new Text("12:30 - Wedding ceremony at St Dunstan’s Church, Mayfield followed by the wedding breakfast at Juddwood Farm",
                      style: new TextStyle(
                          fontFamily: 'DancingScript-Regular',
                          fontSize: 28.0,
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
              ),
              new Container(
                  child: new Text("19:30 - Evening reception at Juddwood Farm where there will be a cash bar until midnight and a small buffet to keep your dancing energy up!",
                    style: new TextStyle(
                        fontFamily: 'DancingScript-Regular',
                        fontSize: 28.0,
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
              )
            ])
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