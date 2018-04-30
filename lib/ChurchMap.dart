import 'package:flutter/material.dart';
import 'package:map_view/map_view.dart';
import 'CompositionSubscription.dart';

class ChurchMap {

  MapView mapView = new MapView();
  var compositeSubscription = new CompositeSubscription();

  List<Marker> _markers = <Marker>[
    new Marker("Church", "St Dunstan's Church", 51.0206245,0.2605629, color: Colors.red),
  ];

  showMap() {
    mapView.show(
        new MapOptions(
            mapViewType: MapViewType.normal,
            showUserLocation: true,
            initialCameraPosition: new CameraPosition(
                new Location(51.0206245,0.2605629), 10.0),
            title: "Church Location"),
        toolbarActions: [new ToolbarAction("Close", 1)]);

    var setMarkers = mapView.onMapReady.listen((_) {
      mapView.setMarkers(_markers);
      mapView.zoomToFit(padding: 100);
    });
    compositeSubscription.add(setMarkers);

    var toolbarAction = mapView.onToolbarAction.listen((id) {
      if (id == 1) {
        mapView.dismiss();
        compositeSubscription.cancel();
      }
    });
    compositeSubscription.add(toolbarAction);
  }
}