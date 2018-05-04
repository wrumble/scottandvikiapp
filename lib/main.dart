import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'Localisations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:map_view/map_view.dart';
import 'OrderOfTheDay.dart';
import 'MapsAndDirections.dart';
import 'TaxiNumbers.dart';
import 'TheBridesmaids.dart';
import 'TheGroomsmen.dart';
import 'Camping.dart';

var backgroundImage = new BoxDecoration(
  image: new DecorationImage(
    image: new AssetImage('assets/background.png'),
    fit: BoxFit.cover,
  ),
);

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      onGenerateTitle: (BuildContext context) => Localize.of(context).appTitle,
      localizationsDelegates: [
        const LocalizeDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', '')
      ],
      // Watch out: MaterialApp creates a Localizations widget
      // with the specified delegates. DemoLocalizations.of()
      // will only find the app's Localizations widget if its
      // context is a child of the app.
      home: new MyApp(),
    );
  }
}

void main() {
  MapView.setApiKey("AIzaSyA3V8XTkmpTZOeCTUd4J4WZceMOL_Cg-NU");
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      onGenerateTitle: (BuildContext context) => Localize.of(context).appTitle,
      localizationsDelegates: [
        const LocalizeDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', '')
      ],
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<File> _imageFile; //TODO: send to firebase

  void _onImageButtonPressed(ImageSource source) {
    setState(() {
      _imageFile = ImagePicker.pickImage(source: source);
    });
  }

  @override
  Widget build(BuildContext context) {

    getBottomMargin() {
      var mediaQuery = MediaQuery.of(context);
      if (Platform.isIOS) {
        var size = mediaQuery.size;
        if (size.height == 812.0 || size.width == 812.0) {
          return mediaQuery.padding.bottom;
        }
      }
      return mediaQuery.padding.bottom + 8;
    }

    var titleText = new Text(Localize.of(context).appTitle,
        style: new TextStyle(fontFamily: 'CallingAngelsPersonalUse',
        fontSize: 40.0,
        color: Colors.white)
    );

    var cameraButton = new FlatButton(
      textColor: Colors.white,
      color: Colors.black,
      onPressed: () => _onImageButtonPressed(ImageSource.camera),
      child: new Text(Localize.of(context).takeAPhoto,
        style: new TextStyle(fontFamily: 'DancingScript-Regular',
            fontSize: 30.0,
            color: Colors.white),
      ),
    );

    var orderOfTheDay = new Container(
      margin: EdgeInsets.all(8.0),
      child: new Stack(
        children: <Widget>[
          new Image(image: new AssetImage('assets/SVSunset.jpg')),
          new Positioned(
            left: 8.0,
            bottom: 8.0,
            child: new Text('Order of the day',
              style: new TextStyle(
                  fontFamily: 'CallingAngelsPersonalUse',
                  fontSize: 30.0,
                  color: Colors.white
              ),
            ),
          )
        ],
      ),
    );
    var mapsAndDirections = new Container(
      margin: EdgeInsets.all(8.0),
      child: new Stack(
        children: <Widget>[
          new Image(image: new AssetImage('assets/2.jpg')),
          new Positioned(
            left: 8.0,
            bottom: 8.0,
            child: new Text('Maps and Directions',
              style: new TextStyle(
                  fontFamily: 'CallingAngelsPersonalUse',
                  fontSize: 30.0,
                  color: Colors.white
              ),
            ),
          )
        ],
      ),
    );
    var taxiNumbers = new Container(
      margin: EdgeInsets.all(8.0),
      child: new Stack(
        children: <Widget>[
          new Image(image: new AssetImage('assets/3.jpg')),
          new Positioned(
            left: 8.0,
            bottom: 8.0,
            child: new Text('Taxi Numbers',
              style: new TextStyle(
                  fontFamily: 'CallingAngelsPersonalUse',
                  fontSize: 30.0,
                  color: Colors.black
              ),
            ),
          )
        ],
      ),
    );
    var theBridesmaids = new Container(
      margin: EdgeInsets.all(8.0),
      child: new Stack(
        children: <Widget>[
          new Image(image: new AssetImage('assets/4.jpg')),
          new Positioned(
            left: 8.0,
            bottom: 8.0,
            child: new Text('The Bridesmaids',
              style: new TextStyle(
                  fontFamily: 'CallingAngelsPersonalUse',
                  fontSize: 30.0,
                  color: Colors.white
              ),
            ),
          )
        ],
      ),
    );
    var theGroomsmen = new Container(
      margin: EdgeInsets.all(8.0),
      child: new Stack(
        children: <Widget>[
          new Image(image: new AssetImage('assets/5.jpg')),
          new Positioned(
            left: 8.0,
            bottom: 8.0,
            child: new Text('The Groomsmen',
              style: new TextStyle(
                  fontFamily: 'CallingAngelsPersonalUse',
                  fontSize: 30.0,
                  color: Colors.white
              ),
            ),
          )
        ],
      ),
    );

    var cardList = [theBridesmaids, theGroomsmen, orderOfTheDay, mapsAndDirections, taxiNumbers];
    var screens = [new TheBridesmaids(), new TheGroomsmen(), new OrderOfTheDay(), new MapsAndDirections(), new TaxiNumbers()];
    var listView = new ListView.builder(
        itemCount: cardList.length,
        itemBuilder: (BuildContext context, int index) {
          return new GestureDetector( //You need to make my child interactive
            onTap: () {
              Navigator.push(
                context,
                new MaterialPageRoute(builder: (context) => screens[index]),
              );
            },
            child: cardList[index]
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
                new Expanded(child:
                    new Container(
                      child: listView,
                    )
                ),
                new Container(
                  height: 44.0,
                  width: MediaQuery.of(context).size.width,
                  child: cameraButton,
                  margin: new EdgeInsets.only(bottom: getBottomMargin(), top: 8.0),
                )],
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
      body: mainContainer,
    );
  }
}