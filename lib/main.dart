import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'Localisations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:map_view/map_view.dart';

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
  Future<File> _imageFile;

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

    var container1 = new Container(
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
    var container2 = new Container(
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
    var container3 = new Container(
      margin: EdgeInsets.all(8.0),
      child: new Stack(
        children: <Widget>[
          new Image(image: new AssetImage('assets/3.jpg')),
          new Positioned(
            left: 8.0,
            bottom: 8.0,
            child: new Text('Hotels and Taxis',
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
    var container4 = new Container(
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
    var container5 = new Container(
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
    var container6 = new Container(
      margin: EdgeInsets.all(8.0),
      child: new Stack(
        children: <Widget>[
          new Image(image: new AssetImage('assets/6.jpg')),
          new Positioned(
            left: 8.0,
            bottom: 8.0,
            child: new Text('Camping',
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

    var containers = [container1, container2, container3, container4, container5, container6];
    var screens = [new OrderOfTheDay(), new MapsAndDirections(), new HotelsAndTaxis(), new TheBridesmaids(), new TheGroomsmen(), new Camping()];
    var listView = new ListView.builder(
        itemCount: 6,
        itemBuilder: (BuildContext context, int index) {
          return new GestureDetector( //You need to make my child interactive
            onTap: () {
              Navigator.push(
                context,
                new MaterialPageRoute(builder: (context) => screens[index]),
              );
            },
            child: containers[index]
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

class MapsAndDirections extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var titleText = new Text('Maps and Directions',
        style: new TextStyle(fontFamily: 'CallingAngelsPersonalUse',
            fontSize: 25.0,
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

class HotelsAndTaxis extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var titleText = new Text('Hotels and Taxis',
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

class TheBridesmaids extends StatelessWidget {
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

class TheGroomsmen extends StatelessWidget {
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

class Camping extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var titleText = new Text('Camping',
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