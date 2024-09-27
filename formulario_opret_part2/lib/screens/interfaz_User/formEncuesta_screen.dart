// import 'package:flutter/material.dart';
// import 'package:flutter_form_builder/flutter_form_builder.dart';
// import 'package:form_builder_validators/form_builder_validators.dart';
// // import 'package:formulario_opret/models/formulario_Registro.dart';
// import 'package:formulario_opret/models/userEmpleado.dart';
// import 'package:formulario_opret/screens/interfaz_User/navbarUser/navbar_Empl.dart';
// // import 'package:formulario_opret/services/form_Registro_services.dart';
// import 'package:formulario_opret/services/login_services_token.dart';
// import 'package:formulario_opret/services/user_services.dart';
// import 'package:formulario_opret/widgets/input_decoration.dart';

// class FormencuestaScreen extends StatefulWidget {
//   const FormencuestaScreen({super.key});

//   @override
//   State<FormencuestaScreen> createState() => _FormencuestaScreenState();
// }

// class _FormencuestaScreenState extends State<FormencuestaScreen> {
//   // final ApiServiceToken _apiServiceToken = ApiServiceToken('https://10.0.2.2:7002');
//   final ApiService _apiService = ApiService('https://10.0.2.2:7002');
//   // final ApiServiceFormRegistro _apiServiceFormRegistro = ApiServiceFormRegistro('https://10.0.2.2:7002');
//   late Future<UsuariosEmpl?> _usuarios;
//   // late Future<List<FormularioRegistro>> _formRegistro;
//   final _formKey = GlobalKey<FormBuilderState>();
//   String userNameEmpl = 'data';
//   String emailEmpl = 'data';

//   @override
//   void initState(){
//     super.initState();
//     _usuarios = _apiService.getUsuarioEmplByToken(); // Cargar los usuarios al iniciar
//   }

//   //  // Llamada para refrescar datos
//   // void _refreshFormRegistros() {
//   //   setState(() {
//   //     _formRegistro = _apiServiceFormRegistro.getFormRegistro();
//   //   });
//   // }

//   // Future<void> _loadUserData() async {
//   //   if (_apiServiceToken.currentUser == null) {
//   //     await _apiServiceToken.getCurrentUser(_apiServiceToken.currentUser?.idUsuarioEmpl ?? '');
//   //   }
//   // }
  
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       drawer: NavbarEmpl(userNameEmpl: userNameEmpl, emailEmpl: emailEmpl),
//       appBar: AppBar(title: const Text('Formulario')),
//       body: FutureBuilder(
//         future: _usuarios,
//         builder: (context, snapshot) {
//           if(snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return  Center(child: Text('Error al cargar los datos del usuario: ${snapshot.error}'));
//           } else {        
//             UsuariosEmpl? user = snapshot.data;

//             // Asegúrate de que user no es nulo
//             if (user == null) {
//               return const Center(child: Text('No se encontraron datos del usuario.'));
//             }

//             return SingleChildScrollView(
//               child: FormBuilder(
//                 key: _formKey,
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     FormBuilderTextField(
//                       name: 'noEncuesta',
//                       decoration: InputDecorations.inputDecoration(
//                         hintext: '#',
//                         hintFrontSize: 25.0,
//                         labeltext: 'No. de Encuesta',
//                         labelFrontSize: 30.5,
//                         icono: const Icon(Icons.numbers, size: 30.0)
//                       ),
//                       style: const TextStyle(fontSize: 23.5), // Cambiar tamaño de letra del texto filtrado
//                       validator: FormBuilderValidators.required(),
//                     ),

//                     FormBuilderTextField(
//                       name: 'id',
//                       initialValue: user.idUsuarioEmpl,
//                       decoration: InputDecorations.inputDecoration(
//                         labeltext: 'Asignar ID',
//                         labelFrontSize: 25.5, // Tamaño de letra personalizado
//                         hintext: 'USER-000000000',
//                         hintFrontSize: 20.0,
//                         icono: const Icon(Icons.perm_identity_outlined,size: 30.0),
//                       ),
//                       // validator: FormBuilderValidators.required(),
//                       validator: (value) {
//                         if (value == null || value.isEmpty){
//                           return 'Por favor ingrese su ID-Empleado';
//                         }

//                         if (!RegExp(r'^USER-\d{4,10}$').hasMatch(value)){
//                           return 'Por favor ingrese un ID-Empleado valido';
//                         }

//                         return null;
//                       },
//                     ),

//                     FormBuilderTextField(
//                       name: 'cedula',
//                       initialValue: user.cedlEmpleado,
//                       decoration: InputDecorations.inputDecoration(
//                         labeltext: 'Cedula',
//                         labelFrontSize: 25.5,
//                         hintext: '000-0000000-0',
//                         hintFrontSize: 20.0, 
//                         icono: const Icon(Icons.person_pin_circle_outlined, size: 30.0),
//                       ),
//                       // validator: FormBuilderValidators.required(),
//                       validator: FormBuilderValidators.compose([ //Combina varios validadores. En este caso, se utiliza el validador requerido y una función personalizada para la expresión regular.
//                         FormBuilderValidators.required(errorText: 'Debe de ingresar la cedula'), //Valida que el campo no esté vacío y muestra el mensaje 'El correo es obligatorio' si no se ingresa ningún valor.
//                         (value) {
//                           // Expresión regular para validar la cedula
//                           String pattern = r'^\d{3}-\d{7}-\d{1}$';
//                           RegExp regExp = RegExp(pattern);
//                           // if(value == null || value.isEmpty){
//                           //   return 'Por favor ingrese su cédula';
//                           // }

//                           if(!regExp.hasMatch(value ?? '')){
//                             return 'Formato de cédula incorrecto';
//                           }
//                           return null;
//                         },
//                       ]),                    
//                     ),

//                     FormBuilderDateTimePicker(
//                       name: 'fechaNacimiento',
                      
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           }
//         }
//       )
//     );
//   }
// }