import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:convert';
import 'FireImage.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:image/image.dart';
import 'Firebase.dart';

class Storage {

  Firebase firebase;
  String imageDirectory;
  String thumbDirectory;
  String jsonDirectory;
  SharedPreferences instance;
  String uuid;

  init() async {
    firebase = Firebase();
    await firebase.init();
    imageDirectory = '${(await getApplicationDocumentsDirectory()).path}/image_cache/';
    thumbDirectory = '${(await getApplicationDocumentsDirectory()).path}/thumb_cache/';
    jsonDirectory = '${(await getApplicationDocumentsDirectory()).path}/json_cache/';
    instance = await SharedPreferences.getInstance();
    uuid = instance.getString("UUID");
  }

  Future<File> saveImageFile(File toBeSaved, String fileName) async {
    print(fileName);
    final filePath = '$imageDirectory$fileName';
    print(filePath);
    print("saving image to $filePath");
    return new File(filePath)
      ..createSync(recursive: true)
      ..writeAsBytes(toBeSaved.readAsBytesSync());
  }

  File saveThumbFile(File fullImage, String imageUrl, String fileName) {
    Image image = decodeImage(fullImage.readAsBytesSync());
    Image thumbnail = copyResize(image, 150);

    final imagePath = '$thumbDirectory$fileName';
    final jsonFileName = fileName.split('.jpg')[0] + '.json';
    final jsonPath = '$thumbDirectory$jsonFileName';
    print("saving thumbnail to $imagePath");
    print("saving thumbnail json to $jsonPath");
    new File(jsonPath)
      ..createSync(recursive: true)
      ..writeAsString(json.encode(imageUrl));

    return new File(imagePath)
      ..createSync(recursive: true)
      ..writeAsBytes(encodeJpg(thumbnail));
  }

  Future<File> saveJsonFile(FireImage image) async {
    jsonDirectory = '${(await getApplicationDocumentsDirectory()).path}/json_cache/';
    final filePath = '$jsonDirectory${image.name}';
    print("saving json to $filePath");
    return new File(filePath)
      ..createSync(recursive: true)
      ..writeAsString(json.encode(image));
  }

  deleteImageFile(String fileName) async {
    final filePath = '$imageDirectory$fileName';
    File(filePath).delete();
    print("$fileName deleted");
  }

  deleteThumbFiles(String fileName) async {
    final filePath = '$thumbDirectory$fileName';
    final jsonFileName = fileName.split('.jpg')[0] + '.json';
    final jsonPath = '$thumbDirectory$jsonFileName';

    File(filePath).delete();
    File(jsonPath).delete();
    print("$fileName deleted");
    print("$jsonFileName deleted");
  }

  deleteJsonFile(String fileName) async {
    final filePath = '$jsonDirectory$fileName';
    File(filePath).delete();
    print("$fileName deleted");
  }

  FireImage fireImageFromJsonFile(String fileName) {
    var imageFile = File("$jsonDirectory$fileName");
    var imageJson = json.decode(imageFile.readAsStringSync());
    String name = imageJson["name"];
    DateTime dateTime = new DateTime.fromMillisecondsSinceEpoch(imageJson["dateTime"]);
    int count = imageJson["count"];
    String thumbnailUrl = imageJson["thumbnailUrl"];
    String url = imageJson["url"];

    print("Image retrieved from file to json: $name, $dateTime, $count, $thumbnailUrl, $url");

    return new FireImage(name, dateTime, count, thumbnailUrl, url);
  }

  uploadFailedImagesToStorage() async {
    await firebase.init();
    checkConnectivity().then((isConnected) {
      if (isConnected) {
        final myDir = Directory(imageDirectory);
        print('images to be uploaded: ');
        myDir.exists().then((isThere) {
          print(myDir.list);
          myDir.list(recursive: true, followLinks: false)
              .listen((FileSystemEntity entity) async {
            print("after recursion");
            await firebase.saveImageFile(entity);
          });
        });
      } else {
        print("Is connected: $isConnected");
        print("failed to upload stored images as still not connected to internet");
      }
    }).catchError((error) {
      print("Error getting connectivity status, was error: $error");
    });
  }

  String imageUrlFromThumbEntity(FileSystemEntity entity) {
    final fileName = basename(entity.path);
    final jsonFileName = fileName.split('.jpg')[0] + '.json';
    final jsonPath = '$jsonDirectory$jsonFileName';
    final jsonFile = File("$jsonPath");
    return json.decode(jsonFile.readAsStringSync());
  }

  uploadFailedThumbsToStorage() async {
    await firebase.init();
    checkConnectivity().then((isConnected) {
      if (isConnected) {
        final myDir = Directory(thumbDirectory);
        print('thumbs to be uploaded: ');
        myDir.exists().then((isThere) {
          print(myDir.list);
          myDir.list(recursive: true, followLinks: false)
              .listen((FileSystemEntity entity) {
            print("after recursion");
            var imageUrl = imageUrlFromThumbEntity(entity);
            firebase.saveThumbFile(entity, imageUrl);
          });
        });
      } else {
        print("Is connected: $isConnected");
        print("failed to upload stored thumbnails as still not connected to internet");
      }
    }).catchError((error) {
      print("Error getting connectivity status, was error: $error");
    });
  }

  uploadFailedJsonToDatabase() async {
    await firebase.init();
    checkConnectivity().then((isConnected) {
      if (isConnected) {
        final myDir = Directory(jsonDirectory);
        print('files to be uploaded directory: $myDir');
        myDir.exists().then((isThere) {
          myDir.list(recursive: true, followLinks: false)
              .listen((FileSystemEntity entity) {
            FireImage fireImage = fireImageFromJsonFile(basename(entity.path));
            firebase.saveImageJsonToDatabase(fireImage);
          });
        });
      } else {
        print("Is connected: $isConnected");
        print("failed to upload stored json data as still not connected to internet");
      }
    }).catchError((error) {
      print("Error getting connectivity status, was error: $error");
    });
  }

  saveToDatabase(FireImage image) async {

    checkConnectivity().then((isConnected) {
      if (!isConnected) {
        print("Is connected: $isConnected");
        instance.setBool("hasJsonToUpload", true);
        print("Set has JSON to upload to true");
      } else {
        final DatabaseReference dataBaseReference = FirebaseDatabase.instance.reference().child("AllUsers").child(uuid);
        dataBaseReference.child("images").push().set(image.toJson()).whenComplete (() {
          print("image json created and sent to db");
          print("file to be delete name: ${image.name}");
          deleteJsonFile(basename(image.name));
        }).catchError((success) {
          print("Error saving file to database, was succesful: $success");
        });
      }
    });
  }

  Future<bool> checkConnectivity() async {
    var connectivityResult = await (new Connectivity().checkConnectivity());
    print("before connection check");
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    } else {
      return true;
    }
  }
}