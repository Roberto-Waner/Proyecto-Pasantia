import 'package:flutter/material.dart';
import 'package:formulario_opret/screens/login_Screen.dart';
import 'package:formulario_opret/screens/new_User.dart';

class PresentationScreen extends StatelessWidget {
  // const PresentationScreen({super.key});
  final TextEditingController filtrarUsuarioController;
  final TextEditingController filtrarEmailController;
  final TextEditingController filtrarId;
  final TextEditingController filtrarCedula;

  const PresentationScreen({
    required this.filtrarId,
    required this.filtrarCedula,
    required this.filtrarUsuarioController,
    required this.filtrarEmailController,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration( //para el fondo 
          color: Colors.white,
        ),
        child: Stack(         
          children: [
            FractionallySizedBox(
              widthFactor: 1.0, //Ocupa todo el ancho
              heightFactor: 0.50, //para ocupar el 70% de la mitad de la pantalla
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/Fondo/metro1.jpg'),
                    fit: BoxFit.cover,
                  )
                ),
              ),
            ),
            SafeArea( //fondo encima de la imagen
              child: Container(
                margin: EdgeInsets.only(top: size.height * 0.25),
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(1, 135, 76, 1),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(50),
                    topLeft: Radius.circular(50)
                  )
                ),
              ),
            ),
            Align( //para aliniar la caja del logo, logo y los botones
              alignment: Alignment.topCenter,
              child: SafeArea(
                child: Column(
                  children: [
                    Container( //caja y logo
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(200),
                        color: const Color.fromRGBO(217, 217, 217, 1),
                      ),
                      margin: EdgeInsets.only(top: size.height * 0.12),
                      width: size.width * 0.5,
                      height: size.height * 0.32,
                      child: Image.asset( //agregar la imagen
                        'assets/Logo/Logo_Metro_transparente.png'
                      ),
                    ),
                    const SizedBox(height: 150),

                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => NewUser(
                            filtrarUsuarioController: filtrarUsuarioController,
                            filtrarEmailController: filtrarEmailController,
                            filtrarId: filtrarId,
                            filtrarCedula: filtrarCedula,
                          ))
                        );
                      },      
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 112, vertical: 15),
                        child: const Text(
                          'Registrar', 
                          style: TextStyle(
                            fontSize: 35, 
                            color: Color.fromRGBO(1, 1, 1, 1),
                            fontWeight: FontWeight.bold
                          ), 
                          selectionColor: Color.fromRGBO(217, 217, 217, 1)
                        ),
                      )
                    ),
                    const SizedBox(height: 50),

                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginScreen())
                        );
                      },      
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                        child: const Text('Iniciar Sesión', 
                          style: TextStyle(
                            fontSize: 35, 
                            color: Color.fromRGBO(1, 1, 1, 1),
                            fontWeight: FontWeight.bold 
                          ), 
                          selectionColor: Color.fromRGBO(217, 217, 217, 1),
                        ),
                      )
                    )
                  ]
                )
              ),
            ),
          ],
        ),
      ),
    );
  }
}