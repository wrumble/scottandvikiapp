import 'package:flutter/material.dart';
import 'package:scott_and_viki/Text/TitleText.dart';
import 'package:scott_and_viki/Constants/FontNames.dart';
import 'dart:async';
import 'dart:io';
import 'FireImage.dart';
import 'GalleryFolderView.dart';
import 'OtherUserFireImageView.dart';
import 'package:firebase_database/firebase_database.dart';

var backgroundImage = new BoxDecoration(
  image: new DecorationImage(
    image: new AssetImage('assets/background.png'),
    fit: BoxFit.cover,
  ),
);

class OtherUserImages extends StatefulWidget {
  final GalleryFolderView userInfo;

  OtherUserImages(this.userInfo);

  @override
  OtherUserImagesState createState() => new OtherUserImagesState(userInfo);
}

class OtherUserImagesState extends State<OtherUserImages>  {
  final GalleryFolderView userInfo;

  OtherUserImagesState(this.userInfo);

  Future<File> imageFile;
  File savedImage;

  var reference;
  var uuid;
  var userName;
  var firstName;

  List<FireImage> imageList;

  Future<Null> getReference() async {
    uuid = userInfo.uuid;
    userName = userInfo.name;
    firstName = userName.substring(0, userName.indexOf(' '));
    setState(() {
      reference = FirebaseDatabase.instance.reference().child("AllUsers").child(uuid).child("images").orderByChild("count").onValue;
    });
  }

  @override void initState() {
    super.initState();

    getReference();
  }

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      appBar: new AppBar(
        title: new TitleText(firstName, 25.0),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: new StreamBuilder<Event>(
          stream: reference,
          builder: (BuildContext context, AsyncSnapshot<Event> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.none:
                return new Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: backgroundImage,
                  child: new Column(
                    children: <Widget>[
                      new  SizedBox(height: 32.0),
                      new Container(
                        child: new Text('Loading images ... ',
                          textAlign: TextAlign.center,
                          style: new TextStyle(
                              fontFamily: FontName.normalFont,
                              fontSize: 25.0,
                              color: Colors.black
                          ),
                        ),
                        padding: new EdgeInsets.all(16.0),
                        margin: new EdgeInsets.only(left: 8.0, right: 8.0),
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
                      ),
                    ],
                  ),
                );
              default:
                if ( snapshot.data.snapshot.value == null ){
                  return new Container(
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
                                  child: new Column(
                                    children: <Widget>[
                                      new  SizedBox(height: 32.0),
                                      new Container(
                                        child: new Text('You havent uploaded any images yet. Go back and tap "Take a photo" to upload your first image.',
                                          textAlign: TextAlign.center,
                                          style: new TextStyle(
                                              fontFamily: FontName.normalFont,
                                              fontSize: 25.0,
                                              color: Colors.black
                                          ),
                                        ),
                                        padding: new EdgeInsets.all(16.0),
                                        margin: new EdgeInsets.only(left: 8.0, right: 8.0),
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
                                      ),
                                    ],
                                  )
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                } else {
                  Map content = snapshot.data.snapshot.value;
                  imageList = new List<FireImage>();
                  content.forEach((key, value) {
                    var name = value["name"];
                    var dateTime = new DateTime.fromMillisecondsSinceEpoch(value["dateTime"]);
                    var count = value["count"];
                    var url = value["url"];
                    FireImage image = new FireImage(name, dateTime, count, url);
                    image.key = key;
                    imageList.add(image);
                  });

                  return new Container(
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
                                  child: new GridView.count(
                                    crossAxisCount: 3,
                                    padding: new EdgeInsets.all(8.0),
                                    mainAxisSpacing: 16.0,
                                    crossAxisSpacing: 16.0,
                                    children: imageList.map((FireImage image) {
                                      return new Container(
                                        child: new Stack(
                                          children: <Widget>[
                                            new Center(
                                              child: new InkWell(
                                                child: new Image.network(image.url),
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    new MaterialPageRoute(builder: (context) => new OtherUserFireImageView(image)),
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                        decoration: new BoxDecoration(
                                            color: Colors.black,
                                            boxShadow: [
                                              new BoxShadow(
                                                  color: Colors.black38,
                                                  blurRadius: 5.0,
                                                  offset: new Offset(3.0, 5.0)
                                              ),
                                            ]
                                        ) ,
                                      );
                                    }).toList(),
                                  )
                              )],
                          ),
                        )
                      ],
                    ),
                  );
                }
            }
          }
      ),
    );
  }
}