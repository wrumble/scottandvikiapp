import 'package:flutter/material.dart';
import 'package:scott_and_viki/Text/TitleText.dart';
import 'package:scott_and_viki/Constants/FontNames.dart';
import 'dart:async';
import 'dart:io';
import 'FireImage.dart';
import 'GalleryFolderView.dart';
import 'OtherUserFireImageView.dart';
import 'package:firebase_database/firebase_database.dart';
import 'VideoPlayer.dart';
import 'package:video_player/video_player.dart';

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

  var playIcon = new Container(
    padding: new EdgeInsets.all(16.0),
    child: new Image.asset("assets/playVideo.png"),
  );

  var placeHolder = new Column(
    children: <Widget>[
      new Center(
        child: CircularProgressIndicator(),
      ),
      new Container(
        child: new Text('Loading images...',
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
                return placeHolder;
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
                                        child: new Text('$firstName hasn\'t uploaded any images yet, or deleted what they did, what are they hiding!?',
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
                    var thumbnailUrl = value["thumbnailUrl"];
                    var url = value["url"];
                    var isAnImage = value["isAnImage"];
                    FireImage image = new FireImage(name, dateTime, count, thumbnailUrl, url, isAnImage);
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
                                                child: image.isAnImage ? new Image.network(image.url, scale: 0.1) : playIcon,
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    new MaterialPageRoute(builder: (context) => image.isAnImage ? new OtherUserFireImageViewState(image) : new NetworkPlayerLifeCycle(
                                                      image.url,
                                                          (BuildContext context, VideoPlayerController controller) =>
                                                      new AspectRatioVideo(controller, image),
                                                    ) ),
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