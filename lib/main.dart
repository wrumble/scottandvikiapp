import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'Localisations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:scott_and_viki/Text/TitleText.dart';
import 'package:map_view/map_view.dart';
import 'package:scott_and_viki/Constants/FontNames.dart';
import 'package:scott_and_viki/Factories/HomeScreenCardFactory.dart';

var backgroundImage = new BoxDecoration(
  image: new DecorationImage(
    image: new AssetImage('assets/background.png'),
    fit: BoxFit.cover,
  ),
);

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      onGenerateTitle: (BuildContext context) => Localize.of(context).appTitle,
      localizationsDelegates: [
        const LocalizeDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', '')
      ],
      // Watch out: MaterialApp creates a Localizations widget
      // with the specified delegates. DemoLocalizations.of()
      // will only find the app's Localizations widget if its
      // context is a child of the app.
      home: new MyApp(),
    );
  }
}

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      onGenerateTitle: (BuildContext context) => Localize.of(context).appTitle,
      localizationsDelegates: [
        const LocalizeDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', '')
      ],
      home: new HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<HomeScreen> {
  Future<File> imageFile;
  File savedImage;

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

    final String folderName = "Waynes Photos";
    final String imageName = "1";
    final String currentDateTime = "${DateTime.now()}";
    final StorageReference ref = FirebaseStorage.instance.ref().child(folderName).child('$imageName-$currentDateTime.jpg');
    final StorageUploadTask uploadTask = ref.putFile(savedImage, const StorageMetadata(contentLanguage: "en"));
    final Uri downloadUrl = (await uploadTask.future).downloadUrl;
    final http.Response downloadData = await http.get(downloadUrl);

    print(downloadUrl);
    print(downloadData);
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

    var titleText = new TitleText(Localize.of(context).appTitle);

    var cameraButton = new FlatButton(
      textColor: Colors.white,
      color: Colors.black,
      onPressed: () => _onImageButtonPressed(ImageSource.camera),
      child: new Text(Localize.of(context).takeAPhoto,
        style: new TextStyle(fontFamily: FontName.normalFont,
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
                new Expanded(child:
                    new Container(
                      child: new HomeScreenCardFactory(),
                    )
                ),
                new Container(
                  height: 44.0,
                  width: MediaQuery.of(context).size.width,
                  child: cameraButton,
                  margin: new EdgeInsets.only(bottom: getBottomMargin(), top: 8.0),
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