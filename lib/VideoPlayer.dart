import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:scott_and_viki/Constants//FontNames.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';


class ChewieDemo extends StatefulWidget {
  final DateTime dateTime;
  final String url;

  ChewieDemo(this.dateTime, this.url);

  @override
  State<StatefulWidget> createState() {
    return new _ChewieDemoState(this.dateTime, this.url);
  }
}

class _ChewieDemoState extends State<ChewieDemo> {
  final String url;
  final DateTime dateTime;
  VideoPlayerController _controller;

  _ChewieDemoState(this.dateTime, this.url);

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    _controller = new VideoPlayerController.network(url);
  }

  timeFromDate() {
    var formatter = new DateFormat.jm();
    return formatter.format(this.dateTime).toString();
  }

  detectOrientationForAppBar() {
    final mediaQueryData = MediaQuery.of(context);
    if (mediaQueryData.orientation == Orientation.portrait) {
      return new AppBar(
        title: new Text(
          timeFromDate(),
          style: new TextStyle(
              fontFamily: FontName.normalFont
          ),
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return  new Scaffold(
      appBar: detectOrientationForAppBar(),
      body: new Column(
        children: <Widget>[
          new Expanded(
            child: new Center(
              child: new Chewie(
                _controller,
                aspectRatio: 3 / 2,
                autoPlay: true,
                looping: true,
                showControls: true,
                materialProgressColors: new ChewieProgressColors(
                  playedColor: Colors.red,
                  handleColor: Colors.blue,
                  backgroundColor: Colors.black,
                  bufferedColor: Colors.lightGreen,
                ),
                placeholder: new Container(
                  color: Colors.grey,
                ),
                autoInitialize: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}