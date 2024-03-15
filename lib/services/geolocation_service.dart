import 'dart:async';

import 'package:geolocator/geolocator.dart';

class LocationService {
  static final LocationService _instance = LocationService._internal();
  GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  final StreamController<Position> _positionStreamController = StreamController<Position>.broadcast();

  LocationService._internal();
  Position? _lastPosition;

  factory LocationService() {
    return _instance;
  }

  Future<void> initialize() async {
    bool serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    LocationPermission permission = await _geolocatorPlatform.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await _geolocatorPlatform.requestPermission();
      if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
        return Future.error('Location permissions are denied');
      }
    }

    _startListening();
  }

  void _startListening() {
    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 0, 
    );

    _geolocatorPlatform.getPositionStream(locationSettings: locationSettings).listen((Position position) {
      _lastPosition = position;
      _positionStreamController.add(position); 
      print("New location: ${position.latitude}, ${position.longitude}");
    });
  }

  Future<Position?> getLastKnownPosition() async {
    _lastPosition = await _geolocatorPlatform.getLastKnownPosition();
    return _lastPosition;
  }
  Stream<Position> get positionStream => _positionStreamController.stream;

}
