import 'package:flutter/material.dart';
import 'package:app_incidencias_plus/pages/home_page.dart';
import 'package:app_incidencias_plus/pages/login_page.dart';
import '../services/shared_preferences_services.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _navigateToNextPage();
  }

  void _navigateToNextPage() async {
    await SharedPreferencesService().init(); // Asegúrate de inicializar las SharedPreferences.
    bool isLoggedIn = await SharedPreferencesService().getOnLogin() ?? false;
    // Espera de 2 segundos en la Splash Page.
    await Future.delayed(Duration(seconds: 2));

    if (isLoggedIn) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomePage()));
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF003366),
              Color(0xFF87CEEB),
            ],
          ),
        ),
        child: Center(
          child: Image.asset(
            "assets/mi_logo.png",
            width: MediaQuery.of(context).size.width / 1.3,
          ),
        ),
      ),
    );
  }
}
