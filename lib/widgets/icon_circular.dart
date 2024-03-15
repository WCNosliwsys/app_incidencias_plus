import 'package:flutter/material.dart';

class IconCircular extends StatelessWidget {
  final IconData icon;
  final double size;
  final double padding;
  Color? color;
  IconCircular(this.icon, this.size, this.padding, {this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40.0),
        border: Border.all(color: Colors.white, width: 1.0),
        color: color ?? Colors.white,
      ),
      padding: EdgeInsets.all(padding),
      child: Icon(
        icon,
        color: Colors.black,
        size: size,
      ),
    );
  }
}