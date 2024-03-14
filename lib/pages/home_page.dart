import 'package:app_incidencias_plus/services/shared_preferences_services.dart';
import 'package:flutter/material.dart';
import 'package:app_incidencias_plus/pages/login_page.dart';

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
    return Scaffold(
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
    );
  }
}
