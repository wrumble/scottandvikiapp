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
    String thumbnailFileName;
    StorageReference storageReference;
    final storage = Storage();
    String filePath;

    Future init() async {
      instance = await SharedPreferences.getInstance();
      uuid = instance.getString("UUID");
      userName = instance.getString("FullName");
      imageCount = instance.getInt("ImageCount");
      currentDateTime = DateTime.now();
      imageFileName = '$imageCount+$currentDateTime.jpg';
      thumbnailFileName = 'thumb_$imageFileName';

      FirebaseStorage.instance.setMaxUploadRetryTimeMillis(3000);
    }

    Future saveImageFile(File image) async {
      await storage.init();
      storage.saveImageFile(image, imageFileName).then((imageFile) {
        print("This is the image filepath $filePath");

        checkConnectivity().then((isConnected) async {
          if (!isConnected) {
            print("saveImageFile Is connected: $isConnected");
            instance.setBool("hasImagesToUpload", true);
            print("Set hasImagesToUpload to true");
          } else {
            print("Is connected: $isConnected");
            final imageUrl = await saveImageToStorage(image);
            if (imageUrl != null) {
              saveThumbFile(image, imageUrl);
            }
          }
        }).catchError((error) {
          print("Error getting connectivity status, was error: $error");
        });

      }).catchError((error) {
        print("Error saving file to shared preferences, error: $error");
      });
    }

    Future saveThumbFile(File image, String imageUrl) async {
      await storage.init();
      final thumbFile = storage.saveThumbFile(image, imageUrl, thumbnailFileName);

      checkConnectivity().then((isConnected) async {
        if (!isConnected) {
          print("Is connected: $isConnected");
          instance.setBool("hasThumbsToUpload", true);
          print("Set has files to upload to true");
        } else {
          print("Is connected: $isConnected");
          saveThumbnailToStorage(thumbFile, imageUrl);
        }
      }).catchError((error) {
        print("Error getting connectivity status, was error: $error");
      });
    }

    Future<bool> checkConnectivity() async {
      var connectivityResult = await (new Connectivity().checkConnectivity());

      if (connectivityResult == ConnectivityResult.none) {
        return false;
      } else {
        return true;
      }
    }

    saveImageToStorage(File imageFile) async {
      final StorageReference ref = FirebaseStorage.instance.ref().child("AllUsers").child(uuid).child(imageFileName);
      final StorageUploadTask uploadTask = ref.putFile(imageFile, const StorageMetadata(contentLanguage: "en"));
      print("Saving to image storage with file: $imageFile");
      final url = (await uploadTask.future).downloadUrl;
      if (url != null) {
        return url.toString();
      } else {
        print("got here without url");
        saveImageFile(imageFile);
      }
    }

    Future saveThumbnailToStorage(File thumbFile, String imageUrl) async {
      final ref = FirebaseStorage.instance.ref().child("AllUsers").child(uuid).child(thumbnailFileName);
      final StorageUploadTask uploadTask = ref.putFile(thumbFile, const StorageMetadata(contentLanguage: "en"));
      print("saveThumbnailToStorage Firebase with file: $thumbFile");
      final url = (await uploadTask.future).downloadUrl;
        print("uploading image: $thumbFile");
        if (url != null) {
          print("got here with thumbnail url: $url");
          String thumbnailUrl = url.toString();
          final fireImage = new FireImage(imageFileName, currentDateTime, imageCount, thumbnailUrl, imageUrl);
          storage.deleteThumbFiles(thumbnailFileName);
          saveImageJsonToDatabase(fireImage);
          instance.setInt("ImageCount", imageCount + 1);
        } else {
          print("got here without url");
          saveThumbFile(thumbFile, imageUrl);
        }
    }

    saveImageJsonToDatabase(FireImage image) async {
      await storage.init();
      storage.saveJsonFile(image);
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
            saveImageJsonToDatabase(image);
            print("Error saving image json to database error: $error");
          });
        }
      });
    }
}