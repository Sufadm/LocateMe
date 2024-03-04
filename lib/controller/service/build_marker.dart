import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:locate_me/controller/service/map_model.dart';

Set<Marker> buildMarkers(MapModel mapModel) {
  return mapModel.currentPosition != null
      ? {
          Marker(
            markerId: const MarkerId('currentLocation'),
            position: mapModel.currentPosition!,
            infoWindow: const InfoWindow(title: 'Current Location'),
            icon: BitmapDescriptor.defaultMarker,
          ),
        }
      : {};
}
