import 'package:flutter/material.dart';
import 'package:scott_and_viki/Constants/FontNames.dart';

class PersonCard extends StatelessWidget {
  final String name;
  final double nameSize;
  final Color nameColor;
  final String imagePath;
  final String role;
  final String details;
  final double fontSize;

  PersonCard(this.name, this.nameColor, this.imagePath, this.role, this.details, this.fontSize, [this.nameSize = 30.0]);

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: EdgeInsets.all(8.0),
      padding: EdgeInsets.all(8.0),
      child: new Column(
        children: <Widget>[
          new Stack(
            children: <Widget>[
              new Image(image: new AssetImage(this.imagePath)),
              new Positioned(
                left: 8.0,
                bottom: 8.0,
                child: new FittedBox(
                  fit: BoxFit.scaleDown,
                  child: new Text(this.name,
                    style: new TextStyle(
                        fontFamily: FontName.titleFont,
                        fontSize: nameSize,
                        color: nameColor
                    ),
                  ),
                ),
              )
            ],
          ),
          new Text(this.role,
            style: new TextStyle(
                fontFamily: FontName.normalFont,
                fontWeight: FontWeight.bold,
                fontSize: 30.0,
                color: Colors.black
            ),
          ),
          new Text(this.details,
            style: new TextStyle(
                fontFamily: FontName.normalFont,
                fontSize: fontSize,
                color: Colors.black
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
