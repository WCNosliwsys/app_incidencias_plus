import 'package:app_incidencias_plus/services/shared_preferences_services.dart';
import 'package:app_incidencias_plus/widgets/mi_drawer.dart';
import 'package:flutter/material.dart';
import 'package:app_incidencias_plus/pages/login_page.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:share_plus/share_plus.dart';

import '../widgets/icon_circular.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String displayName='Usuario';
  String email='email@ejemplo.com';
  String photoURL='';

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
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

                            child: Builder(
                              builder: (context) {
                                return Material(
                                  color: Colors
                                      .transparent, 

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
