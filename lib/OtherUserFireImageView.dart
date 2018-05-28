import 'package:flutter/material.dart';
import 'package:zoomable_image/zoomable_image.dart';
import 'package:intl/intl.dart';
import 'FireImage.dart';
import 'package:scott_and_viki/Constants/FontNames.dart';

class OtherUserFireImageView extends StatefulWidget {
  final FireImage image;

  OtherUserFireImageView(this.image);

  @override
  OtherUserFireImageViewState createState() => new OtherUserFireImageViewState(image);
}

class OtherUserFireImageViewState extends State<OtherUserFireImageView>  {
  final FireImage image;

  OtherUserFireImageViewState(this.image);

  timeFromDate() {
    var formatter = new DateFormat.jm();
    return formatter.format(image.dateTime).toString();
  }

  @override void initState() {
    super.initState();

  }

  var placeHolder = new Row(
    children: <Widget>[
      new Container(
        child: new Text('Loading image ...',
          textAlign: TextAlign.center,
          style: new TextStyle(
              fontFamily: FontName.normalFont,
              fontSize: 25.0,
              color: Colors.black
          ),
        ),
        padding: new EdgeInsets.all(16.0),
        margin: new EdgeInsets.only(left: 8.0, right: 8.0),
        decoration: new BoxDecoration(
            color: Colors.white,
            boxShadow: [
              new BoxShadow(
                  color: Colors.black38,
                  blurRadius: 5.0,
                  offset: new Offset(3.0, 5.0)
              ),
            ]
        ),
      )
    ],
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
  );

  @override
  Widget build(BuildContext context) {

    var titleText = new Text(timeFromDate(),
        style: new TextStyle(fontFamily: FontName.normalFont,
            fontSize: 30.0,
            color: Colors.white)
    );

    var backgroundImage = new BoxDecoration(
      image: new DecorationImage(
        image: new AssetImage('assets/background.png'),
        fit: BoxFit.cover,
      ),
    );

    var mainContainer = new Container(
      height: double.infinity,
      width: double.infinity,
      decoration: backgroundImage,
      child: new Column(
        children: <Widget>[
          new Expanded(
            child: new Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Expanded(
                    child: new Container(
                      child: new ZoomableImage(
                        new NetworkImage(image.url),
                        placeholder: placeHolder,
                        backgroundColor: Colors.transparent,
                      ),
                      margin: new EdgeInsets.all(8.0),
                    )
                )
              ],
            ),
          )
        ],
      ),
    );

    return new Scaffold(
      appBar: new AppBar(
        title: titleText,
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: mainContainer,
    );
  }
}