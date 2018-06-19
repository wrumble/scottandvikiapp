import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Factories/BridesmaidFactory.dart';


var backgroundImage = new BoxDecoration(
  image: new DecorationImage(
    image: new AssetImage('assets/background.png'),
    fit: BoxFit.cover,
  ),
);

class TheBridesmaids extends StatefulWidget {

  @override
  TheBridesmaidsState createState() {
    return new TheBridesmaidsState();
  }
}

class TheBridesmaidsState extends State<TheBridesmaids> {

  @override void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  Widget build(BuildContext context) {

    var titleText = new Text('The Bridesmaids',
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
          new Expanded(
            child: new Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Expanded(
                    child: new Container(
                      child: new BridesmaidFactory(),
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