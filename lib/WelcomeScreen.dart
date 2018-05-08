import 'package:flutter/material.dart';
import 'package:scott_and_viki/Constants/FontNames.dart';
import 'package:scott_and_viki/Text/TitleText.dart';
import 'Localisations.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    var backgroundImage = new BoxDecoration(
      image: new DecorationImage(
        image: new AssetImage('assets/background.png'),
        fit: BoxFit.cover,
      ),
    );
    var titleText = new TitleText(Localize.of(context).appTitle);
    var doneButton = new FlatButton(
      textColor: Colors.white,
      color: Colors.black,
      onPressed: () => () {
        Navigator.pushReplacement(
          context,
          new MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      },
      child: new Text('Done!',
        style: new TextStyle(fontFamily: FontName.normalFont,
            fontSize: 30.0,
            color: Colors.white),
      ),
    );
    double getBottomMargin() {
      var mediaQuery = MediaQuery.of(context);
      if (Platform.isIOS) {
        var size = mediaQuery.size;
        if (size.height == 812.0 || size.width == 812.0) {
          return mediaQuery.padding.bottom;
        }
      }
      return mediaQuery.padding.bottom + 8;
    }

    var requestTextContainer = new Container(
        child: new Text("Please enter your first and last name.",
          style: new TextStyle(
              fontFamily: FontName.normalFont,
              fontSize: 30.0,
              color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
        margin: new EdgeInsets.only(left: 8.0, top: 16.0, right: 8.0, bottom: 8.0),
        padding: new EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0, bottom: 8.0),
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

    var firstNameField = new TextFormField(
      decoration: new InputDecoration(
          labelText: 'First Name'
      ),
    );

    var lastNameField = new TextFormField(
      style: new TextStyle(
        fontFamily: FontName.normalFont,
        fontSize: 20.0,
        color: Colors.black,
      ),
      keyboardType: TextInputType.text,
      autofocus: true,
      decoration: new InputDecoration(
        labelText: 'Last Name',
        fillColor: Colors.white,

      ),
    );

    var mainContainer = new Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        new Expanded(
          child: new Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    requestTextContainer
                  ],
                ),
                firstNameField,
                lastNameField,
                new Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Container(
                      height: 44.0,
                      width: MediaQuery.of(context).size.width,
                      child: doneButton,
                      margin: new EdgeInsets.only(bottom: getBottomMargin(), top: 8.0),
                    )],
                ),
              ]
          ),
        )
      ],
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