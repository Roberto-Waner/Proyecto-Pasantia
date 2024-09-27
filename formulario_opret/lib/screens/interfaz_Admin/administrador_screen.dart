import 'package:flutter/material.dart';
import 'package:formulario_opret/screens/interfaz_Admin/navbar/navbar.dart';

class AdministradorScreen extends StatefulWidget {
  const AdministradorScreen({super.key});

  @override
  State<AdministradorScreen> createState() => _AdministradorScreenState();
}

class _AdministradorScreenState extends State<AdministradorScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        drawer: const Navbar(), //solicitando el menu desplegable
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