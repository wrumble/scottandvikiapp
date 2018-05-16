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

class OtherUserFireImageView extends StatefulWidget {
  final FireImage image;

  OtherUserFireImageView(this.image);

  @override
  OtherUserFireImageViewState createState() => new OtherUserFireImageViewState(image);
}

class OtherUserFireImageViewState extends State<OtherUserFireImageView>  {
  final FireImage image;

  var reference;
  var uuid;
  var userName;
  var folderName;

  OtherUserFireImageViewState(this.image);

  timeFromDate() {
    var formatter = new DateFormat.jm();
    return formatter.format(image.dateTime).toString();
  }

  Future<Null> getReference() async {
    final instance = await SharedPreferences.getInstance();
    uuid = instance.getString("UUID");
    userName = instance.getString("FullName");
    folderName = "$userName";

    setState(() {
      reference = FirebaseDatabase.instance.reference().child("AllUsers").child(uuid).child(folderName).orderByChild("count").onValue;
    });
  }

  @override void initState() {
    super.initState();

    getReference();
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
      body: mainContainer,
    );
  }
}