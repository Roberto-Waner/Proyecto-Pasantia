// "mateapp" utilizado para importar de manera automatica el main()
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:formulario_opret/screens/interfaz_User/Empleado_screen.dart';
import 'package:formulario_opret/screens/interfaz_Admin/administrador_screen.dart';
import 'package:formulario_opret/screens/interfaz_User/form_Encuesta_Screen.dart';
// import 'package:formulario_opret/screens/interfaz_User/formEncuesta_screen.dart';
// import 'package:formulario_opret/screens/interfaz_User/pregunta_Encuesta_Screen.dart';
import 'package:formulario_opret/screens/login_screen.dart';
import 'package:formulario_opret/screens/interfaz_Admin/navbar/registro_Empldo.dart';
import 'package:formulario_opret/screens/new_User.dart';
import 'package:formulario_opret/screens/presentation_screen.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();

  // Inicializa los controladores
  final TextEditingController filtrarUsuarioController = TextEditingController();
  final TextEditingController filtrarEmailController = TextEditingController();
  final TextEditingController filtrarId = TextEditingController();
  final TextEditingController filtrarCedula = TextEditingController();

  runApp(MyApp(
    filtrarUsuarioController: filtrarUsuarioController,
    filtrarEmailController: filtrarEmailController,
    filtrarId: filtrarId,
    filtrarCedula: filtrarCedula,
  ));
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatelessWidget {
  // const MyApp({super.key});
  final TextEditingController filtrarUsuarioController;
  final TextEditingController filtrarEmailController;
  final TextEditingController filtrarId;
  final TextEditingController filtrarCedula;

  const MyApp({
    super.key,
    required this.filtrarUsuarioController,
    required this.filtrarEmailController,
    required this.filtrarId, 
    required this.filtrarCedula,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      routes: {
        'presentation': (_) => PresentationScreen(
          filtrarUsuarioController: filtrarUsuarioController,
          filtrarEmailController: filtrarEmailController,
          filtrarId: filtrarId,
          filtrarCedula: filtrarCedula,
        ),
        'login': (_) => const LoginScreen(),
        'EmpleadoScreens': (_) => EmpleadoScreens(
          filtrarUsuarioController: filtrarUsuarioController,
          filtrarEmailController: filtrarEmailController,
          filtrarId: filtrarId,
          filtrarCedula: filtrarCedula, 
        ),
        'newuser': (_) => NewUser(
          filtrarUsuarioController: filtrarUsuarioController,
          filtrarEmailController: filtrarEmailController,
          filtrarId: filtrarId,
          filtrarCedula: filtrarCedula,
        ),
        'adminScreens': (_) => const AdministradorScreen(),
        'registroUsuarios': (_) => const RegistroEmpl(),
        'FormularioEncuesta': (_) => FormEncuestaScreen(
          filtrarUsuarioController: filtrarUsuarioController,
          filtrarEmailController: filtrarEmailController,
          filtrarId: filtrarId,
          filtrarCedula: filtrarCedula,
        ),
        // 'PreguntaEncuesta': (_) => const PreguntaEncuestaScreen()
      },
      initialRoute: 'login',
    );
  }
}
