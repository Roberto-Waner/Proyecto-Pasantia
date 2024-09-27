import 'package:flutter/material.dart';
// import 'package:formulario_opret/models/userAdministrador.dart';
import 'package:formulario_opret/models/userEmpleado.dart';
import 'package:formulario_opret/screens/interfaz_User/Empleado_screen.dart';
import 'package:formulario_opret/screens/presentation_screen.dart';
// import 'package:formulario_opret/services/admin_services.dart';
// import 'package:formulario_opret/services/login_services_token.dart';
import 'package:formulario_opret/services/user_services.dart';
import 'package:formulario_opret/widgets/input_decoration.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:formulario_opret/widgets/upperCaseText.dart';

class NewUser extends StatefulWidget {
  // const NewUser({super.key});
  final TextEditingController filtrarUsuarioController;
  final TextEditingController filtrarEmailController;
  final TextEditingController filtrarId;
  final TextEditingController filtrarCedula;

  const NewUser({
    required this.filtrarId,
    required this.filtrarCedula,
    required this.filtrarUsuarioController,
    required this.filtrarEmailController,
    super.key,
  });

  @override
  State<NewUser> createState() => _NewUserState();
}

class _NewUserState extends State<NewUser> {
  // late List<UserEmpleado> data = [];
  String _selectedRole = ''; // Valor inicial del Dropdown
  final _formkey = GlobalKey<FormBuilderState>();
  final ApiService apiService = ApiService('https://10.0.2.2:7002');
  // final ApiServiceAdmin apiServiceAdmin = ApiServiceAdmin('https://10.0.2.2:7002');
  final UpperCaseTextEditingController _controller = UpperCaseTextEditingController();

  // final ApiServiceToken _apiServiceToken = ApiServiceToken('https://10.0.2.2:7002', false);



  void _registrarUser() async {
    if(_formkey.currentState!.saveAndValidate()){
      final data = _formkey.currentState!.value;
      final nombreCompleto = '${data['nombre']} ${data['apellido']}';

      //if(_selectedRole == 'Empleado'){
        final user = UsuariosEmpl(
          idUsuarioEmpl: data['idUsuario'],
          cedlEmpleado: data['cedula'],
          nombreEmpleado: nombreCompleto, // Concatenación de nombre y apellido
          nombreUsuarioEmpl: data['nombreUsuario'],
          emailEmpl: data['email'],
          passwordsEmpl: data['password'],
          resptPasswordsEmpl: data['resptPassword'],
          rol: _selectedRole,
        );

        try {
          final response = await apiService.createUsuarioEmpl(user);
          if (response.statusCode == 201) {
            // Mostrar mensaje de éxito
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Usuario agregado exitosamente')),
            );
          } else {
            // Mostrar mensaje de error
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error al agregar usuario: ${response.reasonPhrase} de rol: $_selectedRole')),
            );
          }
        } catch (e) {
          // Manejo de errores
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      //}
      /*else if(_selectedRole == 'Administrador'){
        final admin = UsuarioAdministrador(
          idUsuarioAdmin: data['idUsuario'],
          cedlAdministrador: data['cedula'],
          nombreAdministrador: nombreCompleto,
          nombreUsuarioAdmin: data['nombreUsuario'],
          emailAdmin: data['email'],
          passwordsAdmin: data['password'],
          resptPasswordsAdmin: data['resptPassword'],
          rol: _selectedRole,
        );

        try {
          final response = await apiServiceAdmin.createUsuarioAdmin(admin);
          if (response.statusCode == 201) {
            // Mostrar mensaje de éxito
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Administrador agregado exitosamente')),
            );
          } else {
            // Mostrar mensaje de error
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error al agregar el Administrador: ${response.reasonPhrase}')),
            );
          }
        } catch (e) {
          // Manejo de errores
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      }*/
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container( 
        decoration: const BoxDecoration( //para el fondo
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(1, 135, 76, 1),
              Color.fromRGBO(3, 221, 127, 1),
            ])
        ),
        width: double.infinity,
        height: double.infinity,

        // para el grupo de widgets que tendra la pestaña
        child: Stack(
          children: [
            // Boton para retroceder
            Positioned( //ajuste de ubicacion del icono
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
                      filtrarUsuarioController: widget.filtrarUsuarioController,  
                      filtrarEmailController: widget.filtrarEmailController,
                      filtrarId: widget.filtrarId,
                      filtrarCedula: widget.filtrarCedula, 
                    ))
                  );
                },
              ), 
            ),

            //Logo
            Align(
              alignment: Alignment.topCenter,
              child: SafeArea(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(160),
                    color: const Color.fromRGBO(217, 217, 217, 1)
                  ),
                  margin: EdgeInsets.only(top: size.height * 0.02),
                  width: size.width * 0.35,
                  height: size.height * 0.22,
                  child: Image.asset(
                    'assets/Logo/Logo_Metro_transparente.png',
                  ),
                ), 
              ),
            ),

            // Texto de "Ingrese sus Datos"
            Positioned(
              top: size.height * 0.30,
              left: size.width * 0.25,
              right: size.width * 0.25,
              child: const Text('Ingrese sus Datos', 
              textAlign: TextAlign.center, //para determinar la posicion del texto
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.white
              ),),
            ),
            
            //ventana centrar
            Container(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // ventana que ocupara los demas elementos
                    const SizedBox(height: 490),
                    Container(
                      padding: const EdgeInsets.fromLTRB(80, 100, 80, 0),
                      margin: const EdgeInsets.symmetric(horizontal: 30),
                      width: double.infinity,
                      height: 1050, //altura de la ventana "ventanaRegistro"
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(217, 217, 217, 1),
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: const [
                          BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(5, 20)),
                        ],
                      ),

                      child: FormBuilder(
                        key: _formkey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Column(
                          children: [
                            FormBuilderTextField(
                              name: 'idUsuario',
                              controller: _controller,
                              decoration: InputDecorations.inputDecoration(
                                hintext: 'USER-000000000 o ADMIN-000000000', 
                                labeltext: 'ID de Usuario asignado', 
                                icono: const Icon(Icons.account_circle_outlined)
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty){
                                  return 'Por favor ingrese su ID-Empleado';
                                }

                                if (!RegExp(r'^(USER|ADMIN)-\d{4,10}$').hasMatch(value)){
                                  return 'Por favor ingrese un ID-Empleado valido';
                                }

                                return null;
                              },
                            ),
                            const SizedBox(height: 30),

                            Row( //para hacer que los TextFormField se olganicen en filas
                              children: [
                                Expanded( //Nombre
                                  child: FormBuilderTextField(
                                    name: 'nombre',
                                    keyboardType: TextInputType.name,
                                    decoration: InputDecorations.inputDecoration(
                                      hintext: 'Primer y Segundo Nom.',
                                      labeltext: 'Nombre',
                                      icono: const Icon(Icons.person_2_outlined)
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 16.0), // Espacio entre los campos
                                
                                Expanded( //Apellido
                                  child: FormBuilderTextField(
                                    name: 'apellido',
                                    keyboardType: TextInputType.name,
                                    decoration: InputDecorations.inputDecoration(
                                      hintext: 'Primer y Segundo Apell.',
                                      labeltext: 'Apellido',
                                      icono: const Icon(Icons.person_2_outlined)
                                    ),
                                  ),
                                )
                              ],
                            ),

                            const SizedBox(height: 30),
                            FormBuilderTextField( //Cedula
                              name: 'cedula',
                              keyboardType: TextInputType.number,
                              autocorrect: true,
                              decoration: InputDecorations.inputDecoration(
                                hintext: '000-0000000-0', 
                                labeltext: 'Cedula de identidad', 
                                icono: const Icon(Icons.perm_identity_rounded)
                              ),
                              validator: (value) {
                                String pattern = r'^\d{3}-\d{7}-\d{1}$';
                                RegExp regExp = RegExp(pattern);
                                if(value == null || value.isEmpty){
                                  return 'Por favor ingrese su cédula';
                                }

                                if(!regExp.hasMatch(value)){
                                  return 'Formato de cédula incorrecto';
                                }
                                return null;
                              },
                            ),
                            
                            const SizedBox(height: 30),
                            FormBuilderTextField( //Correo
                              name: 'email',
                              keyboardType: TextInputType.emailAddress,
                              autocorrect: false,
                              decoration: InputDecorations.inputDecoration(
                                hintext: 'ejemplo20##@gmail.com', 
                                labeltext: 'Correo Electronico', 
                                icono: const Icon(Icons.alternate_email_rounded)                
                              ),
                              style: const TextStyle(
                                fontSize: 20, //ajuste del tamaño
                              ),
                              validator: (value){
                                // expresion regular
                                String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$';
                                RegExp regExp = new RegExp(pattern);
                                return regExp.hasMatch(value ?? '')
                                  ? null
                                  : 'Ingrese un correo electronico valido';
                              },
                            ),

                            const SizedBox(height: 30),
                            FormBuilderTextField( //Usuario
                              name: 'nombreUsuario',
                              keyboardType: TextInputType.name,
                              decoration: InputDecorations.inputDecoration(
                                hintext: 'MetroSantDom123',
                                labeltext: 'Usuario',
                                icono: const Icon(Icons.person_pin_circle)
                              ),
                            ),

                            const SizedBox(height: 30),
                            FormBuilderTextField( //Contraseña
                              name: 'password',
                              autocorrect: false,
                              obscureText: true,
                              decoration: InputDecorations.inputDecoration(
                                hintext: '******', 
                                labeltext: 'Contraseña', 
                                icono: const Icon(Icons.lock_person_rounded)
                              ),
                              validator: (value) {
                                if(value == null || value.isEmpty){
                                  return 'Por favor ingrese la nueva contraseña';
                                }

                                if(value.length < 6){
                                  return 'La contraseña debe tener al menos 6 caracteres';                                    
                                }

                                return null;
                              },
                            ),

                            const SizedBox(height: 30),
                            FormBuilderTextField( //repetir contraseña
                              name: 'resptPassword',
                              autocorrect: false,
                              obscureText: true,
                              decoration: InputDecorations.inputDecoration(
                                hintext: '******', 
                                labeltext: 'Repetir la Contraseña', 
                                icono: const Icon(Icons.lock_person_rounded)
                              ),
                              validator: (value) {
                                if(value == null || value.isEmpty){
                                  return 'Por favor repita la contraseña';
                                }

                                if(value.length < 6){
                                  return 'La contraseña debe tener al menos 6 caracteres';                                    
                                }

                                return null;
                              },
                            ),

                            const SizedBox(height: 30),
                            FormBuilderDropdown<String>(
                              name: 'rol',
                              decoration: InputDecorations.inputDecoration(
                                  labeltext: 'Tipo Usuario',
                                  hintext: 'Selecciona el tipo de usuario',
                                  icono: const Icon(Icons.people_outline_rounded)),
                              initialValue: 'Empleado',
                              items: const [
                                DropdownMenuItem(
                                    value: 'Empleado',
                                    child: Text('Empleado')),
                                DropdownMenuItem(
                                    value: 'Administrador',
                                    child: Text('Administrador')),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _selectedRole = value!;
                                });
                              },
                            ),

                            const SizedBox(height: 50),
                            // fila de botones Inicio y registros
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center, // Para separar los botones de manera uniforme
                              children: [
                                // boton de Registrar
                                ElevatedButton(
                                  onPressed: _registrarUser, 
                                  
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromRGBO(1, 135, 76, 1), //  se usa para definir el color de fondo del botón.
                                    foregroundColor: const Color.fromARGB(255, 255, 255, 255), // se usa para definir el color del texto y los iconos dentro del botón.
                                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(50), //Define el radio para la esquina superior izquierda.
                                        topRight: Radius.circular(0), //Define el radio para la esquina superior derecha.
                                        bottomLeft: Radius.circular(50), //Define el radio para la esquina inferior izquierda.
                                        bottomRight: Radius.circular(0), //Define el radio para la esquina inferior derecha.
                                      ),
                                    ),
                                  ),

                                  child: const Text(
                                    'Registrar',
                                    style: TextStyle(
                                      fontSize: 20, 
                                      fontWeight: FontWeight.bold
                                    )
                                  ),
                                ),
                                
                                // boton de Inicio de seccion
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context, 
                                      MaterialPageRoute(
                                        builder: (context) => EmpleadoScreens(
                                          filtrarUsuarioController: widget.filtrarUsuarioController,  
                                          filtrarEmailController: widget.filtrarEmailController,
                                          filtrarId: widget.filtrarId,
                                          filtrarCedula: widget.filtrarCedula,
                                        ),
                                      )
                                    );
                                  }, 
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromRGBO(1, 135, 76, 1), // Color de fondo del primer botón
                                    foregroundColor: const Color.fromARGB(255, 254, 255, 255), // Color del texto
                                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(0),
                                        topRight: Radius.circular(50),
                                        bottomLeft: Radius.circular(0),
                                        bottomRight: Radius.circular(50),
                                      ),
                                    ),
                                  ),
                                  child: const Text(
                                    'Inicio',
                                    style: TextStyle(
                                      fontSize: 20, 
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ]
                        )
                      ),
                    ),
                    const SizedBox(height: 50),
                    const Text('Restablecer las Casillas.',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    )
                  ],
                )
              ),
            ),
          ],
        ),
      ),
    );
  }
}