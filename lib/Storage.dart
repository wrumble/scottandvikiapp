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
import 'UploadImage.dart';

class Storage {

  Firebase firebase;
  String imageDirectory;
  String videoDirectory;
  String thumbDirectory;
  String jsonDirectory;
  SharedPreferences instance;
  String uuid;

  init() async {
    firebase = Firebase();
    await firebase.init();
    imageDirectory = '${(await getApplicationDocumentsDirectory()).path}/image_cache/';
    videoDirectory = '${(await getApplicationDocumentsDirectory()).path}/video_cache/';
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

  Future<File> saveVideoFile(File toBeSaved, String fileName) async {
    print(fileName);
    final filePath = '$videoDirectory$fileName';
    print(filePath);
    print("saving video to $filePath");
    return new File(filePath)
      ..createSync(recursive: true)
      ..writeAsBytes(toBeSaved.readAsBytesSync());
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

  deleteVideoFile(String fileName) async {
    final filePath = '$videoDirectory$fileName';
    File(filePath).delete();
    print("$fileName deleted");
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
            print("in image file recursion");
            final fileName = basename(entity.path);
            final dateTime = getDateFromFileName(fileName);
            final count = getCountFromFileName(fileName);
            final uploadImage = UploadImage(entity, dateTime, count);
            await firebase.saveImageFile(uploadImage);
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

  uploadFailedVideosToStorage() async {
    await firebase.init();
    checkConnectivity().then((isConnected) {
      if (isConnected) {
        final myDir = Directory(videoDirectory);
        print('video to be uploaded: ');
        myDir.exists().then((isThere) {
          print(myDir.list);
          myDir.list(recursive: true, followLinks: false)
              .listen((FileSystemEntity entity) async {
            print("in video file recursion");
            final videoFile = new File(entity.path);
            await firebase.saveVideoFile(videoFile);
          });
        });
      } else {
        print("Is connected: $isConnected");
        print("failed to upload stored videos as still not connected to internet");
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
            print("in json file  recursion");
            FireImage fireImage = fireImageFromJsonFile(basename(entity.path));
            firebase.saveImageJsonToDatabase(fireImage);
          }).onError((error) {
            print("Error listing json files: $error");
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

  DateTime getDateFromFileName(String fileName) {
    print("date from filename: $fileName");
    var dateString = removeTagAndTypeFromFileName(fileName).split("+")[1].replaceAll("+", "");
    print(dateString);
    return  DateTime.parse(dateString);
  }

  int getCountFromFileName(String fileName) {
    return int.parse(removeTagAndTypeFromFileName(fileName).split("+")[0].replaceAll("+", ""));
  }

  String removeTagAndTypeFromFileName(String fileName) {
    return  fileName.replaceAll("thumb_", "").replaceAll(".jpg", "").replaceAll(".json", "").replaceAll(".mp4", "");
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