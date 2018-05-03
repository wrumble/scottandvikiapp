import 'package:flutter/material.dart';
import 'package:map_view/map_view.dart';
import 'CompositionSubscription.dart';

class FarmMap {

  MapView mapView = new MapView();
  var compositeSubscription = new CompositeSubscription();

  List<Marker> _markers = <Marker>[
    new Marker("Farm", "Juddwood Farm", 51.172825, 0.221990, color: Colors.red),
  ];

  showMap() {

    mapView.show(
        new MapOptions(
            mapViewType: MapViewType.normal,
            showUserLocation: true,
            initialCameraPosition: new CameraPosition(
                new Location(51.172825, 0.221990), 10.0
            ),
            title: "Reception location"),
        toolbarActions: [new ToolbarAction("Close", 1)]
    );

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