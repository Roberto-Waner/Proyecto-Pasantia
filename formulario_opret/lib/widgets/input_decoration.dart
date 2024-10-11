import 'package:flutter/material.dart';
class InputDecorations {
  static InputDecoration inputDecoration({
    required String hintext,
    required String labeltext,
    Widget? icono,
    double labelFrontSize = 16.0, // Tamaño de letra por defecto
    double hintFrontSize = 16.0 // Tamaño de letra por defecto
  }) {
    return InputDecoration(
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Color.fromARGB(255, 39, 99, 41)),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
          color: Color.fromARGB(255, 23, 164, 28),
          width: 2
        ),
      ),
      hintText: hintext,
      labelText: labeltext,
      prefixIcon: icono,
      labelStyle: TextStyle(fontSize: labelFrontSize), // Cambiar tamaño de letra
      hintStyle: TextStyle(fontSize: hintFrontSize), // Cambiar tamaño de letra
    );
  }
}