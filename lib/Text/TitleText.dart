import 'package:flutter/material.dart';
import 'package:scott_and_viki/Constants/FontNames.dart';

class TitleText extends StatelessWidget {
  final String titleText;
  final double textSize;

  TitleText(this.titleText, [this.textSize = 40.0]);

  @override
  Widget build(BuildContext context) {


    return new FittedBox(
      fit: BoxFit.scaleDown,
      child: new Text(titleText,
        textAlign: TextAlign.left,
        style: new TextStyle(
            fontFamily: FontName.titleFont,
            fontSize: textSize,
            color: Colors.white
        ),
      ),
    );
  }
}