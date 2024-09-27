import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:formulario_opret/models/userEmpleado.dart';
import 'package:formulario_opret/screens/interfaz_Admin/navbar/navbar.dart';
import 'package:formulario_opret/services/user_services.dart';
import 'package:formulario_opret/widgets/input_decoration.dart';

class RegistroEmpl extends StatefulWidget {
  const RegistroEmpl({super.key});

  @override
  State<RegistroEmpl> createState() => _RegistroEmplState();
}

class _RegistroEmplState extends State<RegistroEmpl> {
  final ApiService _apiService = ApiService('https://10.0.2.2:7002'); // Cambia por tu URL
  late Future<List<UsuariosEmpl>> _usuarios;

  @override
  void initState(){
    super.initState();
    _usuarios = _apiService.getUsuariosEmpls(); // Cargar los usuarios al iniciar
  }

  // Llamada para refrescar datos
  void _refreshUsuarios() {
    setState(() {
      _usuarios = _apiService.getUsuariosEmpls();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Navbar(),
      appBar: AppBar(title: const Text('Registro Empleados')),
      body: FutureBuilder<List<UsuariosEmpl>>(
        future: _usuarios,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator());
          }else if (snapshot.hasError){
            return Center(child: Text('Error al cargar los datos: ${snapshot.error}'));
          }else {
            final usuarios = snapshot.data ?? [];

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal, // Permitir scroll horizontal
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('ID', style: TextStyle(fontSize: 23.0))),
                  DataColumn(label: Text('Cedula', style: TextStyle(fontSize: 23.0))),
                  DataColumn(label: Text('Nombre Completo', style: TextStyle(fontSize: 23.0))),
                  DataColumn(label: Text('Usuario', style: TextStyle(fontSize: 23.0))),
                  DataColumn(label: Text('Correo Electronico', style: TextStyle(fontSize: 23.0))),
                  DataColumn(label: Text('Rol', style: TextStyle(fontSize: 23.0))),
                  DataColumn(label: Text('Accion', style: TextStyle(fontSize: 23.0)))
                ], 
                rows: usuarios.map((usuario){
                  return DataRow(
                    cells: [
                      DataCell(Text(usuario.idUsuarioEmpl, style: const TextStyle(fontSize: 20.0))),
                      DataCell(Text(usuario.cedlEmpleado, style: const TextStyle(fontSize: 20.0))),
                      DataCell(Text(usuario.nombreEmpleado, style: const TextStyle(fontSize: 20.0))),
                      DataCell(Text(usuario.nombreUsuarioEmpl, style: const TextStyle(fontSize: 20.0))),
                      DataCell(Text(usuario.emailEmpl, style: const TextStyle(fontSize: 20.0))),
                      DataCell(Text(usuario.rol, style: const TextStyle(fontSize: 20.0))),
                      DataCell(
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit), 
                              onPressed: (){
                                _showEditDialog(usuario);
                              },
                            ),
              
                            IconButton(
                              onPressed: () {
                                _showDeleteDialog(usuario);
                              }, 
                              icon: const Icon(Icons.delete)
                            )
                          ],
                        )
                      )
                    ]
                  );
                }).toList(),
              ),
            );
          }
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCreateDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // Mostrar diálogo para crear un nuevo usuario
  void _showCreateDialog() {
    final formKey = GlobalKey<FormBuilderState>();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    @override
    void dispose(){
      passwordController.dispose();
      confirmPasswordController.dispose();
      super.dispose();
    }

    showDialog(
      context: context,
      builder: (context) {
        // Formulario para crear usuario
        return AlertDialog(
          title: const Text('Crear Usuario'),
          contentPadding: const EdgeInsets.fromLTRB(60, 20, 60, 50),  // Elimina el padding por defecto
          content: Container(
            // margin: const EdgeInsets.all(70),  // Aplica margen
            child: FormBuilder(
              key: formKey,
            
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FormBuilderTextField(
                    name: 'id',
                    decoration: InputDecorations.inputDecoration(
                      labeltext: 'Asignar ID',
                      labelFrontSize: 25.5, // Tamaño de letra personalizado
                      hintext: 'USER-000000000',
                      hintFrontSize: 20.0,
                      icono: const Icon(Icons.perm_identity_outlined,size: 30.0),
                    ),
                    // validator: FormBuilderValidators.required(),
                    validator: (value) {
                      if (value == null || value.isEmpty){
                        return 'Por favor ingrese su ID-Empleado';
                      }

                      if (!RegExp(r'^USER-\d{4,10}$').hasMatch(value)){
                        return 'Por favor ingrese un ID-Empleado valido';
                      }

                      return null;
                    },
                  ),

                  FormBuilderTextField(
                    name: 'cedula',
                    decoration: InputDecorations.inputDecoration(
                      labeltext: 'Cedula',
                      labelFrontSize: 25.5,
                      hintext: '000-0000000-0',
                      hintFrontSize: 20.0, 
                      icono: const Icon(Icons.person_pin_circle_outlined, size: 30.0),
                    ),
                    // validator: FormBuilderValidators.required(),
                    validator: FormBuilderValidators.compose([ //Combina varios validadores. En este caso, se utiliza el validador requerido y una función personalizada para la expresión regular.
                      FormBuilderValidators.required(errorText: 'Debe de ingresar la cedula'), //Valida que el campo no esté vacío y muestra el mensaje 'El correo es obligatorio' si no se ingresa ningún valor.
                      (value) {
                        // Expresión regular para validar la cedula
                        String pattern = r'^\d{3}-\d{7}-\d{1}$';
                        RegExp regExp = RegExp(pattern);
                        // if(value == null || value.isEmpty){
                        //   return 'Por favor ingrese su cédula';
                        // }

                        if(!regExp.hasMatch(value ?? '')){
                          return 'Formato de cédula incorrecto';
                        }
                        return null;
                      },
                    ]),                    
                  ),

                  FormBuilderTextField(
                    name: 'nombre',
                    decoration: InputDecorations.inputDecoration(
                      labeltext: 'Nombre Completo',
                      labelFrontSize: 25.5,
                      hintext: 'Nombre y Apellido',
                      hintFrontSize: 20.0,
                      icono: const Icon(Icons.person, size: 30.0),
                    ),
                    validator: FormBuilderValidators.required(),
                  ),

                  FormBuilderTextField(
                    name: 'usuario',
                    decoration: InputDecorations.inputDecoration(
                      labeltext: 'Usuario',
                      labelFrontSize: 25.5,
                      hintext: 'MetroSantDom123',
                      hintFrontSize: 20.0,
                      icono: const Icon(Icons.account_circle, size: 30.0),
                    ),
                    validator: FormBuilderValidators.username(),
                  ),

                  FormBuilderTextField(
                    name: 'emailEmpl',
                    decoration: InputDecorations.inputDecoration(
                      labeltext: 'Email',
                      labelFrontSize: 25.5,
                      hintext: 'ejemplo20##@gmail.com',
                      hintFrontSize: 20.0,
                      icono: const Icon(Icons.alternate_email_rounded, size: 30.0),
                    ),
                    // validator: FormBuilderValidators.required(),
                    validator: (value){
                      // expresion regular
                      String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$';
                      RegExp regExp = RegExp(pattern);
                      return regExp.hasMatch(value ?? '')
                        ? null
                        : 'Ingrese un correo electronico valido';
                    },
                  ),

                  FormBuilderTextField(
                    name: 'passwords',
                    autocorrect: false,
                    obscureText: true,
                    controller: passwordController,
                    decoration: InputDecorations.inputDecoration(
                      labeltext: 'Contraseña',
                      labelFrontSize: 25.5,
                      hintext: '******',
                      hintFrontSize: 20.0,
                      icono: const Icon(Icons.lock_person_outlined, size: 30.0),
                    ),
                    // validator: FormBuilderValidators.required(),
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
                  FormBuilderTextField(
                    name: 'resptPassword',
                    autocorrect: false,
                    obscureText: true,
                    controller: confirmPasswordController,
                    decoration: InputDecorations.inputDecoration(
                      labeltext: 'Repetir Contraseña',
                      labelFrontSize: 25.5,
                      hintext: '******',
                      hintFrontSize: 20.0,
                      icono: const Icon(Icons.lock_person_outlined, size: 30.0),
                    ),
                    // validator: FormBuilderValidators.required(),
                    validator: (value) {
                      if(value == null || value.isEmpty){
                        return 'Por favor repita la contraseña';
                      }

                      if(value.length < 6){
                        return 'La contraseña debe tener al menos 6 caracteres';                                    
                      }

                      if(value != passwordController.text){
                        return 'Las contraseñas no coinciden';
                      }

                      return null;
                    },
                  ),
                  FormBuilderTextField(
                    name: 'rol',
                    decoration: InputDecorations.inputDecoration(
                      labeltext: 'Rol',
                      labelFrontSize: 25.5,
                      hintext: 'Empleado',
                      hintFrontSize: 20.0,
                      icono: const Icon(Icons.groups_3_outlined, size: 30.0),
                    ),
                    // validator: FormBuilderValidators.required(),
                    validator: (value) {
                      if(value == null || value.isEmpty){
                        return 'Por favor ingrese el rol';
                      }

                      if(value != 'Empleado'){
                        return 'Solo se permite el rol de Empleado';
                      }

                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if(formKey.currentState!.saveAndValidate()){
                  final formData = formKey.currentState!.value;
                  UsuariosEmpl nuevoUsuario = UsuariosEmpl(
                    idUsuarioEmpl: formData['id'],
                    cedlEmpleado: formData['cedula'],
                    nombreEmpleado: formData['nombre'],
                    nombreUsuarioEmpl: formData['usuario'],
                    emailEmpl: formData['emailEmpl'],
                    passwordsEmpl: 'password', // Este campo lo puedes ajustar
                    resptPasswordsEmpl: 'resptPassword', // Ajusta este campo también
                    rol: 'rol', // El rol lo puedes ajustar
                    // fotoEmpl: null, // Ajustar si hay una imagen
                  );

                  // Llamar al servicio para crear el usuario
                  try {
                    final response = await ApiService('https://10.0.2.2:7002')
                        .createUsuarioEmpl(nuevoUsuario);
                    if (response.statusCode == 201) {
                      print('Usuario creado con éxito');
                      Navigator.of(context).pop(); // Cerrar el diálogo
                      // Refrescar la lista de usuarios aquí
                      _refreshUsuarios();
                    } else {
                      print('Error al crear usuario: ${response.body}');
                    }
                  } catch (e) {
                    print('Excepción al crear usuario: $e');
                  }
                }
              }, 
              child: const Text('Guardar', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
            )
          ],
        );
      },
    );
  }

  // Mostrar diálogo para editar un usuario
  void _showEditDialog(UsuariosEmpl userUpload) {
    final formKey = GlobalKey<FormBuilderState>(); // Clave para manejar el estado del formulario
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) {
        // Formulario para editar usuario
        return AlertDialog(
          title: const Text('Editar Usuario'),
          contentPadding: const EdgeInsets.fromLTRB(60, 20, 60, 50),  // Adaptar el padding por defecto
          content: FormBuilder(
            key: formKey,
            initialValue: { //la funicion de "initialValue" es firtral de manera automatica los datos de los diferentes campos de la base de datos
              'nombreEmpleado': userUpload.nombreEmpleado,
              'usuario': userUpload.nombreUsuarioEmpl,
              'emailEmpl': userUpload.emailEmpl,
              'password': userUpload.passwordsEmpl,
              'resptPassword': userUpload.resptPasswordsEmpl
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FormBuilderTextField(
                  name: 'nombreEmpleado',
                  decoration: InputDecorations.inputDecoration(
                    labeltext: 'Nombre Completo',
                    labelFrontSize: 30.5,
                    hintext: 'Nombre y Apellido',
                    hintFrontSize: 25.0,
                    icono: const Icon(Icons.person, size: 30.0),
                  ),
                  style: const TextStyle(fontSize: 23.5), // Cambiar tamaño de letra del texto filtrado
                  validator: FormBuilderValidators.required(),
                ),

                FormBuilderTextField(
                  name: 'usuario',
                  decoration: InputDecorations.inputDecoration(
                    labeltext: 'Usuario',
                    labelFrontSize: 25.5,
                    hintext: 'MetroSantDom123',
                    hintFrontSize: 20.0,
                    icono: const Icon(Icons.account_circle, size: 30.0),
                  ),
                  style: const TextStyle(fontSize: 23.5), // Cambiar tamaño de letra del texto filtrado
                  validator: FormBuilderValidators.username(),
                ),

                FormBuilderTextField(
                  name: 'emailEmpl',
                  decoration: InputDecorations.inputDecoration(
                    labeltext: 'Email',
                    labelFrontSize: 25.5,
                    hintext: 'ejemplo20##@gmail.com',
                    hintFrontSize: 20.0,
                    icono: const Icon(Icons.alternate_email_rounded, size: 30.0),
                  ),
                  // validator: FormBuilderValidators.required(),
                  style: const TextStyle(fontSize: 23.5), // Cambiar tamaño de letra del texto filtrado
                  validator: (value){
                    // expresion regular
                    String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$';
                    RegExp regExp = RegExp(pattern);
                    return regExp.hasMatch(value ?? '')
                      ? null
                      : 'Ingrese un correo electronico valido';
                  },
                ),

                FormBuilderTextField(
                  name: 'password',
                  autocorrect: false,
                  obscureText: true,
                  controller: passwordController,
                  decoration: InputDecorations.inputDecoration(
                    labeltext: 'Contraseña',
                    labelFrontSize: 25.5,
                    hintext: '******',
                    hintFrontSize: 20.0,
                    icono: const Icon(Icons.lock_person_outlined, size: 30.0),
                  ),
                  // validator: FormBuilderValidators.required(),
                  style: const TextStyle(fontSize: 23.5), // Cambiar tamaño de letra del texto filtrado
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
                FormBuilderTextField(
                  name: 'resptPassword',
                  autocorrect: false,
                  obscureText: true,
                  controller: confirmPasswordController,
                  decoration: InputDecorations.inputDecoration(
                    labeltext: 'Contraseña',
                    labelFrontSize: 25.5,
                    hintext: '******',
                    hintFrontSize: 20.0,
                    icono: const Icon(Icons.lock_person_outlined, size: 30.0),
                  ),
                  // validator: FormBuilderValidators.required(),
                  style: const TextStyle(fontSize: 23.5), // Cambiar tamaño de letra del texto filtrado
                  validator: (value) {
                    if(value == null || value.isEmpty){
                      return 'Por favor repita la contraseña';
                    }

                    if(value.length < 6){
                      return 'La contraseña debe tener al menos 6 caracteres';                                    
                    }

                    if(value != passwordController.text){
                      return 'Las contraseñas no coinciden';
                    }

                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Actualizar', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              onPressed: () async {
                // Llamar al método de actualización y refrescar la lista
                if(formKey.currentState!.saveAndValidate()){
                  // Obtener los valores del formulario
                  final formData = formKey.currentState!.value;
                  UsuariosEmpl usuarioActualizado = UsuariosEmpl(
                    idUsuarioEmpl: userUpload.idUsuarioEmpl, // Mantener el ID original
                    cedlEmpleado: userUpload.cedlEmpleado,
                    nombreEmpleado: formData['nombreEmpleado'],
                    nombreUsuarioEmpl: formData['usuario'],
                    emailEmpl: formData['emailEmpl'],
                    passwordsEmpl: formData['password'], // Mantener la contraseña original
                    resptPasswordsEmpl: formData['resptPassword'], // Mantener la respuesta original
                    rol: userUpload.rol, // Mantener el rol original
                    // fotoEmpl: usuario.fotoEmpl, // Mantener la foto original
                  );

                  // Llamar al servicio para actualizar el usuario
                  try {
                    final response = await ApiService('https://10.0.2.2:7002')
                        .updateUsuarioEmpl(userUpload.idUsuarioEmpl, usuarioActualizado);
                    if (response.statusCode == 204) {
                      print('Usuario actualizado con éxito');
                      Navigator.of(context).pop(); // Cerrar el diálogo
                      // Refrescar la lista de usuarios aquí
                      _refreshUsuarios();
                    } else {
                      print('Error al actualizar usuario: ${response.body}');
                    }
                  } catch (e) {
                    print('Excepción al actualizar usuario: $e');
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  // Mostrar diálogo para Eliminar un usuario
  void _showDeleteDialog(UsuariosEmpl userDelete) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Eliminar Usuario', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          contentPadding: const EdgeInsets.fromLTRB(80, 40, 60, 50),
          content: Text('¿Estás seguro de que deseas eliminar al usuario ${userDelete.nombreEmpleado}?', style: const TextStyle(fontSize: 30)),
          actions: [
            TextButton(
              child: const Text('Cancelar', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo si se cancela
              },
            ),
            TextButton(
              child: const Text('Eliminar', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              onPressed: () async {
                // Llamar al servicio de eliminación
                try {
                  final response = await ApiService('https://10.0.2.2:7002')
                      .deleteUsuarioEmpl(userDelete.idUsuarioEmpl);
                  if (response.statusCode == 204) {
                    print('Usuario eliminado con éxito');
                    Navigator.of(context).pop(); // Cerrar el diálogo después de la eliminación
                    // Refrescar la lista de usuarios aquí
                    _refreshUsuarios();
                  } else {
                    print('Error al eliminar usuario: ${response.body}');
                  }
                } catch (e) {
                  print('Excepción al eliminar usuario: $e');
                }
              },
            ),
          ],
        );
      },
    );
  }
}