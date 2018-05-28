import 'package:flutter/material.dart';
import 'package:zoomable_image/zoomable_image.dart';
import 'package:intl/intl.dart';
import 'FireImage.dart';
import 'dart:io';
import 'dart:async';
import 'package:scott_and_viki/Constants/FontNames.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FireImageView extends StatefulWidget {
  final FireImage image;

  FireImageView(this.image);

  @override
  FireImageViewState createState() => new FireImageViewState(image);
}

class FireImageViewState extends State<FireImageView>  {
  final FireImage image;

  var uuid;
  var folderName;

  FireImageViewState(this.image);

  timeFromDate() {
    var formatter = new DateFormat.jm();
    return formatter.format(image.dateTime).toString();
  }

  Future<Null> init() async {
    final instance = await SharedPreferences.getInstance();
    uuid = instance.getString("UUID");
  }

  @override void initState() {
    super.initState();

    init();
  }

  Future<Null> showDialogue(BuildContext viewContext) async {
    return showDialog<Null>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text('Delete image?',
            style: new TextStyle(
                fontFamily: FontName.titleFont,
                fontSize: 25.0,
                color: Colors.black
            ),
          ),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                new Text('Are you sure you want to delete this image?',
                  style: new TextStyle(
                      fontFamily: FontName.normalFont,
                      fontSize: 25.0,
                      color: Colors.black
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text('Yes',
                style: new TextStyle(
                    fontFamily: FontName.normalFont,
                    fontSize: 25.0,
                    color: Colors.black
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                deleteImage(viewContext);
              },
            ),
            new FlatButton(
              child: new Text('No',
                style: new TextStyle(
                    fontFamily: FontName.normalFont,
                    fontSize: 25.0,
                    color: Colors.black
                ),
              ),
              onPressed: () { Navigator.of(context).pop(); },
            ),
          ],
        );
      },
    );
  }

  void deleteImage(BuildContext context) async {
    FirebaseDatabase.instance.reference().child("AllUsers").child(uuid).child("images").child(image.key).remove().then( (success) {
      FirebaseStorage.instance.ref().child("AllUsers").child(uuid).child(image.name).delete();
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {

    var titleText = new Text(timeFromDate(),
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
      onPressed: () {
        showDialogue(context);
      },
      child: new Text("Delete photo",
        style: new TextStyle(
            fontFamily: FontName.normalFont,
            fontSize: 30.0,
            color: Colors.white),
      ),
    );

    var placeHolder = new Column(
      children: <Widget>[
        new Center(
          child: CircularProgressIndicator(),
        ),
        new Container(
          child: new Text('Loading image...',
            textAlign: TextAlign.center,
            style: new TextStyle(
                fontFamily: FontName.normalFont,
                fontSize: 25.0,
                color: Colors.black
            ),
          ),
          padding: new EdgeInsets.all(16.0),
          margin: new EdgeInsets.only(top: 16.0, left: 8.0, right: 8.0),
          decoration: new BoxDecoration(
              color: Colors.white,
              boxShadow: [
                new BoxShadow(
                    color: Colors.black38,
                    blurRadius: 5.0,
                    offset: new Offset(3.0, 5.0)
                ),
              ]
          ),
        )
      ],
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
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
                        placeholder: placeHolder,
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