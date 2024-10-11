/*
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:formulario_opret/models/userAdministrador.dart';
import 'package:formulario_opret/screens/interfaz_Admin/navbar/navbar.dart';
import 'package:formulario_opret/services/admin_services.dart';
import 'package:formulario_opret/widgets/input_decoration.dart';
import 'package:formulario_opret/widgets/select_Image.dart';
// import 'package:formulario_opret/widgets/upperCaseText.dart';
// import 'package:http/http.dart' as http;

class PagEdit extends StatefulWidget {
  final UsuarioAdministrador idAdmin; // PASAR adminId al constructor
  // const PagEdit({super.key});
  const PagEdit({super.key, required this.idAdmin});

  @override
  State<PagEdit> createState() => _PagEditState();
}

class _PagEditState extends State<PagEdit> {
  File? _image;
  // final SelectImage _selectImage = SelectImage();
  final _formKey = GlobalKey<FormBuilderState>();
  // final UpperCaseTextEditingController _controller = UpperCaseTextEditingController();
  final ApiServiceAdmin _apiServiceAdmin = ApiServiceAdmin('https://10.0.2.2:7002');

  // Método para seleccionar la imagen
  Future<void> _pickImage() async {
    final image = await SelectImage().pickImage();
    if (image != null) {
      setState(() {
        _image = image;
      });
    }
  }

  // Método para actualizar el perfil del administrador
  void _updateProfile() async {
    if(_formKey.currentState!.validate()) {
      // final imageFile = _image;
      final formData = _formKey.currentState!.value;

      final data = {
        'nombre': formData['nombre'],
        'apellido': formData['apellido'],
        'cedula': formData['cedula'],
        'nombreUsuario': formData['nombreUsuario'],
        'email': formData['email'],
        'password': formData['password'],
        'resptPassword': formData['resptPassword'],
      };

      // Convertir imagen a bytes si existe
      Uint8List? imageBytes;
      if (_image != null) {
        imageBytes = await _image!.readAsBytes();
      }

      final admin = UsuarioAdministrador(
        idUsuarioAdmin: widget.idAdmin.idUsuarioAdmin, // Usamos el adminId pasado a la pantalla
        cedlAdministrador: data['cedula'],
        nombreAdministrador: '${data['nombre']} ${data['apellido']}',
        nombreUsuarioAdmin: data['nombreUsuario'],
        emailAdmin: data['email'],
        passwordsAdmin: data['password'],
        resptPasswordsAdmin: data['resptPassword'],
        fotoAdmin: imageBytes, // Se envían los bytes de la imagen si están disponibles
      );

      try {
          // final response = await _apiServiceAdmin.updateUsuarioAdmin(/*adminId: widget.idAdmin.idUsuarioAdmin, admin: admin*/);
          // if (response.statusCode == 200) {
          //   // Mostrar mensaje de éxito
          //   ScaffoldMessenger.of(context).showSnackBar(
          //     const SnackBar(content: Text('Administrador agregado exitosamente')),
          //   );
          // } else {
          //   // Mostrar mensaje de error
          //   ScaffoldMessenger.of(context).showSnackBar(
          //     SnackBar(content: Text('Error al agregar Administrador ${response.reasonPhrase}')),
          //   );
          // }
        } catch (e) {
          // Manejo de errores
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil'),
        backgroundColor: const Color.fromRGBO(1, 135, 76, 1),
      ),
      drawer: const Navbar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              // padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
              const SizedBox(height: 50),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: 300,
                  height: 300,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor:
                        Colors.grey[200], // Fondo del CircleAvatar
                    child: ClipOval(
                      child: _image != null
                          ? Image.file(
                              _image!,
                              width: 285,
                              height: 285,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              'assets/figuras/agregarfotos.png',
                              width: 285,
                              height: 285,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                )
              ),
              const SizedBox(height: 50),

              Padding(
                padding: const EdgeInsets.fromLTRB(100, 0, 100, 0),
                child: FormBuilder(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: [      
                      // FormBuilderTextField(
                      //   name: 'idUsuario',
                      //   controller: _controller,
                      //   decoration: InputDecorations.inputDecoration(
                      //       hintext: 'ADMIN-000000000',
                      //       labeltext: 'ID de Usuario asignado',
                      //       icono:
                      //           const Icon(Icons.account_circle_outlined)),
                      //   validator: (value) {
                      //     if (value == null || value.isEmpty) {
                      //       return 'Por favor ingrese su ID-Empleado';
                      //     }

                      //     if (!RegExp(r'^ADMIN-\d{4,10}$')
                      //         .hasMatch(value)) {
                      //       return 'Por favor ingrese un ID-Empleado valido';
                      //     }

                      //     return null;
                      //   },
                      // ),
                      // const SizedBox(height: 30),

                      Row(
                        //para hacer que los TextFormField se olganicen en filas
                        children: [
                          Expanded(
                            //Nombre
                            child: FormBuilderTextField(
                              name: 'nombre',
                              keyboardType: TextInputType.name,
                              decoration: InputDecorations.inputDecoration(
                                  hintext: 'Primer y Segundo Nom.',
                                  labeltext: 'Nombre',
                                  icono:
                                      const Icon(Icons.person_2_outlined)),
                            ),
                          ),

                          const SizedBox(
                              width: 16.0), // Espacio entre los campos

                          Expanded(
                            //Apellido
                            child: FormBuilderTextField(
                              name: 'apellido',
                              keyboardType: TextInputType.name,
                              decoration: InputDecorations.inputDecoration(
                                  hintext: 'Primer y Segundo Apell.',
                                  labeltext: 'Apellido',
                                  icono:
                                      const Icon(Icons.person_2_outlined)),
                            ),
                          )
                        ],
                      ),

                      const SizedBox(height: 30),
                      FormBuilderTextField(
                        //Cedula
                        name: 'cedula',
                        keyboardType: TextInputType.number,
                        autocorrect: true,
                        decoration: InputDecorations.inputDecoration(
                            hintext: '000-0000000-0',
                            labeltext: 'Cedula de identidad',
                            icono: const Icon(Icons.perm_identity_rounded)),
                        validator: (value) {
                          String pattern = r'^\d{3}-\d{7}-\d{1}$';
                          RegExp regExp = RegExp(pattern);
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingrese su cédula';
                          }

                          if (!regExp.hasMatch(value)) {
                            return 'Formato de cédula incorrecto';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 30),
                      FormBuilderTextField(
                        //Correo
                        name: 'email',
                        keyboardType: TextInputType.emailAddress,
                        autocorrect: false,
                        decoration: InputDecorations.inputDecoration(
                            hintext: 'ejemplo20##@gmail.com',
                            labeltext: 'Correo Electronico',
                            icono:
                                const Icon(Icons.alternate_email_rounded)),
                        style: const TextStyle(
                          fontSize: 20, //ajuste del tamaño
                        ),
                        validator: (value) {
                          // expresion regular
                          String pattern =
                              r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$';
                          RegExp regExp = new RegExp(pattern);
                          return regExp.hasMatch(value ?? '')
                              ? null
                              : 'Ingrese un correo electronico valido';
                        },
                      ),

                      const SizedBox(height: 30),
                      FormBuilderTextField(
                        //Usuario
                        name: 'nombreUsuario',
                        keyboardType: TextInputType.name,
                        decoration: InputDecorations.inputDecoration(
                            hintext: 'MetroSantDom123',
                            labeltext: 'Usuario',
                            icono: const Icon(Icons.person_pin_circle)),
                      ),
                      const SizedBox(height: 60),
                    ],
                  ),
                )
              ),
              
              //Texto de "Cambiar Contraseña"  
              const Text(
                'Cambiar Contraseña',
                textAlign: TextAlign
                    .center, //para determinar la posicion del texto
                style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 1, 42, 0)),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(100, 0, 100, 0),
                child: FormBuilder(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: [
                      Divider(),
                      FormBuilderTextField(
                        //Contraseña
                        name: 'password',
                        autocorrect: false,
                        obscureText: true,
                        decoration: InputDecorations.inputDecoration(
                            hintext: '******',
                            labeltext: 'Contraseña',
                            icono: const Icon(Icons.lock_person_rounded)),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingrese la nueva contraseña';
                          }

                          if (value.length < 6) {
                            return 'La contraseña debe tener al menos 6 caracteres';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 30),
                      FormBuilderTextField(
                        //repetir contraseña
                        name: 'resptPassword',
                        autocorrect: false,
                        obscureText: true,
                        decoration: InputDecorations.inputDecoration(
                            hintext: '******',
                            labeltext: 'Repetir la Contraseña',
                            icono: const Icon(Icons.lock_person_rounded)),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor repita la contraseña';
                          }

                          if (value.length < 6) {
                            return 'La contraseña debe tener al menos 6 caracteres';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 50),

                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(1, 135, 76, 1), //  se usa para definir el color de fondo del botón.
                          foregroundColor: const Color.fromARGB(255, 255, 255, 255), // se usa para definir el color del texto y los iconos dentro del botón.
                          padding: const EdgeInsets.symmetric(horizontal: 90, vertical: 15),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(50), //Define el radio para la esquina superior izquierda.
                              topRight: Radius.circular(50), //Define el radio para la esquina superior derecha.
                              bottomLeft: Radius.circular(50), //Define el radio para la esquina inferior izquierda.
                              bottomRight: Radius.circular(50), //Define el radio para la esquina inferior derecha.
                            ),
                          ),
                        ),
                        onPressed: _updateProfile,
                        child: const Text(
                          'Guardar',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                      const SizedBox(height: 100)

                    ],
                  )
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
*/
 // void _updateProfile() async {
  //   if(_formkey.currentState!.validate()){
  //     final formData = _formkey.currentState!.value;
  //     final imageFile = _image;

  //     try{
  //       final response = await _apiServiceAdmin.updateUsuarioAdmin(formData, imageFile);
  //       if (response.statusCode == 200) {
  //         // Mostrar un mensaje de éxito al usuario
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(
  //             content: Text('Perfil actualizado con éxito'),
  //           ),
  //         );
  //       } else {
  //         // Mostrar un mensaje de error al usuario
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(
  //             content: Text('Error al actualizar perfil'),
  //           ),
  //         );
  //       }
  //     } catch (e) {
  //       // Mostrar un mensaje de error al usuario
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text('Error al actualizar perfil: $e'),
  //         ),
  //       );
  //     }
  //   }
  // }