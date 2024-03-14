import 'package:app_incidencias_plus/pages/home_page.dart';
import 'package:app_incidencias_plus/services/shared_preferences_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatelessWidget {
  GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      GoogleSignInAuthentication? googleSignInAuthentication = await googleSignInAccount?.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication?.accessToken,
        idToken: googleSignInAuthentication?.idToken,
      );

      User? user = (await _firebaseAuth.signInWithCredential(credential)).user;

      if (user != null) {
        SharedPreferencesService().saveOnLogin(true);
        SharedPreferencesService().saveDisplayName(user.displayName ?? "");
        SharedPreferencesService().saveEmail(user.email ?? "");
        SharedPreferencesService().savePhotoURL(user.photoURL ?? "");

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
          ),
          behavior: SnackBarBehavior.floating,
          content: Text(e.toString()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("App de Registro de Incidencias",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center),
              SizedBox(
                height: 20,
              ),
              Image.asset(
                "assets/mi_logo.png",
                width: MediaQuery.of(context).size.width / 2,
              ),
              SizedBox(
                height: 30,
              ),
              SizedBox(height: 24),
              ElevatedButton.icon(
                icon: Container(
                    padding: EdgeInsets.all(8),
                    color: Colors.white,
                    child: Image.asset('assets/icono_google.png', height: 24.0)),
                label: Text("Iniciar sesión con Google", style: TextStyle(color: Colors.white, fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF4285F4),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.all(8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  signInWithGoogle(context);
                },
              ),
              SizedBox(
                height: 50,
              )
            ],
          ),
        ),
      ),
    );
  }
}
