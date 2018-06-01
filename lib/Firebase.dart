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

    String createVideoFileName() {
      return '${imageCount + 1}+${new DateTime.now()}.mp4';
    }

    String getNameFromFile(File imageFile) {
      return basename(imageFile.path);
    }

    Future saveImageFile(UploadImage image) async {
      await storage.init();
      storage.saveImageFile(image.file, image.getName()).then((imageFile) {
        instance.setInt("ImageCount", imageCount + 1);
        checkConnectionThenUploadImage(imageFile);
      }).catchError((error) {
        print("Error saving image file to shared preferences, error: $error");
      });
    }

    Future saveVideoFile(File videoFile) async {
      await storage.init();
      storage.saveVideoFile(videoFile, createVideoFileName()).then((videoFile) {
        instance.setInt("ImageCount", imageCount + 1);
        checkConnectionThenUploadVideo(videoFile);
      }).catchError((error) {
        print("Error saving video file to shared preferences, error: $error");
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

    checkConnectionThenUploadVideo(File video) {
      checkConnectivity().then((isConnected) async {
        if (!isConnected) {
          print("saveImageFile Is connected: $isConnected");
          instance.setBool("hasVideosToUpload", true);
          print("Set hasImagesToUpload to true");
        } else {
          print("Is connected: $isConnected");
          await saveVideoToStorage(video);
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
        final fireImage = new FireImage(getNameFromFile(imageFile), storage.getDateFromFileName(fileName), imageCount, "", url.toString());
        saveImageJsonToDatabase(fireImage);
        storage.deleteImageFile(fileName);
        return url.toString();
      } else {
        print("got here without url");
        checkConnectionThenUploadImage(imageFile);
      }
    }

    saveVideoToStorage(File videoFile) async {
      final fileName = getNameFromFile(videoFile);
      final StorageReference ref = FirebaseStorage.instance.ref().child("AllUsers").child(uuid).child(fileName);
      final StorageUploadTask uploadTask = ref.putFile(videoFile, const StorageMetadata(contentLanguage: "en"));
      final url = (await uploadTask.future).downloadUrl;

      print("Saving to video storage with file: $videoFile");
      if (url != null) {
        print("saved video to firebase url: $url");
        final videoUrl = url.toString();
        final fireVideo = new FireImage(getNameFromFile(videoFile), storage.getDateFromFileName(fileName), imageCount, "https://imgur.com/a/EZbhPa1", videoUrl, false);
        saveImageJsonToDatabase(fireVideo);
        storage.deleteVideoFile(fileName);
        return videoUrl;
      } else {
        print("got here without url");
        checkConnectionThenUploadVideo(videoFile);
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