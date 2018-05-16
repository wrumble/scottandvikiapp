import 'package:flutter/material.dart';
import 'package:zoomable_image/zoomable_image.dart';
import 'package:intl/intl.dart';
import 'FireImage.dart';
import 'dart:io';
import 'package:scott_and_viki/Constants/FontNames.dart';

class FireImageView extends StatefulWidget {
  final FireImage image;

  FireImageView(this.image);

  @override
  FireImageViewState createState() => new FireImageViewState(image);
}

class FireImageViewState extends State<FireImageView>  {
  final FireImage image;

  var timeOfPhoto;

  FireImageViewState(this.image);

  timeFromDate() {
    var formatter = new DateFormat.jm();
    return formatter.format(image.dateTime).toString();
  }

  @override void initState() {
    super.initState();

    timeOfPhoto = timeFromDate();
  }

  @override
  Widget build(BuildContext context) {

    var titleText = new Text(timeOfPhoto,
        style: new TextStyle(fontFamily: FontName.normalFont,
            fontSize: 30.0,
            color: Colors.white)
    );

    var backgroundImage = new BoxDecoration(
      image: new DecorationImage(
        image: new AssetImage('assets/background.png'),
        fit: BoxFit.cover,
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

    var deleteButton = new FlatButton(
      textColor: Colors.white,
      color: Colors.black,
      onPressed: () => { },
      child: new Text("Delete photo",
        style: new TextStyle(
            fontFamily: FontName.normalFont,
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
          new Expanded(
            child: new Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Expanded(
                    child: new Container(
                      child: new ZoomableImage(
                          new NetworkImage(image.url),
                        backgroundColor: Colors.transparent,
                      ),
                      margin: new EdgeInsets.all(8.0),
                    )
                ),
                new Container(
                  height: 44.0,
                  width: MediaQuery.of(context).size.width,
                  child: deleteButton,
                  margin: new EdgeInsets.only(bottom: getBottomMargin()),
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