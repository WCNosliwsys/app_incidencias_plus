import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomMarkerInfo {
  final String id;
  final LatLng position;
  final String type;
  final DateTime createdAt;
  final String email;
  CustomMarkerInfo({
    required this.id,
    required this.position,
    required this.type,
    required this.createdAt,
    required this.email,
  });
}
