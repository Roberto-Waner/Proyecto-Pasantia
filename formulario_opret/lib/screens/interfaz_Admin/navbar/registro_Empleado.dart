import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:formulario_opret/models/userEmpleado.dart';
import 'package:formulario_opret/screens/interfaz_Admin/navbar/navbar.dart';
import 'package:formulario_opret/services/user_services.dart';
import 'package:formulario_opret/widgets/input_decoration.dart';

class RegistroEmpleado extends StatefulWidget {
  const RegistroEmpleado({super.key});

  @override
  State<RegistroEmpleado> createState() => _RegistroEmpleadoState();
}

class _RegistroEmpleadoState extends State<RegistroEmpleado> {
  final _formKey = GlobalKey<FormBuilderState>();
  final ApiService _apiService = ApiService('https://10.0.2.2:7002');
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
      appBar: AppBar(
        title: const Text('Empleados'),
        backgroundColor: const Color.fromRGBO(1, 135, 76, 1),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(1, 135, 76, 1),
              Color.fromRGBO(3, 221, 127, 1),
            ],
          ),
        ),
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0), //aplica padding al cuadro principal
            child: Column(
              children: [
                const SizedBox(height: 50),
                Container( //Cuadro principal
                  padding: const EdgeInsets.fromLTRB(45, 80, 45, 0),
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  width: double.infinity,
                  height: 1050,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(217, 217, 217, 1),
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(5, 20)),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Tabla de Registros de los Usuarios (Empleados)',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 9, 64, 8),
                        ),
                      ),
                      const SizedBox(height: 30),

                      Container( //cuadro de Usuarios
                        padding: const EdgeInsets.fromLTRB(70, 80, 70, 0),
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        width: double.infinity,
                        height: 650, //altura de la ventana "ventanaRegistro"
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 198, 242, 169),
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: const [
                            BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(5, 20)),
                          ],
                        ),

                        child: FormBuilder(
                          key: _formKey,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          child: Column(
                            children: [
                              FormBuilderTextField(
                                name: 'idUsuario',
                                decoration: InputDecorations.inputDecoration(
                                  hintext: 'USER-000000000',
                                  labeltext: 'ID de Usuario asignado',
                                  icono: const Icon(
                                      Icons.account_circle_outlined),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor ingrese su ID-Empleado';
                                  }
                        
                                  if (!RegExp(r'^USER-\d{4,10}$')
                                      .hasMatch(value)) {
                                    return 'Por favor ingrese un ID-Empleado válido';
                                  }
                        
                                  return null;
                                },
                              ),
                              const SizedBox(height: 30),

                              FormBuilderTextField(
                                name: 'nombre',
                                keyboardType: TextInputType.name,
                                decoration: InputDecorations.inputDecoration(
                                  hintext: 'Nombre y Apellido',
                                  labeltext: 'Nombre Completo',
                                  icono:
                                      const Icon(Icons.person_2_outlined),
                                ),
                              ),

                              const SizedBox(height: 30),
                              FormBuilderTextField(
                                name: 'cedula',
                                keyboardType: TextInputType.number,
                                decoration: InputDecorations.inputDecoration(
                                  hintext: '000-0000000-0',
                                  labeltext: 'Cedula de identidad',
                                  icono:
                                      const Icon(Icons.perm_identity_rounded),
                                ),
                                validator: (value) {
                                  String pattern =
                                      r'^\d{3}-\d{7}-\d{1}$';
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
                                name: 'email',
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecorations.inputDecoration(
                                  hintext: 'ejemplo20##@gmail.com',
                                  labeltext: 'Correo Electronico',
                                  icono: const Icon(
                                      Icons.alternate_email_rounded),
                                ),
                                validator: (value) {
                                  String pattern =
                                      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$';
                                  RegExp regExp = RegExp(pattern);
                                  return regExp.hasMatch(value ?? '')
                                      ? null
                                      : 'Ingrese un correo electrónico válido';
                                },
                              ),
                              const SizedBox(height: 30),
                              FormBuilderTextField(
                                name: 'nombreUsuario',
                                keyboardType: TextInputType.name,
                                decoration: InputDecorations.inputDecoration(
                                  hintext: 'MetroSantDom123',
                                  labeltext: 'Usuario',
                                  icono:
                                      const Icon(Icons.person_pin_circle),
                                ),
                              ),
                              const SizedBox(height: 50),
                              
                              // fila de botones 
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center, // Para separar los botones de manera uniforme
                                children: [
                                  // boton de Filtrar
                                  ElevatedButton(
                                    onPressed: () {}, 
                                    
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromRGBO(1, 135, 76, 1), //  se usa para definir el color de fondo del botón.
                                      foregroundColor: const Color.fromARGB(255, 255, 255, 255), // se usa para definir el color del texto y los iconos dentro del botón.
                                      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
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
                                      'Filtrar',
                                      style: TextStyle(
                                        fontSize: 20, 
                                        fontWeight: FontWeight.bold
                                      )
                                    ),
                                  ),
                                  
                                  // boton de Guardar
                                  ElevatedButton(
                                    onPressed: () {
                                      // Navigator.push(
                                      //   context, 
                                      //   MaterialPageRoute(
                                      //     builder: (context) => const EmpleadoScreens(),
                                      //   )
                                      // );
                                    }, 
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromRGBO(1, 135, 76, 1), // Color de fondo del primer botón
                                      foregroundColor: const Color.fromARGB(255, 254, 255, 255), // Color del texto
                                      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(0),
                                          topRight: Radius.circular(0),
                                          bottomLeft: Radius.circular(0),
                                          bottomRight: Radius.circular(0),
                                        ),
                                      ),
                                    ),
                                    child: const Text(
                                      'Guardar',
                                      style: TextStyle(
                                        fontSize: 20, 
                                        fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ),

                                  // boton de Editar
                                  ElevatedButton(
                                    onPressed: () {}, 
                                    
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromRGBO(1, 135, 76, 1), //  se usa para definir el color de fondo del botón.
                                      foregroundColor: const Color.fromARGB(255, 255, 255, 255), // se usa para definir el color del texto y los iconos dentro del botón.
                                      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(0), //Define el radio para la esquina superior izquierda.
                                          topRight: Radius.circular(0), //Define el radio para la esquina superior derecha.
                                          bottomLeft: Radius.circular(0), //Define el radio para la esquina inferior izquierda.
                                          bottomRight: Radius.circular(0), //Define el radio para la esquina inferior derecha.
                                        ),
                                      ),
                                    ),

                                    child: const Text(
                                      'Editar',
                                      style: TextStyle(
                                        fontSize: 20, 
                                        fontWeight: FontWeight.bold
                                      )
                                    ),
                                  ),

                                  // boton de Borrar
                                  ElevatedButton(
                                    onPressed: () {}, 
                                    
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromRGBO(1, 135, 76, 1), //  se usa para definir el color de fondo del botón.
                                      foregroundColor: const Color.fromARGB(255, 255, 255, 255), // se usa para definir el color del texto y los iconos dentro del botón.
                                      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(0), //Define el radio para la esquina superior izquierda.
                                          topRight: Radius.circular(50), //Define el radio para la esquina superior derecha.
                                          bottomLeft: Radius.circular(0), //Define el radio para la esquina inferior izquierda.
                                          bottomRight: Radius.circular(50), //Define el radio para la esquina inferior derecha.
                                        ),
                                      ),
                                    ),

                                    child: const Text(
                                      'Borrar',
                                      style: TextStyle(
                                        fontSize: 20, 
                                        fontWeight: FontWeight.bold
                                      )
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      FutureBuilder<List<UsuariosEmpl>>(
                        future: _usuarios,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting){
                            return const Center(child: CircularProgressIndicator());
                          }else if (snapshot.hasError){
                            return Center(child: Text('Error al cargar los datos: ${snapshot.error}'));
                          }else {
                            final usuarios = snapshot.data ?? [];

                            return DataTable(
                              columns: const [
                                DataColumn(label: Text('ID')),
                                DataColumn(label: Text('Cedula')),
                                DataColumn(label: Text('Nombre Completo')),
                                DataColumn(label: Text('Usuario')),
                                DataColumn(label: Text('Correo Electronico')),
                                DataColumn(label: Text('Rol'))
                              ], 
                              rows: usuarios.map((usuario){
                                return DataRow(
                                  cells: [
                                    DataCell(Text(usuario.idUsuarioEmpl)),
                                    DataCell(Text(usuario.cedlEmpleado)),
                                    DataCell(Text(usuario.nombreEmpleado)),
                                    DataCell(Text(usuario.nombreUsuarioEmpl)),
                                    DataCell(Text(usuario.emailEmpl)),
                                    DataCell(Text(usuario.rol)),
                                    DataCell(
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.edit), 
                                            onPressed: (){
                                              // _showEditDialog(usuario);
                                            },
                                          ),

                                          IconButton(
                                            onPressed: () {
                                              // _showDeleteDialog(usuario);
                                            }, 
                                            icon: const Icon(Icons.delete)
                                          )
                                        ],
                                      )
                                    )
                                  ]
                                );
                              }).toList(),
                            );
                          }
                        }
                      ),
                      FloatingActionButton(
                        onPressed: () {
                          // _showCreateDialog();
                        },
                        child: const Icon(Icons.add),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // // Mostrar diálogo para crear un nuevo usuario
  // void _showCreateDialog() {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       // Formulario para crear usuario
  //       return AlertDialog(
  //         title: const Text('Crear Usuario'),
  //         content: FormBuilder(
  //           // Similar a tu otro formulario
  //         ),
  //         actions: [
  //           TextButton(
  //             child: const Text('Guardar'),
  //             onPressed: () {
  //               // Llamar al método de creación y refrescar la lista
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  // // Mostrar diálogo para editar un usuario
  // void _showEditDialog(UsuariosEmpl usuario) {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       // Formulario para editar usuario
  //       return AlertDialog(
  //         title: Text('Editar Usuario'),
  //         content: FormBuilder(
  //           // Similar a tu otro formulario
  //         ),
  //         actions: [
  //           TextButton(
  //             child: const Text('Actualizar'),
  //             onPressed: () {
  //               // Llamar al método de actualización y refrescar la lista
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
}
