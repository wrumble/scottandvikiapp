import 'package:flutter/material.dart';
import 'package:scott_and_viki/Text/TitleText.dart';
import 'package:scott_and_viki/Constants/FontNames.dart';
import 'dart:async';
import 'FireImage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

var backgroundImage = new BoxDecoration(
  image: new DecorationImage(
    image: new AssetImage('assets/background.png'),
    fit: BoxFit.cover,
  ),
);

class MyImages extends StatefulWidget {
  @override
  MyImagesState createState() => new MyImagesState();
}

class MyImagesState extends State<MyImages>  {

  var reference;
  var uuid;
  var userName;
  var folderName;
  List<FireImage> imageList;

  Future<Null> getReference() async {
    final instance = await SharedPreferences.getInstance();
    uuid = instance.getString("UUID");
    userName = instance.getString("FullName");
    folderName = "$userName's Photos";

    setState(() {
      reference = FirebaseDatabase.instance.reference().child(uuid).child(folderName).orderByChild("count").onValue;
    });
  }

  @override void initState() {
    super.initState();

    getReference();
  }

  var titleText = new TitleText("My Images", 30.0);

  Future<Null> showDialogue(FireImage image) async {
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
                deleteImage(image);
                Navigator.of(context).pop();
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

  void deleteImage(FireImage image) async {
        FirebaseDatabase.instance.reference().child(uuid).child(folderName).child(image.key).remove().then( (success) {
            FirebaseStorage.instance.ref().child(uuid).child(folderName).child(image.name).delete();
        });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: titleText,
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
                                child:  new Image.network(image.url),
                              ),
                              new Positioned(
                                child: new Container(
                                  child: new FloatingActionButton(
                                    onPressed: () => showDialogue(image),
                                    child: new Icon(
                                      Icons.delete,
                                      size: 20.0,
                                    ),
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
                    ),
                  );
                }
            }
          }
      ),
    );
  }
}

