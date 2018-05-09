import 'package:flutter/material.dart';
import 'package:scott_and_viki/Constants/FontNames.dart';
import 'package:scott_and_viki/Text/TitleText.dart';
import 'Localisations.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';

class WelcomeScreen extends StatelessWidget {
  @override

  void initState() {
    _controller.addListener(onChange);
    _textFocus.addListener(onChange);
  }

  TextEditingController _controller = new TextEditingController();

  FocusNode _textFocus = new FocusNode();

  void onChange(){
    String text = _controller.text;
    bool hasFocus = _textFocus.hasFocus;
    //do your text transforming
    _controller.text = newText;
    _controller.selection = new TextSelection(
        baseOffset: newText.length,
        extentOffset: newText.length
    );
  }

  Widget build(BuildContext context) {

    var backgroundImage = new BoxDecoration(
      image: new DecorationImage(
        image: new AssetImage('assets/background.png'),
        fit: BoxFit.cover,
      ),
    );

    var titleText = new TitleText(Localize.of(context).appTitle);

    var requestTextContainer = new Container(
        child: new Text("Please enter your first and last name.",
          style: new TextStyle(
              fontFamily: FontName.normalFont,
              fontSize: 30.0,
              color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        margin: new EdgeInsets.only(top: 16.0, bottom: 8.0),
        padding: new EdgeInsets.only(left: 8.0, top: 16.0, right: 8.0, bottom: 8.0),
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



    var firstNameContainer = new Container(
        child: new TextFormField(
          controller: _controller,
          focusNode: _textFocus,
          style: new TextStyle(
            fontFamily: FontName.normalFont,
            fontSize: 25.0,
            color: Colors.black,
          ),
          keyboardType: TextInputType.text,
          autofocus: true,
          decoration: new InputDecoration(
            labelText: 'First Name',
            fillColor: Colors.white,

          ),
        ),
        margin: new EdgeInsets.only(top: 16.0, bottom: 8.0),
        padding: new EdgeInsets.only(left: 8.0, right: 8.0, bottom: 16.0),
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

    var lastNameContainer = new Container(
        child: new TextFormField(
          style: new TextStyle(
            fontFamily: FontName.normalFont,
            fontSize: 25.0,
            color: Colors.black,
          ),
          keyboardType: TextInputType.text,
          autofocus: true,
          decoration: new InputDecoration(
            labelText: 'Last Name',
            fillColor: Colors.black
          ),
        ),
        margin: new EdgeInsets.only(top: 16.0, bottom: 16.0),
        padding: new EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
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

    var passwordContainer = new Container(
        child: new TextFormField(
          style: new TextStyle(
            fontFamily: FontName.normalFont,
            fontSize: 25.0,
            color: Colors.black,
          ),
          keyboardType: TextInputType.text,
          autofocus: true,
          decoration: new InputDecoration(
            labelText: 'Password',
            fillColor: Colors.white,

          ),
        ),
        margin: new EdgeInsets.only(top: 16.0, bottom: 16.0),
        padding: new EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
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

    void showHomeScreen() {
      Navigator.pushReplacement(
        context,
        new MaterialPageRoute(builder: (context) => new HomeScreen()),
      );
    }

    var doneButton = new FlatButton(
      textColor: Colors.white,
      padding: new EdgeInsets.only(top: 8.0, bottom: 8.0),
      color: Colors.black,
      onPressed: () => showHomeScreen(),
      child: new Text('Done!',
        style: new TextStyle(fontFamily: FontName.normalFont,
            fontSize: 30.0,
            color: Colors.white),
      ),
    );

    var list = [
      requestTextContainer,
      firstNameContainer,
      lastNameContainer,
      passwordContainer,
      doneButton
    ];

    var listView = new ListView.builder(
        itemCount: list.length,
        itemBuilder: (BuildContext context, int index) {
          return new Container(
              child: list[index]
          );
        });

    var mainContainer = new Container(
        height: double.infinity,
        width: double.infinity,
        decoration: backgroundImage,
        child: new Container(
          child: listView,
        )
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