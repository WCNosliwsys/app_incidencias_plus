import 'dart:async';
import 'dart:convert';
import 'package:app_incidencias_plus/services/geolocation_service.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../widgets/icon_circular.dart';
import '../utils/mapstyle.dart';

class SeleccionarMapaPage extends StatefulWidget {
  final String tipoIncidencia;
  final LatLng? initialPosition;
  const SeleccionarMapaPage({
    super.key,
    required this.tipoIncidencia,
    this.initialPosition,
  });

  @override
  State<SeleccionarMapaPage> createState() => _SeleccionarMapaPageState();
}

class _SeleccionarMapaPageState extends State<SeleccionarMapaPage> {
  late LatLng currentLocation = widget.initialPosition ?? const LatLng(-2.1611081, -79.9022226);
  final Completer<GoogleMapController> _controller = Completer();
  GoogleMapController? mapController;

  Future<void> onCreated(GoogleMapController controller) async {
    _controller.complete(controller);
    mapController = await _controller.future;
    mapController?.setMapStyle(jsonEncode(mapStyle));
    setState(() {});
  }

  void _goToMyLocation() async {
    Position? position = await LocationService().getLastKnownPosition();
    if (position != null) {
      if (mapController != null) {
        mapController?.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 15.0,
          ),
        ));
      } else {
        print("Map controller is not initialized");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double maxheight = MediaQuery.of(context).size.height - 5;
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: maxheight,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(target: currentLocation, zoom: 15),
                onMapCreated: onCreated,
                compassEnabled: true,
                zoomControlsEnabled: false,
                mapToolbarEnabled: true,
                rotateGesturesEnabled: true,
                tiltGesturesEnabled: true,
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
              ),
            ),
            Transform.translate(
              offset: const Offset(0, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.black,
                    ),
                    width: 280,
                    child: Center(
                      child: Text(
                        widget.tipoIncidencia,
                        style: const TextStyle(color: Colors.white, fontSize: 13.2),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Image.asset(
                    "assets/marker_incidencia.png",
                    height: 175,
                  ),
                ],
              ),
            ),
            Positioned(
              top: 50,
              left: 10,
              child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: IconCircular(Icons.arrow_back, 25.0, 10)),
            ),
            Positioned(
              top: 50,
              right: 10,
              child: GestureDetector(onTap: _goToMyLocation, child: IconCircular(Icons.my_location, 25.0, 10)),
            ),
            Positioned(
              bottom: 90,
              right: 15,
              child: GestureDetector(
                  onTap: () {
                    mapController?.animateCamera(CameraUpdate.zoomOut());
                  },
                  child: IconCircular(Icons.horizontal_rule, 25.0, 10)),
            ),
            Positioned(
              bottom: 140,
              right: 15,
              child: GestureDetector(
                  onTap: () {
                    mapController?.animateCamera(CameraUpdate.zoomIn());
                  },
                  child: IconCircular(Icons.add, 25.0, 10)),
            ),
            Positioned(
              bottom: 10,
              left: 10,
              right: 10,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFE5722),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40.0),
                  ),
                  padding: EdgeInsets.all(10.0),
                  minimumSize: Size(0, 60.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SizedBox(
                        width: 28,
                      ),
                      Text(
                        "Confirmar",
                        style: TextStyle(
                          fontFamily: "Arial, Helvetica, sans-serif",
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                          color: Colors.white,
                          fontSize: 18.0,
                        ),
                      ),
                      IconCircular(Icons.check, 25.0, 0),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
