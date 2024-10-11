import 'package:flutter/material.dart';
import 'package:formulario_opret/screens/interfaz_User/navbarUser/navbar_Empl.dart';

class EmpleadoScreens extends StatefulWidget {
  // const EmpleadoScreens({super.key});
  final TextEditingController filtrarUsuarioController;
  final TextEditingController filtrarEmailController;
  final TextEditingController filtrarId;
  final TextEditingController filtrarCedula;

  const EmpleadoScreens({
    required this.filtrarId,
    required this.filtrarCedula,
    required this.filtrarUsuarioController,
    required this.filtrarEmailController,
    super.key,
  });

  @override
  State<EmpleadoScreens> createState() => _EmpleadoScreensState();
}

class _EmpleadoScreensState extends State<EmpleadoScreens> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        drawer: SizedBox(
          width: MediaQuery.of(context).size.width * 0.55, // Ajustar el ancho del Drawer
          child: NavbarEmpl(
            filtrarUsuarioController: widget.filtrarUsuarioController,  // Acceder a userName desde widget.userName
            filtrarEmailController: widget.filtrarEmailController, // Acceder a email desde widget.email
            filtrarId: widget.filtrarId, // Acceder a id desde widget.id
            filtrarCedula: widget.filtrarCedula, // Acceder a cedula desde
          ),
        ),
        appBar: AppBar(
          title: const Text('Perfil'),
          backgroundColor: const Color.fromRGBO(1, 135, 76, 1),
        ),
        body: const Center(
          child: Text('Pantalla Principal'),
        ),
      ),
    );
  }
}