import 'package:flutter/material.dart';
import 'package:scott_and_viki/Text/TitleText.dart';
import 'package:scott_and_viki/Constants/FontNames.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'OtherUserImages.dart';
import 'MyImages.dart';
import 'GalleryFolderView.dart';
import 'dart:math' as math;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';

var backgroundImage = new BoxDecoration(
  image: new DecorationImage(
    image: new AssetImage('assets/background.png'),
    fit: BoxFit.cover,
  ),
);

class Gallery extends StatefulWidget {
  @override
  GalleryState createState() => new GalleryState();
}

class GalleryState extends State<Gallery>  {

  var reference;
  var ownerUUID;

  List<GalleryFolderView> folderList;

  Future<Null> getReference() async {
    final instance = await SharedPreferences.getInstance();
    final uuid = instance.getString("UUID");

    setState(() {
      ownerUUID = uuid;
      reference = FirebaseDatabase.instance.reference().child("AllUsers").onValue;
    });
  }
  @override initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp
    ]);

    getReference();
  }

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      appBar: new AppBar(
        title: new TitleText("Gallery", 30.0),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: new StreamBuilder<Event>(
          stream: reference,
          builder: (BuildContext context, AsyncSnapshot<Event> event) {
            switch (event.connectionState) {
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
                if (event.data.snapshot.value == null) {
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
                  var value = event.data.snapshot.value;
                  var uuids = value.keys;
                  folderList = new List<GalleryFolderView>();
                  for(var uuid in uuids) {
                    if (value[uuid]["images"] != null) {
                      var images = value[uuid]["images"].values;
                      var userName = value[uuid]["name"];
                      var lowestId = images.map((img) => img['count']).reduce((a, b) => math.min<int>(a, b));
                      var firstImage = images.firstWhere((img) => img['count']== lowestId);
                      var imageURL = firstImage['url'];
                      var folderView = GalleryFolderView(uuid, userName, imageURL);
                      folderList.add(folderView);
                      folderList.sort((a, b) => a.name.compareTo(b.name));
                    }
                  }
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
                                    crossAxisCount: 2,
                                    padding: new EdgeInsets.all(8.0),
                                    mainAxisSpacing: 16.0,
                                    crossAxisSpacing: 16.0,
                                    children: folderList.map((GalleryFolderView folderView) {
                                      return new Container(
                                        child: new Stack(
                                          children: <Widget>[
                                            new Center(
                                              child: new InkWell(
                                                child: new Image.network(folderView.firstImageUrl),
                                                onTap: () {
                                                  print(ownerUUID);
                                                  print(folderView.uuid);
                                                  var destinationView = ownerUUID == folderView.uuid ? new MyImages() : new OtherUserImages(folderView);
                                                  Navigator.push(context,
                                                    new MaterialPageRoute(builder: (context) => destinationView),
                                                  );
                                                },
                                              ),
                                            ),
                                            new Positioned(
                                              child: new Container(
                                                  child: new FittedBox(
                                                    fit: BoxFit.scaleDown,
                                                    child: new Text(
                                                      folderView.name,
                                                      style: new TextStyle(
                                                        fontFamily: FontName.normalFont,
                                                        fontSize: 18.0,
                                                        color: Colors.white,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                decoration: new BoxDecoration(
                                                    color: Colors.black54,
                                                ) ,
                                                height: 28.0,
                                              ),
                                              bottom: 0.0,
                                              left: 0.0,
                                              right: 0.0,
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
                                        ),
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