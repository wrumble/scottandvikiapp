import 'package:flutter/material.dart';
import 'package:scott_and_viki/Text/TitleText.dart';
import 'package:scott_and_viki/Constants/FontNames.dart';
import 'dart:async';
import 'dart:io';
import 'FireImage.dart';
import 'package:image_picker/image_picker.dart';
import 'FireImageView.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'Firebase.dart';
import 'UploadImage.dart';

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

  Future<File> imageFile;
  File savedImage;

  var reference;
  var uuid;
  List<FireImage> imageList;

  Future<Null> getReference() async {
    final instance = await SharedPreferences.getInstance();
    uuid = instance.getString("UUID");

    setState(() {
      reference = FirebaseDatabase.instance.reference().child("AllUsers").child(uuid).child("images").orderByChild("count").onValue;
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
        FirebaseDatabase.instance.reference().child("AllUsers").child(uuid).child("images").child(image.key).remove().then( (success) {
            FirebaseStorage.instance.ref().child("AllUsers").child(uuid).child(image.name).delete();
        });
  }

  void _onImageButtonPressed(ImageSource source) {
    setState(() {
      imageFile = ImagePicker.pickImage(source: source);
      imageFile.then((image) {
        savedImage = image;
        uploadFile();
      });
    });
  }

  Future<Null> uploadFile() async {
    var fb = Firebase();
    await fb.init();
    final instance = await SharedPreferences.getInstance();
    final count = instance.getInt("ImageCount");

    final image = new UploadImage(savedImage, new DateTime.now(), count);
    fb.saveImageFile(image);
  }

  @override
  Widget build(BuildContext context) {

    var uploadButton = new FlatButton(
      textColor: Colors.white,
      color: Colors.black,
      onPressed: () => _onImageButtonPressed(ImageSource.gallery),
      child: new Text("Upload a photo",
        style: new TextStyle(
            fontFamily: FontName.normalFont,
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
                              ),
                              new Container(
                                height: 44.0,
                                width: MediaQuery.of(context).size.width,
                                child: uploadButton,
                                margin: new EdgeInsets.only(bottom: getBottomMargin(), top: 8.0),
                              )],
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
                    FireImage image = new FireImage(name, dateTime, count, thumbnailUrl, url);
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
                                                child: new Image.network(image.thumbnailUrl),
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
                                                  onPressed: () => showDialogue(image),
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
                              ),
                              new Container(
                                height: 44.0,
                                width: MediaQuery.of(context).size.width,
                                child: uploadButton,
                                margin: new EdgeInsets.only(bottom: getBottomMargin(), top: 8.0),
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