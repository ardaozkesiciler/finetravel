import 'dart:math';
import 'package:flutter/material.dart';

class UserLocation {
  final double latitude;
  final double longitude;
  final String? cityName;

  UserLocation({required this.latitude, required this.longitude, this.cityName});
}

class LocationService extends ChangeNotifier {
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  UserLocation? _currentLocation;
  UserLocation? get currentLocation => _currentLocation;

  Future<void> getCurrentLocation() async {
    // Mocking GPS location (Istanbul coordinates)
    _currentLocation = UserLocation(
      latitude: 41.0082,
      longitude: 28.9784,
      cityName: 'Istanbul',
    );
    notifyListeners();
  }

  void clearLocation() {
    _currentLocation = null;
    notifyListeners();
  }

  void setManualLocation(double lat, double lng, String city) {
    _currentLocation = UserLocation(latitude: lat, longitude: lng, cityName: city);
    notifyListeners();
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    var p = 0.017453292519943295;
    var a = 0.5 - cos((lat2 - lat1) * p) / 2 + cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }
}
