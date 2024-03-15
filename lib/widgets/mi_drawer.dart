import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../pages/login_page.dart';
import '../services/shared_preferences_services.dart';

class MiDrawer extends StatelessWidget {
  final String displayName;
  final String email;
  final String photoURL;

  const MiDrawer({
    Key? key,
    required this.displayName,
    required this.email,
    this.photoURL = '',
  }) : super(key: key);

  void _logOut(BuildContext context) async {
    await SharedPreferencesService().saveOnLogin(false);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            height: 200, // Ajusta este valor según necesites
            child: DrawerHeader(
              decoration: BoxDecoration(color: Colors.black),
              child: Column(
                children: [
                  Expanded(
                    child: CircleAvatar(
                      radius: 45, // Ajusta el tamaño del avatar
                      child: ClipOval(
                        child: photoURL.isNotEmpty
                            ? Image.network(photoURL, fit: BoxFit.cover)
                            : Image.asset('assets/default_user_image.png', fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  SizedBox(height: 10), // Espacio adicional entre la imagen y los textos
                  Text(
                    displayName,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  Text(
                    email,
                    style: TextStyle(color: Colors.grey[400], fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: Container(
              padding: EdgeInsets.all(1),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              child: Image.asset(
                'assets/whatsapp.png',
                width: 25,
                fit: BoxFit.cover,
              ),
            ),
            title: Text("Ir a WhatsApp"),
            onTap: () async {
              final whatsappUrl = "whatsapp://send?phone=952000243&text=Hola, quiero reportar una incidencia...";
              if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
                await launchUrl(Uri.parse(whatsappUrl));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("No se pudo abrir WhatsApp"),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.info_rounded, size: 28),
            title: Text("Acerca De"),
            onTap: () => showDialog(
              context: context,
              builder: (BuildContext context) {
                return CupertinoAlertDialog(
                  title: Text('ACERCA DE...'),
                  content: Text(
                    "App de Incidencias - Versión 1.0, es un producto de DITEC S.A.C. Cualquier Duda o Consulta, Llamar al Ing. Wilson 952000243",
                    style: TextStyle(color: Colors.black),
                  ),
                  actions: <Widget>[
                    TextButton(
                        child: Text(
                          'ACEPTAR',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.green,
                        )),
                  ],
                );
              },
            ),
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app_sharp, size: 28),
            title: Text("Cerrar Sesion"),
            onTap: () => showDialog(
              context: context,
              builder: (BuildContext context) {
                return CupertinoAlertDialog(
                  title: Text('Salir de la aplicación'),
                  content: Text("¿Está seguro de que desea Cerrar Sesion?"),
                  actions: <Widget>[
                    TextButton(
                      child: Text('Sí'),
                      onPressed: () {
                        Navigator.of(context).pop();
                        _logOut(context);
                      },
                    ),
                    TextButton(
                      child: Text('No'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
