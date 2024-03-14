import 'package:app_incidencias_plus/pages/home_page.dart';
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
      print(user?.displayName);
      print(user?.email);

      if (user != null) {
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
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                Text("App de Registro de Incidencias",
                    style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 20,
                ),
                Image.asset(
                  "assets/mi_logo.png",
                  width: MediaQuery.of(context).size.width / 2,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Inicia sesión",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                SizedBox(height: 24),
                
                ElevatedButton(
                  onPressed: () {
                    signInWithGoogle(context);
                  },
                  child: Text("Iniciar sesión con Google"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
