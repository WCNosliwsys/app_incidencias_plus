import 'package:flutter/material.dart';

class BottomSheetIncidencia extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.45 + MediaQuery.of(context).viewInsets.bottom,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
          border: Border.all(color: Colors.white, width: 1),
          color: Colors.white,
        ),
        child: Column(
          children: [
            SizedBox(height: 15),
            Text(
              'Tipo de Incidencia',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 15),
            botonIncidencia(context, "Operativo"),
            SizedBox(height: 5),
            botonIncidencia(context, "Accidente"),
            SizedBox(height: 5),
            botonIncidencia(context, "Trafico"),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  minimumSize: Size(double.infinity, 50), 
                ),
                child: Text(
                  "Volver",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ElevatedButton botonIncidencia(BuildContext context, String text) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pop(context, {
          'tipoIncidencia': text,
        });
      },
      style: ElevatedButton.styleFrom(
        primary: Color(0xFFFFCC81),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
        ),
        padding: EdgeInsets.all(10),
        minimumSize: Size(double.infinity, 60), 
      ),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontSize: 16,
        ),
      ),
    );
  }
}
