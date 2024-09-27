import 'package:flutter/material.dart';
import 'package:formulario_opret/screens/interfaz_Admin/navbar/navbar.dart';

class AdministradorScreen extends StatefulWidget {
  final TextEditingController filtrarUsuarioController;
  final TextEditingController filtrarEmailController;
  final TextEditingController filtrarId;
  final TextEditingController filtrarCedula;

  const AdministradorScreen({
    super.key,
    required this.filtrarId,
    required this.filtrarCedula,
    required this.filtrarUsuarioController,
    required this.filtrarEmailController,
  });

  @override
  State<AdministradorScreen> createState() => _AdministradorScreenState();
}

class _AdministradorScreenState extends State<AdministradorScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        drawer: Navbar(
          filtrarUsuarioController: widget.filtrarUsuarioController,  // Acceder a userName desde widget.userName
          filtrarEmailController: widget.filtrarEmailController, // Acceder a email desde widget.email
          filtrarId: widget.filtrarId, // Acceder a id desde widget.id
          filtrarCedula: widget.filtrarCedula, // Acceder a cedula desde
        ), //solicitando el menu desplegable
        appBar: AppBar(
          title: const Text('Bienvenido'),
          backgroundColor: const Color.fromRGBO(1, 135, 76, 1),
        ),
        body: const Center(
          child: Text('Pantalla Principal'),
        ),
      ),
    );
  }
}