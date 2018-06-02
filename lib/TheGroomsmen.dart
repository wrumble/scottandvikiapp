import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

var backgroundImage = new BoxDecoration(
  image: new DecorationImage(
    image: new AssetImage('assets/background.png'),
    fit: BoxFit.cover,
  ),
);

class TheGroomsmen extends StatefulWidget {

  @override
  TheGroomsmenState createState() {
    return new TheGroomsmenState();
  }
}

class TheGroomsmenState extends State<TheGroomsmen> {

  @override void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    var titleText = new Text('The Groomsmen',
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