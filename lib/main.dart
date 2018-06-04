import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'EditName.dart';
import 'Gallery.dart';
import 'package:image_picker/image_picker.dart';
import 'Localisations.dart';import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:scott_and_viki/Text/TitleText.dart';
import 'package:scott_and_viki/Constants/FontNames.dart';
import 'package:scott_and_viki/Factories/HomeScreenCardFactory.dart';
import 'WelcomeScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'MyImages.dart';
import 'Firebase.dart';
import 'Storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:video_player/video_player.dart';
import 'UploadImage.dart';
import 'package:camera/camera.dart';
import 'Camera.dart';
import 'package:flutter/services.dart';
import 'package:map_view/map_view.dart';

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

void main() async {
  getCameras();
  setupNotifications();
  checkFailedUploads();
  subscribeToConnectionState();
  MapView.setApiKey("AIzaSyACjRNbwrQpuRGVJ375jXJ8G0-AUTtSTX8");
  runApp(new MyApp());
}

List<CameraDescription> cameras;

getCameras() async {
  try {
    cameras = await availableCameras();
  } on CameraException catch (e) {
    logError(e.code, e.description);
  }
}

void setupNotifications() {
  final FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  _firebaseMessaging.requestNotificationPermissions();
}

void subscribeToConnectionState() {

  new Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      print("connection listener result: $result");
      checkFailedUploads();
  });
}

void checkFailedUploads() async {
  SharedPreferences instance = await SharedPreferences.getInstance();
  Storage storage = Storage();
  await storage.init();

  var hasImagesToUpload = instance.getBool("hasImagesToUpload") ?? false;
  print("has images to upload: $hasImagesToUpload");
  var hasVideosToUpload = instance.getBool("hasVideosToUpload") ?? false;
  print("has videos to upload: $hasVideosToUpload");
  var hasJsonToUpload = instance.getBool("hasJsonToUpload") ?? false;
  print("has json to upload: $hasJsonToUpload");

  if (hasImagesToUpload) {
    print("uploading Images");
    storage.uploadFailedImagesToStorage();
  }

  if (hasVideosToUpload) {
    print("uploading Videos");
    storage.uploadFailedVideosToStorage();
  }

  if (hasJsonToUpload) {
    print("uploading Json");
    storage.uploadFailedJsonToDatabase();
  }
}

class MyApp extends StatelessWidget {

  Future<String> getNameIfAvailable() async {
    final instance = await SharedPreferences.getInstance();
    return instance.getString('FullName');
  }

  @override
  Widget build(BuildContext context) {
    return new FutureBuilder<String>(
        future: getNameIfAvailable(),
        builder:(BuildContext context, AsyncSnapshot<String> snapshot) {
          final String name = snapshot.data;
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
  CameraController controller;
  String imagePath;
  String videoPath;
  VideoPlayerController videoController;
  VoidCallback videoPlayerListener;

  @override initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp
    ]);
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  IconData getCameraLensIcon(CameraLensDirection direction) {
    switch (direction) {
      case CameraLensDirection.back:
        return Icons.camera_rear;
      case CameraLensDirection.front:
        return Icons.camera_front;
      case CameraLensDirection.external:
        return Icons.camera;
    }
    throw new ArgumentError('Unknown lens direction');
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

    var titleText = new FittedBox(
      fit: BoxFit.scaleDown,
      child: new TitleText(Localize.of(context).appTitle),
    );

    var cameraButton = new FlatButton(
      textColor: Colors.white,
      color: Colors.black,
      onPressed: () {
        Navigator.push(
          context,
          new MaterialPageRoute(builder: (context) => new CameraExampleHome(cameras)),
        );
      },
      child: new Text(Localize.of(context).takeAPhoto,
        style: new TextStyle(
            fontFamily: FontName.normalFont,
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
                title: new Text('View and delete photos you\'ve uploaded',
                  style: new TextStyle(
                    fontFamily: FontName.normalFont,
                    fontSize: 25.0,
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    new MaterialPageRoute(builder: (context) => new MyImages()),
                  );
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
                title: new Text('View everyone\'s uploaded photos',
                  style: new TextStyle(
                    fontFamily: FontName.normalFont,
                    fontSize: 25.0,
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    new MaterialPageRoute(builder: (context) => new Gallery()),
                  );
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
                  Navigator.push(
                    context,
                    new MaterialPageRoute(builder: (context) => new EditName()),
                  );
                },
              )
            ],
          )
      ),
      body: mainContainer,
    );
  }
}