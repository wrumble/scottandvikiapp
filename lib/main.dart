import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'Localisations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:scott_and_viki/Text/TitleText.dart';
import 'package:scott_and_viki/Constants/FontNames.dart';
import 'package:scott_and_viki/Factories/HomeScreenCardFactory.dart';
import 'WelcomeScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    return new FutureBuilder<SharedPreferences>(
        future: SharedPreferences.getInstance(),
        builder:(BuildContext context, AsyncSnapshot<SharedPreferences> snapshot) {
          final String name = snapshot.data.getString('FullName');
          if (name == null) {
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
              theme: new ThemeData(
                canvasColor: Colors.black,
              ),
              home: new TextFormFieldDemo(),
            );
          } else {
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
              theme: new ThemeData(
                canvasColor: Colors.black,
              ),
              home: new HomeScreen(),
            );
          }
        }
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

    final instance = await SharedPreferences.getInstance();
    final uuid = instance.getString("UUID");
    print(uuid);
    final userName = instance.getString("FullName");
    print(userName);
    final int imageCount = instance.getInt("ImageCount");
    print(imageCount);
    final String folderName = "$userName's Photos";
    final String currentDateTime = "${DateTime.now()}";
    final StorageReference ref = FirebaseStorage.instance.ref().child(uuid).child(folderName).child('$imageCount-$currentDateTime.jpg');
    final StorageUploadTask uploadTask = ref.putFile(savedImage, const StorageMetadata(contentLanguage: "en"));
    final Uri downloadUrl = (await uploadTask.future).downloadUrl;
    final http.Response downloadData = await http.get(downloadUrl);
    print(downloadData);
    instance.setInt("ImageCount", imageCount + 1);
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
      drawer: new Drawer(
          child: new ListView(
            children: <Widget> [
              const SizedBox(height: 16.0),
              new ListTile(
                title: new Text('View Photos you\'ve uploaded',
                  style: new TextStyle(
                    fontFamily: FontName.normalFont,
                    fontSize: 25.0,
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              new Container(
                height: 1.0,
                margin: new EdgeInsets.only(top: 8.0, bottom: 8.0, left: 8.0, right: 8.0),
                decoration: new BoxDecoration(
                  color: Colors.white30,
                ),
              ),
              new ListTile(
                title: new Text('View everyone\'s photos that have been uploaded',
                  style: new TextStyle(
                    fontFamily: FontName.normalFont,
                    fontSize: 25.0,
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              new Container(
                height: 1.0,
                margin: new EdgeInsets.only(top: 8.0, bottom: 8.0, left: 8.0, right: 8.0),
                decoration: new BoxDecoration(
                  color: Colors.white30,
                ),
              ),
              new ListTile(
                title: new Text('Upload photos from your library',
                  style: new TextStyle(
                    fontFamily: FontName.normalFont,
                    fontSize: 25.0,
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              new Container(
                height: 1.0,
                margin: new EdgeInsets.only(top: 8.0, bottom: 8.0, left: 8.0, right: 8.0),
                decoration: new BoxDecoration(
                  color: Colors.white30,
                ),
              ),
              new ListTile(
                title: new Text('Delete photos you\'ve uploaded',
                  style: new TextStyle(
                    fontFamily: FontName.normalFont,
                    fontSize: 25.0,
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              new Container(
                height: 1.0,
                margin: new EdgeInsets.only(top: 8.0, bottom: 8.0, left: 8.0, right: 8.0),
                decoration: new BoxDecoration(
                  color: Colors.white30,
                ),
              ),
              new ListTile(
                title: new Text('Edit your name',
                  style: new TextStyle(
                    fontFamily: FontName.normalFont,
                    fontSize: 25.0,
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              )
            ],
          )
      ),
      body: mainContainer,
    );
  }
}