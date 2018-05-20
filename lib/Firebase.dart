import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'FireImage.dart';
import 'Storage.dart';
import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'dart:io';
import 'package:path/path.dart';

class Firebase {

    SharedPreferences instance;
    String uuid;
    String userName;
    int imageCount;
    DateTime currentDateTime;
    String imageFileName;
    StorageReference storageReference;
    StorageUploadTask uploadTask;
    final storage = Storage();
    String filePath;

    Future setVariables() async {
      await storage.init();
      instance = await SharedPreferences.getInstance();
      uuid = instance.getString("UUID");
      userName = instance.getString("FullName");
      imageCount = instance.getInt("ImageCount");
      currentDateTime = DateTime.now();
      imageFileName = '$imageCount+$currentDateTime.jpg';
    }

    Future uploadImage(File passedImage) async {
      setVariables().then((_) {
        saveFile(passedImage);
      }).catchError((success) {
        print("Error saving variables to shared preferences, was succesful: $success");
      });
    }

    Future saveFile(File image) async {
      storage.saveImageFile(image, imageFileName).then((file) {
        filePath = file.path.toString();
        print("This is the filepath $filePath");

        checkConnectivity().then((isConnected) {
          if (!isConnected) {
            print("Is connected: $isConnected");
            instance.setBool("hasImagesToUpload", true);
            print("Set has files to upload to true");
          } else {
            print("Is connected: $isConnected");
            saveToStorage(image);
          }
        }).catchError((error) {
          print("Error getting connectivity status, was error: $error");
        });

      }).catchError((error) {
        print("Error saving file to shared preferences, error: $error");
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

    Future saveToStorage(File image) async {
      FirebaseStorage.instance.setMaxOperationRetryTimeMillis(10);
      storageReference = FirebaseStorage.instance.ref().child("AllUsers").child(uuid).child(imageFileName);

      print("Saving to storage here with file: $image");
      final StorageUploadTask uploadTask = storageReference.putFile(image, const StorageMetadata(contentLanguage: "en"));
      await uploadTask.future.then( (UploadTaskSnapshot snapshot) {
        print("uploading image: $image");
        if (snapshot.downloadUrl != null) {
          print("got here with url");
          String downloadUrl = snapshot.downloadUrl.toString();
          final fireImage = new FireImage(imageFileName, currentDateTime, imageCount, downloadUrl);
          storage.deleteImageFile(imageFileName);
          print('download URL: $downloadUrl');
          saveToDatabase(fireImage);
          instance.setInt("ImageCount", imageCount + 1);
        } else {
          print("got here without url");
          saveFile(image);
        }
      }).catchError((error) {
        print("got here without url");
        saveFile(image);
      });
    }

    Future<bool> saveToDatabase(FireImage image) async {

      checkConnectivity().then((isConnected) {
        if (!isConnected) {
          print("Is connected: $isConnected");
          instance.setBool("hasJsonToUpload", true);
          print("Set has JSON to upload to true");
          storage.saveJsonFile(image);
        } else {
          print("Is connected: $isConnected");
          final DatabaseReference dataBaseReference = FirebaseDatabase.instance.reference().child("AllUsers").child(uuid);
          dataBaseReference.child("images").push().set(image.toJson()).whenComplete (() {
            print("image json created and sent to db");
            storage.deleteJsonFile(basename(image.name));
          }).catchError((error) {
            saveToDatabase(image);
            print("Error saving file to database, was succesful: $error");
          });
        }
      });
    }
}