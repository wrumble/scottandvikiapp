import 'package:flutter/material.dart';
import 'package:scott_and_viki/Text/TitleText.dart';
import 'dart:async';
import 'FireImage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';

class MyImages extends StatefulWidget {
  @override
  MyImagesState createState() => new MyImagesState();
}

class MyImagesState extends State<MyImages>  {

  var reference;

  Future<Null> getReference() async {
    final instance = await SharedPreferences.getInstance();
    final uuid = instance.getString("UUID");
    final userName = instance.getString("FullName");
    final String folderName = "$userName's Photos";

    setState(() {
      reference = FirebaseDatabase.instance.reference().child(uuid).child(folderName).orderByChild("count").once();
    });
  }

  @override void initState() {
    super.initState();

    getReference();
  }

  var titleText = new TitleText("My Images", 30.0);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: titleText,
          backgroundColor: Colors.black,
          centerTitle: true,
        ),
      body: new FutureBuilder<DataSnapshot>(
          future: reference,
          builder: (BuildContext context, AsyncSnapshot<DataSnapshot> snapshot) {
            if (snapshot.hasData){
              Map content = snapshot.data.value;
              List<FireImage> imageList = new List<FireImage>();
              content.forEach((_, value) {
                var dateTime = new DateTime.fromMillisecondsSinceEpoch(value["dateTime"]);
                var count = value["count"];
                var url = value["url"];
                FireImage image = new FireImage(dateTime, count, url);
                imageList.add(image);
              });

              return new GridView.count(
                crossAxisCount: 3,
                children: imageList.map((FireImage image) {
                  return new Image.network(image.url);
                }).toList(),
              );
            }
          }
      ),
    );
  }
}