import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'FireImage.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class Firebase {

    SharedPreferences instance;
    String uuid;
    String userName;
    int imageCount; 
  
    void uploadImage(File image) async {

      instance = await SharedPreferences.getInstance();
      uuid = instance.getString("UUID");
      userName = instance.getString("FullName");
      imageCount = instance.getInt("ImageCount");
  
      final DateTime currentDateTime = DateTime.now();
      final String fileName = '$imageCount-$currentDateTime.jpg';
      final StorageReference ref = FirebaseStorage.instance.ref().child("AllUsers").child(uuid).child(fileName);
      final StorageUploadTask uploadTask = ref.putFile(image, const StorageMetadata(contentLanguage: "en"));
      Uri downloadUrl;
      print("here FGDAHJGHSJLFGSDLFJGHDLSJFGHDSFLJGH");
      await uploadTask.future.then( (err) {
        print("not here FGDAHJGHSJLFGSDLFJGHDLSJFGHDSFLJGH");
        print('catchError1: $err');
      }).catchError( (error) {
        print("here here FGDAHJGHSJLFGSDLFJGHDLSJFGHDSFLJGH");
        print('catchError1: $error');
      });

      instance.setInt("ImageCount", imageCount + 1);
  
      final fireImage = new FireImage(fileName, currentDateTime, imageCount, downloadUrl.toString());
      final DatabaseReference dataBaseReference = FirebaseDatabase.instance.reference().child("AllUsers").child(uuid);
      dataBaseReference.child("images").push().set(fireImage.toJson());
      dataBaseReference.child("name").set(userName);
    }
    
    void getSharedPreferences() async {

    }
}