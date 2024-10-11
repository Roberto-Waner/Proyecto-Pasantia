import 'package:flutter/material.dart';
import 'package:formulario_opret/models/login.dart';
// import 'package:formulario_opret/models/login_Admin.dart';
import 'package:formulario_opret/screens/interfaz_Admin/administrador_screen.dart';
import 'package:formulario_opret/screens/interfaz_User/Empleado_screen.dart';
import 'package:formulario_opret/screens/presentation_screen.dart';
import 'package:formulario_opret/services/login_services_token.dart';
import 'package:formulario_opret/widgets/input_decoration.dart';
import 'dart:convert'; // Import para decodificar el JWT

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Controladores para filtrar el nombre de usuario y el email
  final TextEditingController _filtrarUsuarioController = TextEditingController();
  final TextEditingController _filtrarEmailController = TextEditingController();
  final TextEditingController _filtrarId = TextEditingController();
  final TextEditingController _filtrarCedula = TextEditingController();

  final ApiServiceToken _serviceToken = ApiServiceToken('https://10.0.2.2:7190',false);
  String myToken ="";

  Future<void> _login() async {
    String userName = _userController.text.trim();
    String password = _passwordController.text.trim();

    // Modelos de login
    //LoginAdmin loginAdmin = LoginAdmin(userName: userName, password: password);
    Login login = Login(userName: userName, password: password);

    try{
     // String? tokenAdmin = await _serviceToken.loginAdministrador(loginAdmin);
      String token = await _serviceToken.loginUser(login);

      myToken = token;

      redireccionPerRoles();

    }catch (e) {
      _showSnackBar('An error occurred. Please try again later.');
    }
  }

  redireccionPerRoles(){
    if (myToken != ""){
      // Decodificar el token JWT para obtener los claims
      Map<String, dynamic> decodedToken = _parseJwt(myToken);
      String role = decodedToken['rol'];
      String userNameEmpl = decodedToken['usuario'];
      String email = decodedToken['email'];
      String id = decodedToken['id'];
      String cedula = decodedToken['cedula'];

      _filtrarUsuarioController.text = userNameEmpl;
      _filtrarEmailController.text = email;
      _filtrarId.text = id;
      _filtrarCedula.text = cedula;

      if (role == 'Administrador'){
        // Si el rol es Administrador, redirige a la pantalla de administrador
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AdministradorScreen(
            filtrarUsuarioController: _filtrarUsuarioController,
            filtrarEmailController: _filtrarEmailController,
            filtrarId: _filtrarId,
            filtrarCedula: _filtrarCedula
          ))
        );
      } else {
        // Si el rol es falso, redirige a la pantalla de empleado
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EmpleadoScreens(
              filtrarUsuarioController: _filtrarUsuarioController,
              filtrarEmailController: _filtrarEmailController,
              filtrarId: _filtrarId,
              filtrarCedula: _filtrarCedula
            )
          )
        );
      } 

    } else {
      // Manejar el error de login
      _showSnackBar('Credenciales incorrectas.');
    }
  }

  Map<String, dynamic> _parseJwt(String token){
    final parts = token.split('.');
    final payload = base64Url.decode(base64Url.normalize(parts[1]));
    return json.decode(utf8.decode(payload));
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            cajaverde(size), 
            logo(size),
            buttonBack(size),
            ventanalogin(size, context)
          ],
        ),
      ),
    );
  }

  Container cajaverde(Size size) {
    return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
                Color.fromRGBO(1, 135, 76, 1),
                Color.fromRGBO(3, 221, 127, 1),
              ]),
            ),
            width: double.infinity,
            height: size.height * 0.4,
          );
  }

  Align logo(Size size) {
    return Align(
      alignment: Alignment.topCenter,
      child: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(160),
            color: const Color.fromRGBO(217, 217, 217, 1)
          ),
          margin: EdgeInsets.only(top: size.height * 0.05),
          width: size.width * 0.4,
          height: size.height * 0.26,
          child: Image.asset(
            'assets/Logo/Logo_Metro_transparente.png',
          ),
        ), 
      ),
    );
  }

  Positioned buttonBack(Size size) {
    return Positioned( //ajuste de ubicacion del icono
      top: size.height * 0.05,
      right: size.width * 0.88,
      child: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new_rounded,
          size: size.height * 0.05,              
        ), 
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PresentationScreen(
              filtrarUsuarioController: _filtrarUsuarioController,
              filtrarEmailController: _filtrarEmailController,
              filtrarId: _filtrarId,
              filtrarCedula: _filtrarId,
            ))
          );
        },
      ), 
    );
  }

  Container ventanalogin(Size size, BuildContext context) {

    if(_serviceToken.isLoggedFuncion()){
      return Container(
     
              
      );
    }else{
      return Container(
        padding: const EdgeInsets.fromLTRB(0, 130, 0, 0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 300),
              Container(
                padding: const EdgeInsets.fromLTRB(80, 100, 80, 0),
                // padding: const EdgeInsets.all(50),
                margin: const EdgeInsets.symmetric(horizontal: 30),
                width: double.infinity,
                height: 750, //altura de la ventana "ventanalogin"
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 252, 252, 252),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(5, 20),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    const Text('Inicio Sesion', style: TextStyle(fontSize: 54)),
                    const SizedBox(height: 30),
                    Container(
                      child: Form(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _userController,
                              autocorrect: true,
                              decoration: InputDecorations.inputDecoration(
                                hintext: 'User o Admin',
                                hintFrontSize: 30.0,
                                labeltext: 'Nombre Usuario',
                                labelFrontSize: 30.5,
                                icono: const Icon(Icons.account_circle, size: 30.0)
                              ),
                              style: const TextStyle(fontSize: 30.0),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return const Text(
                                    'Por favor ingrese su nombre de usuario',
                                    style: TextStyle(fontSize: 20.0), // Ajusta el tamaño del texto
                                  ).data;
                                }

                                return null;
                              },
                            ),
                            
                            const SizedBox(height: 30),
                            TextFormField(
                              autocorrect: false,
                              obscureText: true,
                              controller: _passwordController,
                              decoration: InputDecorations.inputDecoration(
                                hintext: '******',
                                hintFrontSize: 30.0,
                                labeltext: 'Contraseña',
                                labelFrontSize: 30.5,
                                icono: const Icon(Icons.lock_clock_outlined, size: 30.0)
                              ),
                              style: const TextStyle(fontSize: 30.0),
                              validator: (value) {
                                // return (value != null && value.length >= 6)
                                //   ? null
                                //   : 'La contraseña debe ser mayor o igual a los 6 caracteres';
                                if (value == null || value.isEmpty) {
                                  return const Text(
                                    'La contraseña debe ser mayor o igual a los 6 caracteres',
                                    style: TextStyle(fontSize: 20.0), // Ajusta el tamaño del texto
                                  ).data;
                                }

                                return null;
                              },
                            ),

                            const SizedBox(height: 100),
                            MaterialButton(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              disabledColor: const Color.fromARGB(255, 121, 215, 125),
                              color: const Color.fromRGBO(1, 135, 76, 1),
                              onPressed: _login,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                                child: const Text('Ingresar', style: TextStyle(color: Colors.white, fontSize: 35)),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 50),
              const Text('Olvide la contraseña',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      );
    }
  }
}