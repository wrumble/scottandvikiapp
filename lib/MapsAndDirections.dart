import 'package:flutter/material.dart';
import 'package:map_view/map_view.dart';
import 'package:scott_and_viki/Text/TitleText.dart';
import 'CustomMap.dart';
import 'package:flutter/services.dart';

var backgroundImage = new BoxDecoration(
  image: new DecorationImage(
    image: new AssetImage('assets/background.png'),
    fit: BoxFit.cover,
  ),
);

class MapsAndDirections extends StatefulWidget {

  @override
  MapsAndDirectionsState createState() {
    return new MapsAndDirectionsState();
  }
}

class MapsAndDirectionsState extends State<MapsAndDirections> {

  @override initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  Widget build(BuildContext context) {

    var titleText = TitleText('Maps and Directions', 25.0);
    var churchStaticMarkers = [ new Marker("Church", "St Dunstan's Church", 51.0206245,0.2605629, color: Colors.red)];
    var churchLocation = new Location(51.0206245,0.2605629);
    var farmStaticMarkers = [ new Marker("Farm", "Juddwood Farm", 51.172825, 0.221990, color: Colors.red)];
    var farmLocation = new Location(51.172825, 0.221990);
    var staticMapProvider = new StaticMapProvider("AIzaSyDV1GknO-dNqnX9RbaKPh7Er6eohOXCZ24");

    var churchStaticMapUri = staticMapProvider.getStaticUriWithMarkers(
        churchStaticMarkers,
        maptype: StaticMapViewType.roadmap,
        center: churchLocation
    );

    var farmStaticMapUri = staticMapProvider.getStaticUriWithMarkers(
        farmStaticMarkers,
        maptype: StaticMapViewType.roadmap,
        center: farmLocation
    );

    var churchTextContainer = new Container(
      child: new Text("St Dunstan's Church",
          textAlign: TextAlign.center,
          style: new TextStyle(fontFamily: 'DancingScript-Regular',
              fontSize: 30.0,
              color: Colors.black,
              fontWeight: FontWeight.bold)
      ),
      margin: new EdgeInsets.only(left: 8.0, top: 16.0, right: 8.0),
    );

    var churchMapTitle = 'Church Location';
    List<Marker> churchMapMarkers = <Marker>[
      new Marker("Church", "St Dunstan's Church", 51.0206245,0.2605629, color: Colors.red),
    ];
    var churchPosition = new CameraPosition(
        churchLocation, 10.0
    );
    var churchMapContainer = new Container(
      child: new InkWell(
        child: new Center(
          child: new Image.network(churchStaticMapUri.toString()),
        ),
        onTap: () { CustomMap(churchMapTitle, churchMapMarkers, churchPosition).showMap(); },
      ),
      margin: new EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0),
    );

    var churchAddressContainer = new Container(
      child: new Text("St Dunstan’s Church, Mayfield TN20 6AB",
          textAlign: TextAlign.center,
          style: new TextStyle(fontFamily: 'DancingScript-Regular',
              fontSize: 25.0,
              color: Colors.black,
              fontWeight: FontWeight.bold)
      ),
      margin: new EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0),
    );

    var churchDirectionsContainer = new Container(
      child: new Text("Mayfield village is signposted on the A267 and the church is situated in the middle of the village on the High Street.",
          textAlign: TextAlign.center,
          style: new TextStyle(fontFamily: 'DancingScript-Regular',
              fontSize: 25.0,
              color: Colors.black)
      ),
      margin: new EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0),
    );

    var churchLocationImageContainer = new Container(
      child: new Image(image: new AssetImage('assets/churchLocation.png')),
      margin: new EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0),
    );

    var carParkDirectionsContainer = new Container(
      child: new Text("The car park is sign posted on the right-hand side of the High Street as you are driving up the hill. The easiest way to get to the church from the car park is to walk through the car park for The Middle House as seen on the map. The marked car park in Mayfield is free.",
          textAlign: TextAlign.center,
          style: new TextStyle(fontFamily: 'DancingScript-Regular',
              fontSize: 25.0,
              color: Colors.black)
      ),
      margin: new EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0, bottom: 16.0),
    );

    var churchAndMapContainer = new Container(
        child: new Column(
          children: <Widget>[
            churchTextContainer,
            churchMapContainer,
            churchAddressContainer,
            churchDirectionsContainer,
            churchLocationImageContainer,
            carParkDirectionsContainer,
          ],
        ),
        margin: new EdgeInsets.only(left: 8.0, top: 16.0, right: 8.0, bottom: 16.0),
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

    var farmTextContainer = new Container(
      child: new Text("Reception",
          textAlign: TextAlign.center,
          style: new TextStyle(fontFamily: 'DancingScript-Regular',
              fontSize: 30.0,
              color: Colors.black,
              fontWeight: FontWeight.bold)
      ),
      margin: new EdgeInsets.only(left: 8.0, top: 16.0, right: 8.0),
    );

    var farmTimeContainer = new Container(
      child: new Text("The drive from St Dunstan’s Church to the reception at Juddwood Farm is approximately 30 minutes.",
          textAlign: TextAlign.center,
          style: new TextStyle(fontFamily: 'DancingScript-Regular',
              fontSize: 25.0,
              color: Colors.black)
      ),
      margin: new EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0),
    );

    var farmAddressContainer = new Container(
      child: new Text("Juddwood Farm, Haysden Lane, Tonbridge TN11 8AB",
          textAlign: TextAlign.center,
          style: new TextStyle(fontFamily: 'DancingScript-Regular',
              fontSize: 25.0,
              color: Colors.black,
              fontWeight: FontWeight.bold)
      ),
      margin: new EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0, bottom: 16.0),
    );

    List<Marker> farmMarkers = <Marker>[
      new Marker("Farm", "Juddwood Farm", 51.172825, 0.221990, color: Colors.red),
    ];
    var farmTitle = "Reception location";
    var farmPosition = new CameraPosition(farmLocation, 10.0);
    var farmMapContainer = new Container(
      child: new InkWell(
        child: new Center(
          child: new Image.network(farmStaticMapUri.toString()),
        ),
        onTap: () { CustomMap(farmTitle, farmMarkers, farmPosition).showMap(); },
      ),
      margin: new EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0),
    );

    var farmLocationImageContainer = new Container(
      child: new Image(image: new AssetImage('assets/farmLocation.png')),
      margin: new EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0, bottom: 16.0),
    );

    var farmLocationContainer = new Container(
        child: new Column(
          children: <Widget>[
            farmTextContainer,
            farmTimeContainer,
            farmMapContainer,
            farmAddressContainer,
            farmLocationImageContainer
          ],
        ),
        margin: new EdgeInsets.only(left: 8.0, top: 16.0, right: 8.0, bottom: 16.0),
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

    var listContainers = [
      churchAndMapContainer,
      farmLocationContainer
    ];

    var listView = new ListView.builder(
        itemCount: listContainers.length,
        itemBuilder: (BuildContext context, int index) {
          return new Container(
              child: listContainers[index]
          );
        });

    var mainContainer = new Container(
        height: double.infinity,
        width: double.infinity,
        decoration: backgroundImage,
        child: new Container(
              child: listView,
            )
    );

    return new Scaffold(
        appBar: new AppBar(
          title: titleText,
          backgroundColor: Colors.black,
          centerTitle: true,
        ),
        body: mainContainer
    );
  }
}