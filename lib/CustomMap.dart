import 'package:map_view/map_view.dart';
import 'CompositionSubscription.dart';

class CustomMap {
  final String mapTitle;
  final List<Marker> markers;
  final CameraPosition initialPosition;

  CustomMap(this.mapTitle, this.markers, this.initialPosition);

  MapView mapView = new MapView();
  var compositeSubscription = new CompositeSubscription();

  showMap() {

    mapView.show(
        new MapOptions(
            mapViewType: MapViewType.normal,
            showUserLocation: true,
            initialCameraPosition: initialPosition,
            title: mapTitle),
        toolbarActions: [new ToolbarAction("Close", 1)]
    );

    var setMarkers = mapView.onMapReady.listen((_) {
      mapView.setMarkers(markers);
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