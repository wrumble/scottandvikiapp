import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'FireImage.dart';
import 'Storage.dart';
import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'UploadImage.dart';

class Firebase {

    SharedPreferences instance;
    String uuid;
    String userName;
    int imageCount;
    StorageReference storageReference;
    final storage = Storage();

    Future init() async {
      instance = await SharedPreferences.getInstance();
      uuid = instance.getString("UUID");
      userName = instance.getString("FullName");
      imageCount = instance.getInt("ImageCount");

      FirebaseStorage.instance.setMaxUploadRetryTimeMillis(3000);
    }

    String createThumbnailFileName(File imageFile) {
      return 'thumb_${getNameFromFile(imageFile)}';
    }

    String getNameFromFile(File imageFile) {
      return basename(imageFile.path);
    }

    String getImageFileNameFromThumbnailName(String thumbnailName) {
      return thumbnailName.replaceAll("thumb_", "");
    }

    Future saveImageFile(UploadImage image) async {
      await storage.init();
      storage.saveImageFile(image.file, image.getName()).then((imageFile) {
        instance.setInt("ImageCount", imageCount + 1);
        checkConnectionThenUploadImage(imageFile);
      }).catchError((error) {
        print("Error saving file to shared preferences, error: $error");
      });
    }

    checkConnectionThenUploadImage(File image) {
      checkConnectivity().then((isConnected) async {
        if (!isConnected) {
          print("saveImageFile Is connected: $isConnected");
          instance.setBool("hasImagesToUpload", true);
          print("Set hasImagesToUpload to true");
        } else {
          print("Is connected: $isConnected");
          await saveImageToStorage(image);
        }
      }).catchError((error) {
        print("Error getting connectivity status, was error: $error");
      });
    }

    Future checkConnectionThenUploadThumbnail(File image, String imageUrl) async {
      checkConnectivity().then((isConnected) async {
        if (!isConnected) {
          print("Is connected: $isConnected");
          instance.setBool("hasThumbsToUpload", true);
          print("Set has files to upload to true");
        } else {
          print("Is connected: $isConnected");
          saveThumbnailToStorage(image, imageUrl);
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
      final fileName = getNameFromFile(imageFile);
      final StorageReference ref = FirebaseStorage.instance.ref().child("AllUsers").child(uuid).child(fileName);
      final StorageUploadTask uploadTask = ref.putFile(imageFile, const StorageMetadata(contentLanguage: "en"));
      final url = (await uploadTask.future).downloadUrl;

      print("Saving to image storage with file: $imageFile");
      if (url != null) {
        print("saved image to firebase url: $url");
        final thumbFile = storage.saveThumbFile(imageFile, url.toString(), createThumbnailFileName(imageFile));
        checkConnectionThenUploadThumbnail(thumbFile, url.toString());
        storage.deleteImageFile(fileName);
        return url.toString();
      } else {
        print("got here without url");
        checkConnectionThenUploadImage(imageFile);
      }
    }

    Future saveThumbnailToStorage(File thumbFile, String imageUrl) async {
      final fileName = getNameFromFile(thumbFile);
      final ref = FirebaseStorage.instance.ref().child("AllUsers").child(uuid).child(fileName);
      final StorageUploadTask uploadTask = ref.putFile(thumbFile, const StorageMetadata(contentLanguage: "en"));
      final url = (await uploadTask.future).downloadUrl;

      print("saveThumbnailToStorage Firebase with file: $thumbFile");
      if (url != null) {
        print("saved thumbnail to firebase url: $url");
        String thumbnailUrl = url.toString();
        print("deleting thumbnail file with name: $fileName");
        final fireImage = new FireImage(getImageFileNameFromThumbnailName(fileName), storage.getDateFromFileName(fileName), imageCount, thumbnailUrl, imageUrl);
        storage.deleteThumbFiles(fileName);
        saveImageJsonToDatabase(fireImage);
      } else {
        print("got here without url");
        checkConnectionThenUploadThumbnail(thumbFile, imageUrl);
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