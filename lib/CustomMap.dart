import 'package:map_view/map_view.dart';
import 'CompositionSubscription.dart';
import 'package:flutter/material.dart';

class CustomMap extends StatefulWidget {
  String mapTitle;
  List markers;
  CameraPosition initialPosition;

  CustomMap(this.mapTitle, this.markers, this.initialPosition);

  @override
  CustomMapState createState() => new CustomMapState(this.mapTitle, this.markers, this.initialPosition);
}

class CustomMapState extends State<CustomMap>  {

  final String mapTitle;
  final List<Marker> markers;
  final CameraPosition initialPosition;

  CustomMapState(this.mapTitle, this.markers, this.initialPosition);

  MapView mapView = new MapView();
  var compositeSubscription = new CompositeSubscription();

  @override Widget build(BuildContext context) {

    mapView.show(
        new MapOptions(
            mapViewType: MapViewType.normal,
            showUserLocation: true,
            initialCameraPosition: initialPosition,
            title: mapTitle),
        toolbarActions: [new ToolbarAction("Back", 1)]
    );

    var setMarkers = mapView.onMapReady.listen((_) {
      mapView.setMarkers(markers);
      mapView.zoomToFit(padding: 100);
    });
    compositeSubscription.add(setMarkers);

    var toolbarAction = mapView.onToolbarAction.listen((id) {
      if (id == 1) {
        Navigator.pop(context);
        mapView.dismiss();
        compositeSubscription.cancel();
      }
    });
    compositeSubscription.add(toolbarAction);

    return new Scaffold();
  }
}