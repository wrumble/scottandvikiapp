import 'package:flutter/material.dart';
import 'ChurchMap.dart';

var backgroundImage = new BoxDecoration(
  image: new DecorationImage(
    image: new AssetImage('assets/background.png'),
    fit: BoxFit.cover,
  ),
);

class MapsAndDirections extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    void _onHotelMApButtonPressed() {
      var hotelMap = ChurchMap();
      hotelMap.showMap();
    }

    var titleText = new Text('Maps and Directions',
        style: new TextStyle(fontFamily: 'CallingAngelsPersonalUse',
            fontSize: 25.0,
            color: Colors.white)
    );
    var hotelMapButton = new FlatButton(
      textColor: Colors.white,
      color: Colors.black,
      onPressed: () => _onHotelMApButtonPressed(),
      child: new Text('View Church On Map',
        style: new TextStyle(fontFamily: 'DancingScript-Regular',
            fontSize: 30.0,
            color: Colors.white),
      ),
    );
    var mainContainer = new Container(
        height: double.infinity,
        width: double.infinity,
        decoration: backgroundImage,
        child: new Column(
            children: <Widget>[
              new Container(
                child: hotelMapButton,
                margin: new EdgeInsets.only(left: 8.0, top: 16.0, right: 8.0, bottom: 8.0),
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