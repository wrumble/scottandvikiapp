import 'package:flutter/material.dart';
import 'package:scott_and_viki/Constants/FontNames.dart';

class HomeScreenCard extends StatelessWidget {
  final String title;
  final String imagePathAndName;
  final Color titleColor;

  HomeScreenCard(this.title, this.imagePathAndName, [this.titleColor = Colors.white]);

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: EdgeInsets.all(8.0),
      child: new Stack(
        children: <Widget>[
          new Image(image: new AssetImage(this.imagePathAndName)),
          new Positioned(
            left: 8.0,
            bottom: 8.0,
            child: new Text(this.title,
              style: new TextStyle(
                  fontFamily: FontName.titleFont,
                  fontSize: 30.0,
                  color: titleColor
              ),
            ),
          )
        ],
      ),
      decoration: new BoxDecoration(
          color: Colors.white,
          boxShadow: [
            new BoxShadow(
                color: Colors.black38,
                blurRadius: 5.0,
                offset: new Offset(3.0, 5.0)
            ),
          ]
      )
    );
  }
}