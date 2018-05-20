import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:convert';
import 'FireImage.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'dart:io';
import 'package:path/path.dart';

class Storage {

  String imageDirectory;
  String jsonDirectory;
  SharedPreferences instance;
  String uuid;

  init() async {
    imageDirectory = '${(await getApplicationDocumentsDirectory()).path}/image_cache/';
    jsonDirectory = '${(await getApplicationDocumentsDirectory()).path}/json_cache/';
    instance = await SharedPreferences.getInstance();
    uuid = instance.getString("UUID");
  }

  Future<File> saveImageFile(File toBeSaved, String fileName) async {
    imageDirectory = '${(await getApplicationDocumentsDirectory()).path}/image_cache/';
    final filePath = '$imageDirectory$fileName';
    print("saving image to $filePath");
    return File(filePath)
      ..createSync(recursive: true)
      ..writeAsBytes(toBeSaved.readAsBytesSync());
  }

  Future<File> saveJsonFile(FireImage image) async {
    jsonDirectory = '${(await getApplicationDocumentsDirectory()).path}/json_cache/';
    final filePath = '$jsonDirectory${image.name}';
    print("saving json to $filePath");
    return File(filePath)
      ..createSync(recursive: true)
      ..writeAsString(json.encode(image));
  }

  deleteImageFile(String fileName) async {
    final filePath = '$imageDirectory$fileName';
    File(filePath).delete();
  }

  deleteJsonFile(String fileName) async {
    final filePath = '$jsonDirectory$fileName';
    File(filePath).delete();
  }

  FireImage fireImageFromJsonFile(String fileName) {
    var imageFile = File("$jsonDirectory$fileName");
    var imageJson = json.decode(imageFile.readAsStringSync());
    String name = imageJson["name"];
    DateTime dateTime = new DateTime.fromMillisecondsSinceEpoch(imageJson["dateTime"]);
    int count = imageJson["count"];
    String url = imageJson["url"];

    print("Image retrieved from file to json: $name, $dateTime, $count, $url");

    return new FireImage(name, dateTime, count, url);
  }

  FireImage fireImageFromFileName(String fileName, String url) {
    var splitName = fileName.split("+");
    var dateString = splitName[1].split(".jpg");
    print(splitName);
    print(dateString);
    DateTime dateTime = DateTime.parse(dateString[0]);
    int count = int.parse(splitName[0]);

    print("Image converted from name: $fileName, $dateTime, $count, $url");

    return new FireImage(fileName, dateTime, count, url);
  }

  uploadFailedImagesToStorage() async {
    instance = await SharedPreferences.getInstance();
    imageDirectory = '${(await getApplicationDocumentsDirectory()).path}/image_cache/';
    uuid = instance.getString("UUID");
    checkConnectivity().then((isConnected) {
      if (isConnected) {
        final myDir = Directory(imageDirectory);
        print('images to be uploaded: ');
        myDir.exists().then((isThere) {
          print(myDir.list);
          myDir.list(recursive: true, followLinks: false)
              .listen((FileSystemEntity entity) {
            print("after recursion");
            saveToStorage(entity);
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

  Future saveToStorage(FileSystemEntity entity) async {
    FirebaseStorage.instance.setMaxOperationRetryTimeMillis(10);
    String fileName = basename(entity.path);
    print("retry upload imageFileName: $fileName");
    var storageReference = FirebaseStorage.instance.ref().child("AllUsers").child(uuid).child(fileName);
    final StorageUploadTask uploadTask = storageReference.putFile(entity, const StorageMetadata(contentLanguage: "en"));
    await uploadTask.future.then((UploadTaskSnapshot snapshot) {
      if (snapshot.downloadUrl != null) {
        var imageCount = instance.getInt("ImageCount");
        String downloadUrl = snapshot.downloadUrl.toString();
        deleteImageFile(fileName);
        print('download URL: $downloadUrl');
        instance.setInt("ImageCount", imageCount + 1);
        FireImage fireImage = fireImageFromFileName(fileName, downloadUrl);
        saveToDatabase(fireImage);
      }
    });
  }

  uploadFailedJsonToDatabase() async {
    instance = await SharedPreferences.getInstance();
    jsonDirectory = '${(await getApplicationDocumentsDirectory()).path}/json_cache/';
    uuid = instance.getString("UUID");
    checkConnectivity().then((isConnected) {
      if (isConnected) {
        final myDir = Directory(jsonDirectory);
        print('files to be uploaded directory: $myDir');
        myDir.exists().then((isThere) {
          myDir.list(recursive: true, followLinks: false)
              .listen((FileSystemEntity entity) {
            FireImage fireImage = fireImageFromJsonFile(basename(entity.path));
            final DatabaseReference dataBaseReference = FirebaseDatabase.instance.reference().child("AllUsers").child(uuid);
            dataBaseReference.child("images").push().set(fireImage.toJson()).whenComplete (() {
              print("image json created and sent to db");
              print("file to be delete name: ${entity.path}");
              deleteImageFile(basename(entity.path));
            }).catchError((success) {
              print("Error saving file to database, was succesful: $success");
            });
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

  Future<bool> saveToDatabase(FireImage image) async {

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