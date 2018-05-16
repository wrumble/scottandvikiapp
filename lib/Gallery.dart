import 'package:flutter/material.dart';
import 'package:scott_and_viki/Text/TitleText.dart';
import 'package:scott_and_viki/Constants/FontNames.dart';
import 'dart:async';
import 'dart:io';
import 'FireImage.dart';
import 'FireImageView.dart';
import 'package:firebase_database/firebase_database.dart';

var backgroundImage = new BoxDecoration(
  image: new DecorationImage(
    image: new AssetImage('assets/background.png'),
    fit: BoxFit.cover,
  ),
);

class GalleryFolderView {
  String uuid;
  String name;
  String firstImageUrl;

  GalleryFolderView(this.uuid, this.name, this.firstImageUrl);
}

class Gallery extends StatefulWidget {
  @override
  GalleryState createState() => new GalleryState();
}

class GalleryState extends State<Gallery>  {

  var reference;

  List<FireImage> imageList;

  Future<Null> getReference() async {

    setState(() {
      reference = FirebaseDatabase.instance.reference().child("AllUsers");
      print(reference);
      print(reference);
      print(reference);
      print(reference);
    });
  }

  @override void initState() {
    super.initState();

    getReference();
  }

  @override
  Widget build(BuildContext context) {

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

    return new Scaffold(
      appBar: new AppBar(
        title: new TitleText("Gallery", 30.0),
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
                        new  SizedBox(height: 32.0),
                        new Container(
                          child: new Text('No images have been uploaded yet. Go back and tap "Take a photo" to upload the first photo.',
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
                                                    new MaterialPageRoute(builder: (context) => new FireImageView(image)),
                                                  );
                                                },
                                              ),
                                            ),
                                            new Positioned(
                                              child: new Container(
                                                child: new FloatingActionButton(
                                                  onPressed: () => null,
                                                  child: new Icon(
                                                    Icons.delete,
                                                    size: 20.0,
                                                  ),
                                                  heroTag: image.key,
                                                ),
                                                height: 30.0,
                                                width: 30.0,
                                              ),
                                              bottom: 6.0,
                                              left: 6.0,
                                            )
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
                              )
                            ],
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