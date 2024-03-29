import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

final mapModelProvider = ChangeNotifierProvider.autoDispose<MapModel>((ref) {
  return MapModel();
});

class MapModel extends ChangeNotifier {
  GoogleMapController? _mapController;
  LatLng? _currentPosition;
  String? _currentAddress;

  GoogleMapController? get mapController => _mapController;
  LatLng? get currentPosition => _currentPosition;
  String? get currentAddress => _currentAddress;

  void setMapController(GoogleMapController controller) {
    _mapController = controller;
  }

  Future<void> getLocation(BuildContext context) async {
    bool permissionGranted = await _requestLocationPermission(context);
    if (permissionGranted) {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
      double lat = position.latitude;
      double long = position.longitude;
      _currentPosition = LatLng(lat, long);
      updateCurrentAddress();
    } else {}
    notifyListeners();
  }

  Future<bool> _requestLocationPermission(BuildContext context) async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return false;
    }
    return true;
  }

  Future<void> updateCurrentAddress() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
      );
      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        _currentAddress =
            "${placemark.street}, ${placemark.locality}, ${placemark.administrativeArea}, ${placemark.country}";
      } else {
        _currentAddress = "Address not found";
      }
      notifyListeners();
    } catch (e) {
      _currentAddress = "Error: $e";
      notifyListeners();
    }
  }
}
