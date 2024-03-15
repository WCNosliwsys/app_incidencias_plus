import 'package:app_incidencias_plus/services/shared_preferences_services.dart';
import 'package:flutter/material.dart';
import 'package:app_incidencias_plus/pages/login_page.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:share_plus/share_plus.dart';

import '../widgets/icon_circular.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  void _logOut(BuildContext context) async {
    // Asegúrate de inicializar SharedPreferences
    await SharedPreferencesService().saveOnLogin(false);
    // Redirige al usuario a la página de login
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
/*     return Scaffold(
      appBar: AppBar(
        title: const Text("Mi Home"),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () => _logOut(context),
            tooltip: "Cerrar sesión",
          ),
        ],
      ),
      body: Center(
        child: Text("Bienvenido a la Home Page"),
      ),
    ); */
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom,
            ),
            child: IntrinsicHeight(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      child: Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          GoogleMap(
                            mapType: MapType.normal,
                            initialCameraPosition: CameraPosition(
                              target: LatLng(-18.013788, -70.251682),
                              zoom: 17.0,
                            ),
                            myLocationEnabled: true,
                            myLocationButtonEnabled: false,
                            zoomControlsEnabled: false,
                          ),
                          Positioned(
                            top: 15,
                            left: 10,
                            child: IconCircular(Icons.menu, 25.0, 10),
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
                              onTap: () {
/*                                 getUserLocation().then((value) {
                                  _controller.animateCamera(CameraUpdate.newLatLng(currentLocation));
                                }); */
                              },
                              child: IconCircular(Icons.my_location, 25.0, 10),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
