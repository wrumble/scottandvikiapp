import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:scott_and_viki/Text/TitleText.dart';
import 'Firebase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'UploadImage.dart';
import 'package:flutter/services.dart';


class CameraExampleHome extends StatefulWidget {
  final List<CameraDescription> cameras;

  CameraExampleHome(this.cameras);

  @override
  _CameraExampleHomeState createState() {
    return new _CameraExampleHomeState(cameras);
  }
}

/// Returns a suitable camera icon for [direction].
IconData getCameraLensIcon(CameraLensDirection direction) {
  switch (direction) {
    case CameraLensDirection.back:
      return Icons.camera_rear;
    case CameraLensDirection.front:
      return Icons.camera_front;
    case CameraLensDirection.external:
      return Icons.camera;
  }
  throw new ArgumentError('Unknown lens direction');
}

void logError(String code, String message) =>
    print('Error: $code\nError Message: $message');

class _CameraExampleHomeState extends State<CameraExampleHome> {
  CameraController controller;
  String imagePath;
  String videoPath;
  VideoPlayerController videoController;
  VoidCallback videoPlayerListener;
  List<CameraDescription> cameras;
  bool isRecording = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  _CameraExampleHomeState(this.cameras);

  @override initState() {
    super.initState();

      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight
      ]);

    if (numberOfCameras() > 0) {
      onNewCameraSelected(cameras[0]);
    }
  }

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller.dispose();
    }
    controller = new CameraController(cameraDescription, ResolutionPreset.high);

    // If the controller is updated then update the UI.
    controller.addListener(() {
      if (mounted) setState(() {});
      if (controller.value.hasError) {
        showInSnackBar('Camera error ${controller.value.errorDescription}');
      }
    });

    try {
      await controller.initialize();
    } on CameraException catch (e) {
      _showCameraException(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  onToggleCameraSwitch() {
    for (CameraDescription cameraDescription in cameras) {
      if (controller != null && !controller.value.isRecordingVideo) {
        if (controller.description.lensDirection != cameraDescription.lensDirection)
          onNewCameraSelected(cameraDescription);
      }
    }
  }

  detectOrientationForAppBar() {
   final mediaQueryData = MediaQuery.of(context);
   if (mediaQueryData.orientation == Orientation.portrait) {
     return new AppBar(
       title: titleText,
       backgroundColor: Colors.black,
       centerTitle: true,
     );
   }
 }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: detectOrientationForAppBar(),
      backgroundColor: Colors.black,
      key: _scaffoldKey,
      body: new Column(
        children: <Widget>[
          new Expanded(
            child: new Stack(
              children: <Widget>[
                new Container(
                  height: double.infinity,
                  width: double.infinity,
                  child: new Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: new Center(
                      child: new AspectRatio(
                        aspectRatio: controller.value.aspectRatio,
                        child: new CameraPreview(controller),
                      ),
                    ),
                  ),
                ),
                detectOrientationForControlWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  var titleText = new FittedBox(
    fit: BoxFit.scaleDown,
    child: new TitleText('Smile'),
  );

  /// Display the thumbnail of the captured image or video.
//  Widget _thumbnailWidget() {
//    return new Expanded(
//      child: new Align(
//        alignment: Alignment.centerRight,
//        child: videoController == null && imagePath == null
//            ? null
//            : new SizedBox(
//          child: (videoController == null)
//              ? new Image.file(new File(imagePath))
//              : new Container(
//            child: new Center(
//              child: new AspectRatio(
//                  aspectRatio: videoController.value.size != null
//                      ? videoController.value.aspectRatio
//                      : 1.0,
//                  child: new VideoPlayer(videoController)),
//            ),
//            decoration: new BoxDecoration(
//                border: new Border.all(color: Colors.pink)),
//          ),
//          width: 64.0,
//          height: 64.0,
//        ),
//      ),
//    );
//  }

  // Click function for changing the state on click
  setRecording() {
    var newVal = true;
    if(isRecording) {
      newVal = false;
    } else {
      newVal = true;
    }
    setState((){
      isRecording = newVal;
    });
  }

  detectOrientationForControlWidget() {
    final mediaQueryData = MediaQuery.of(context);
      if (mediaQueryData.orientation == Orientation.portrait) {
        return _captureControlRowWidget();
      } else {
        return _verticalControlRowWidget();
      }
    }

  Widget _verticalControlRowWidget() {
    return new Align(
      alignment: Alignment.centerRight,
      child: new Container(
          height: MediaQuery.of(context).size.height,
          color: Colors.black,
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              new IconButton(
                icon: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                ),
                color: Colors.white,
                onPressed: controller != null &&
                    controller.value.isInitialized &&
                    !controller.value.isRecordingVideo
                    ? onTakePictureButtonPressed
                    : null,
              ),
              showSwapCameraButton(),
              new IconButton(
                icon: new Icon(
                  Icons.videocam,
                  color: isRecording ? Colors.red : Colors.white,
                ),
                color: isRecording ? Colors.red : Colors.white,
                onPressed: controller != null &&
                    controller.value.isInitialized &&
                    !controller.value.isRecordingVideo
                    ? onVideoRecordButtonPressed
                    : onStopButtonPressed,
              )
            ],
          ),
        ),
    );
  }

  /// Display the control bar with buttons to take pictures and record videos.
  Widget _captureControlRowWidget() {
    return new Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        new Container(
          color: Colors.black,
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              new IconButton(
                icon: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                ),
                color: Colors.white,
                onPressed: controller != null &&
                    controller.value.isInitialized &&
                    !controller.value.isRecordingVideo
                    ? onTakePictureButtonPressed
                    : null,
              ),
              showSwapCameraButton(),
              new IconButton(
                icon: new Icon(
                  Icons.videocam,
                  color: isRecording ? Colors.red : Colors.white,
                ),
                color: isRecording ? Colors.red : Colors.white,
                onPressed: controller != null &&
                    controller.value.isInitialized &&
                    !controller.value.isRecordingVideo
                    ? onVideoRecordButtonPressed
                    : onStopButtonPressed,
              )
            ],
          ),
        ),
      ],
    );
  }

  int numberOfCameras() {
    int count = 0;
    for (var _  in cameras) {
      count += 1;
    }

    return count;
  }

  showSwapCameraButton() {
    if (numberOfCameras() > 1) {
      return new IconButton(
        icon: const Icon(
          Icons.switch_camera,
          color: Colors.white,
        ),
        color: Colors.white,
        onPressed: controller != null &&
            controller.value.isInitialized &&
            !controller.value.isRecordingVideo
            ? onToggleCameraSwitch
            : null,
      );
    }
  }

  /// Display a row of toggle to select the camera (or a message if no camera is available).

  String timestamp() => new DateTime.now().millisecondsSinceEpoch.toString();

  void showInSnackBar(String message) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(message)));
  }

  void onTakePictureButtonPressed() {
    takePicture().then((String filePath) {
      if (mounted) {
        setState(() {
          imagePath = filePath;
          videoController?.dispose();
          videoController = null;
        });
        if (filePath != null) showInSnackBar('Picture saved to $filePath');
      }
    });
  }

  void onVideoRecordButtonPressed() {
    startVideoRecording().then((String filePath) {
      if (mounted) setState(() {});
      setRecording();
      if (filePath != null) showInSnackBar('Saving video to $filePath');
    });
  }

  void onStopButtonPressed() {
    stopVideoRecording().then((_) {
      if (mounted) setState(() {});
      setRecording();
      uploadVideoFile(videoPath);
      showInSnackBar('Video recorded to: $videoPath');
    });
  }

  Future<String> startVideoRecording() async {
    if (!controller.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return null;
    }

    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Movies/flutter_test';
    await new Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${timestamp()}.mp4';

    if (controller.value.isRecordingVideo) {
      // A recording is already started, do nothing.
      return null;
    }

    try {
      videoPath = filePath;
      await controller.startVideoRecording(filePath);
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
    return filePath;
  }

  Future<Null> uploadVideoFile(String filePath) async {
    var fb = Firebase();
    await fb.init();
    final videoFile = new File(filePath);

    fb.saveVideoFile(videoFile);
  }

  Future<void> stopVideoRecording() async {
    if (!controller.value.isRecordingVideo) {
      return null;
    }

    try {
      await controller.stopVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }

    await _startVideoPlayer();
  }

  Future<void> _startVideoPlayer() async {
    final VideoPlayerController vcontroller =
    new VideoPlayerController.file(new File(videoPath));
    videoPlayerListener = () {
      if (videoController != null && videoController.value.size != null) {
        // Refreshing the state to update video player with the correct ratio.
        if (mounted) setState(() {});
        videoController.removeListener(videoPlayerListener);
      }
    };
    vcontroller.addListener(videoPlayerListener);
    await vcontroller.setLooping(true);
    await vcontroller.initialize();
    await videoController?.dispose();
    if (mounted) {
      setState(() {
        imagePath = null;
        videoController = vcontroller;
      });
    }
    await vcontroller.play();
  }

  Future<String> takePicture() async {
    if (!controller.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return null;
    }
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Pictures/flutter_test';
    await new Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${timestamp()}.jpg';

    if (controller.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      await controller.takePicture(filePath).then((_) {
        uploadFile(filePath);
      });
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
    return filePath;
  }

  void _showCameraException(CameraException e) {
    logError(e.code, e.description);
    showInSnackBar('Error: ${e.code}\n${e.description}');
  }

  Future<Null> uploadFile(String filePath) async {
    var fb = Firebase();
    await fb.init();
    final instance = await SharedPreferences.getInstance();
    final count = instance.getInt("ImageCount");
    final imageFile = new File(filePath);

    final image = new UploadImage(imageFile, new DateTime.now(), count);
    fb.saveImageFile(image);
  }

}