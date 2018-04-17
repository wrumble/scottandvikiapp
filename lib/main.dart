import 'package:flutter/material.dart';
import 'Localisations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() => runApp(new App());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var statusBarHeight = MediaQuery.of(context).padding.top;
    var titleText = new Text(Localize.of(context).appTitle,
        textAlign: TextAlign.center,
        style: new TextStyle(fontFamily: 'CallingAngelsPersonalUse',
        fontSize: 50.0,
        color: Colors.black)
    );
    var backgroundImage = new BoxDecoration(
        image: new DecorationImage(
         image: new AssetImage('assets/background.png'),
        fit: BoxFit.cover,
      ),
    );

    var mainContainer = new Container(
      padding: EdgeInsets.only(top: statusBarHeight),
      height: double.infinity,
      width: double.infinity,
      decoration: backgroundImage,
      child: new Column(
        children: <Widget>[
              new Container(
                margin: EdgeInsets.only(top: 10.0),
                child: titleText
          ),
        ],
      ),

    );

    return new Scaffold(
      body: mainContainer,
    );
  }
}

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
