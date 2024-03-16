import 'package:app_incidencias_plus/services/shared_preferences_services.dart';
import 'package:app_incidencias_plus/widgets/mi_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';
import '../models/custom_marker_info.dart';
import '../services/geolocation_service.dart';
import '../widgets/bottom_sheet_incidencia.dart';
import '../widgets/icon_circular.dart';
import 'seleccionar_mapa_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String displayName = 'Usuario';
  String email = 'email@ejemplo.com';
  String photoURL = '';
  GoogleMapController? _mapController;
  LatLng _initialPosition = LatLng(-18.013788, -70.251682);
  Set<Marker> _markers = {};
  BitmapDescriptor? carIcon;
  Position? _lastKnownPosition;
  Map<MarkerId, CustomMarkerInfo> customMarkers = {};
  Future<void> addCustomMarker(LatLng position, String type, String id, DateTime createdAt, String email) async {
/*     final id = Uuid().v4();
    final createdAt = DateTime.now(); */

    final iconPath = getIconPath(type);
    final icon = await BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(48, 48)), iconPath);

    final markerId = MarkerId(id);
    final marker = Marker(
      markerId: markerId,
      icon: icon,
      position: position,
      infoWindow: InfoWindow(title: type, snippet: 'Hora: ${createdAt.hour}:${createdAt.minute}'),
      onTap: () {},
    );

    setState(() {
      customMarkers[markerId] = CustomMarkerInfo(
        id: id,
        position: position,
        type: type,
        createdAt: createdAt,
        email: email,
      );
      _markers.add(marker);
    });
  }

  void saveIncidenciaToFirebase(LatLng position, String type, String id, DateTime createdAt, String email) async {
    final documentReference = FirebaseFirestore.instance.collection('incidencias').doc(id);
    await documentReference.set({
      'id': id,
      'position': GeoPoint(position.latitude, position.longitude),
      'type': type,
      'createdAt': createdAt,
      'email': email,
    });
  }

  String getIconPath(String type) {
    switch (type) {
      case 'Operativo':
        return 'assets/marker_operativo.png';
      case 'Trafico':
        return 'assets/marker_trafico.png';
      case 'Accidente':
        return 'assets/marker_accidente.png';
      default:
        return '';
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _goToMyLocation();
  }

  void _goToMyLocation() async {
    Position? position = await LocationService().getLastKnownPosition();
    if (position != null) {
      if (_mapController != null) {
        _mapController?.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 16.0,
          ),
        ));
      } else {
        print("Map controller is not initialized");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _loadMarkersFromFirestore();
    _loadUserInfo();
    _loadInitialPosition();
    _loadCarIcon();
    _listenToMarkerUpdates();

    LocationService().positionStream.listen((Position position) {
      _updateCarMarker(position);
      _lastKnownPosition = position;
    });
  }

  void _listenToMarkerUpdates() {
    FlutterBackgroundService().on('updateMarkers').listen((data) {
      if (data != null) {
        final id = data['id'] as String;
        final lat = data['lat'] as double;
        final lng = data['lng'] as double;
        final type = data['type'] as String;
        final createdAt = DateTime.parse(data['createdAt'] as String);
        final email = data['email'] as String;

        final LatLng position = LatLng(lat, lng);

        addCustomMarker(position, type, id, createdAt, email);
      }
    });
  }

  void _loadMarkersFromFirestore() async {
    final collection = FirebaseFirestore.instance.collection('incidencias');
    final snapshot = await collection.get();

    for (var doc in snapshot.docs) {
      final data = doc.data();
      final position = LatLng((data['position'] as GeoPoint).latitude, (data['position'] as GeoPoint).longitude);
      final type = data['type'] as String;
      final createdAt = data['createdAt'].toDate() as DateTime;
      final email = data['email'] as String;
      addCustomMarker(position, type, doc.id, createdAt, email);
    }
  }

  Future<void> _loadCarIcon() async {
    carIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(194, 194), devicePixelRatio: 2.5),
      'assets/auto2.png',
    );

    setState(() {});
  }

  void _updateCarMarker(Position position) {
    final markerId = MarkerId("car");
    final marker = Marker(
      markerId: markerId,
      icon: carIcon ?? BitmapDescriptor.defaultMarker,
      position: LatLng(position.latitude, position.longitude),
      anchor: Offset(0.5, 0.5),
      rotation: position.heading ?? 0.0,
    );

    setState(() {
      _markers.removeWhere((m) => m.markerId == markerId);
      _markers.add(marker);
    });

    _mapController?.animateCamera(CameraUpdate.newLatLng(LatLng(position.latitude, position.longitude)));
  }

  Future<void> _loadInitialPosition() async {
    final position = await LocationService().getLastKnownPosition();
    if (position != null) {
      _initialPosition = LatLng(position.latitude, position.longitude);
    }
    setState(() {});
  }

  void _loadUserInfo() async {
    displayName = await SharedPreferencesService().getDisplayName() ?? 'Usuario';
    email = await SharedPreferencesService().getEmail() ?? 'email@ejemplo.com';
    photoURL = await SharedPreferencesService().getPhotoURL() ?? '';
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: MiDrawer(displayName: displayName, email: email, photoURL: photoURL),
        body: Column(
          children: [
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  GoogleMap(
                    onMapCreated: _onMapCreated,
                    mapType: MapType.normal,
                    initialCameraPosition: CameraPosition(
                      target: _initialPosition,
                      zoom: 16.0,
                    ),
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                    zoomControlsEnabled: false,
                    markers: _markers,
                  ),
                  Positioned(
                    top: 15,
                    left: 10,
                    child: Builder(
                      builder: (context) {
                        return Material(
                          color: Colors.transparent,
                          child: InkWell(
                            customBorder: CircleBorder(),
                            child: IconCircular(Icons.menu, 25.0, 10),
                            onTap: () {
                              Scaffold.of(context).openDrawer();
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    top: 15,
                    right: 10,
                    child: GestureDetector(
                      onTap: () async {
                        String textToShare = "App de IncidenciasL+ " +
                            "Totalmente recomendado+ " +
                            "Descargalo desde la playstore" +
                            " \\n" +
                            "http://bit.ly/2IjnDiZ";
                        await Share.share(textToShare);
                      },
                      child: IconCircular(Icons.share, 25.0, 10),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: GestureDetector(
                      onTap: _goToMyLocation,
                      child: IconCircular(Icons.my_location, 25.0, 10),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () async {
                  final result = await showModalBottomSheet<Map<String, dynamic>>(
                    backgroundColor: Colors.transparent,
                    context: context,
                    isScrollControlled: true,
                    builder: (BuildContext context) {
                      return BottomSheetIncidencia();
                    },
                  );

                  if (result != null && result.containsKey('tipoIncidencia')) {
                    print("Tipo de incidencia seleccionado: ${result['tipoIncidencia']}");
                    final LatLng? selectedLocation = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SeleccionarMapaPage(
                          tipoIncidencia: result['tipoIncidencia'],
                          initialPosition: _lastKnownPosition != null
                              ? LatLng(_lastKnownPosition!.latitude, _lastKnownPosition!.longitude)
                              : null,
                        ),
                      ),
                    );
                    if (selectedLocation != null) {
                      print("Ubicación seleccionada: ${selectedLocation.latitude}, ${selectedLocation.longitude}");
                      final id = Uuid().v4();
                      final createdAt = DateTime.now();

                      addCustomMarker(selectedLocation, result['tipoIncidencia'], id, createdAt, email);
                      saveIncidenciaToFirebase(selectedLocation, result['tipoIncidencia'], id, createdAt, email);
                    }
                  }
                },
                child: Text("Reportar Incidencia"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
