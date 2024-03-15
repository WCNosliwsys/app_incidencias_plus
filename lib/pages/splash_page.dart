import 'package:flutter/material.dart';
import 'package:app_incidencias_plus/pages/home_page.dart';
import 'package:app_incidencias_plus/pages/login_page.dart';
import 'package:geolocator/geolocator.dart';
import '../services/geolocation_service.dart';
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
    requestLocationPermission();
  }

  void requestLocationPermission() async {
    final locationService = LocationService();
    try {
      await locationService.initialize();
      _navigateToNextPage();
    } catch (e) {
      _handleLocationServiceError(e);
    }
  }

  void _navigateToNextPage() async {
    await SharedPreferencesService().init();
    bool isLoggedIn = await SharedPreferencesService().getOnLogin() ?? false;
    await Future.delayed(Duration(seconds: 2));
    if (isLoggedIn) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomePage()));
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginPage()));
    }
  }

void _handleLocationServiceError(Object e) {
  String errorMessage = '';
  String positiveButtonText = 'Ir a Configuración';
  VoidCallback positiveButtonAction;

  if (e.toString().contains('Location services are disabled.')) {
    errorMessage = 'Los servicios de ubicación están desactivados. Activa la ubicación para reportar incidencias en tiempo real y encontrar ayuda más rápidamente.';
    positiveButtonAction = () => Geolocator.openLocationSettings();
  } else if (e.toString().contains('Location permissions are denied')) {
    errorMessage = 'El permiso de ubicación ha sido denegado. Por favor, otorga acceso a tu ubicación para que puedas reportar incidencias y obtener asistencia.';
    positiveButtonAction = () => Geolocator.openAppSettings();
  } else {
    errorMessage = 'Ha ocurrido un error inesperado. Por favor, intenta nuevamente o contacta soporte si el problema persiste.';
    positiveButtonText = 'Cerrar';
    positiveButtonAction = () => Navigator.of(context).pop();
  }

  showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: Text('Se requiere Acceso a la Ubicación'),
      content: Text(errorMessage),
      actions: <Widget>[
        if (e.toString().contains('Location services are disabled.') || e.toString().contains('Location permissions are denied'))
          TextButton(
            child: Text(positiveButtonText),
            onPressed: positiveButtonAction,
          ),
        TextButton(
          child: Text('Cerrar'),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    ),
  );
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
