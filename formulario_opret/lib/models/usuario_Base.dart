// import 'dart:typed_data';

// // Clase base que contiene las propiedades comunes
// class UsuarioBase {
//   String idUsuario;
//   String nombreUsuario;
//   String email;
//   String passwords;
//   String resptPasswords;
//   Uint8List? foto;
//   String rol;

//   UsuarioBase({
//     required this.idUsuario,
//     required this.nombreUsuario,
//     required this.email,
//     required this.passwords,
//     required this.resptPasswords,
//     this.foto,
//     required this.rol,
//   });

//   Map<String, dynamic> toJson() {
//     return {
//       'idUsuario': idUsuario,
//       'nombreUsuario': nombreUsuario,
//       'email': email,
//       'passwords': passwords,
//       'resptPasswords': resptPasswords,
//       'foto': foto,
//       'rol': rol,
//     };
//   }
// }

// // Clase para UsuariosEmpl que hereda de UsuarioBase
// class UsuariosEmpl extends UsuarioBase {
//   String cedlEmpleado;
//   String nombreEmpleado;

//   UsuariosEmpl({
//     required String idUsuarioEmpl,
//     required this.cedlEmpleado,
//     required this.nombreEmpleado,
//     required String nombreUsuarioEmpl,
//     required String emailEmpl,
//     required String passwordsEmpl,
//     required String resptPasswordsEmpl,
//     Uint8List? fotoEmpl,
//     required String rol,
//   }) : super(
//           idUsuario: idUsuarioEmpl,
//           nombreUsuario: nombreUsuarioEmpl,
//           email: emailEmpl,
//           passwords: passwordsEmpl,
//           resptPasswords: resptPasswordsEmpl,
//           foto: fotoEmpl,
//           rol: rol,
//         );

//   factory UsuariosEmpl.fromJson(Map<String, dynamic> json) {
//     return UsuariosEmpl(
//       idUsuarioEmpl: json['idUsuarioEmpl'],
//       cedlEmpleado: json['cedlEmpleado'],
//       nombreEmpleado: json['nombreEmpleado'],
//       nombreUsuarioEmpl: json['nombreUsuarioEmpl'],
//       emailEmpl: json['emailEmpl'],
//       passwordsEmpl: json['passwordsEmpl'],
//       resptPasswordsEmpl: json['resptPasswordsEmpl'],
//       rol: json['rol'],
//       fotoEmpl: json['fotoEmpl'] != null ? Uint8List.fromList(List<int>.from(json['fotoEmpl'])) : null,
//     );
//   }

//   @override
//   Map<String, dynamic> toJson() {
//     final data = super.toJson();
//     data.addAll({
//       'cedlEmpleado': cedlEmpleado,
//       'nombreEmpleado': nombreEmpleado,
//     });
//     return data;
//   }
// }

// // Clase para UsuarioAministrador que hereda de UsuarioBase
// class UsuarioAdministrador extends UsuarioBase {
//   String cedlAdministrador;
//   String nombreAdministrador;

//   UsuarioAdministrador({
//     required String idUsuarioAdmin,
//     required this.cedlAdministrador,
//     required this.nombreAdministrador,
//     required String nombreUsuarioAdmin,
//     required String emailAdmin,
//     required String passwordsAdmin,
//     required String resptPasswordsAdmin,
//     Uint8List? fotoAdmin,
//     required String rol,
//   }) : super(
//           idUsuario: idUsuarioAdmin,
//           nombreUsuario: nombreUsuarioAdmin,
//           email: emailAdmin,
//           passwords: passwordsAdmin,
//           resptPasswords: resptPasswordsAdmin,
//           foto: fotoAdmin,
//           rol: rol,
//         );

//   factory UsuarioAdministrador.fromJson(Map<String, dynamic> json) {
//     return UsuarioAdministrador(
//       idUsuarioAdmin: json['idUsuarioAdmin'],
//       cedlAdministrador: json['cedlAdministrador'],
//       nombreAdministrador: json['nombreAdministrador'],
//       nombreUsuarioAdmin: json['nombreUsuarioAdmin'],
//       emailAdmin: json['emailAdmin'],
//       passwordsAdmin: json['passwordsAdmin'],
//       resptPasswordsAdmin: json['resptPasswordsAdmin'],
//       rol: json['rol'],
//       fotoAdmin: json['fotoAdmin'] != null ? Uint8List.fromList(List<int>.from(json['fotoAdmin'])) : null,
//     );
//   }

//   @override
//   Map<String, dynamic> toJson() {
//     final data = super.toJson();
//     data.addAll({
//       'cedlAdministrador': cedlAdministrador,
//       'nombreAdministrador': nombreAdministrador,
//     });
//     return data;
//   }
// }
