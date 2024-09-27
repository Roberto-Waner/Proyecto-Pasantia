import 'dart:typed_data';

class UsuariosEmpl {
  String idUsuarioEmpl;
  String cedlEmpleado;
  String nombreEmpleado;
  String nombreUsuarioEmpl;
  String emailEmpl;
  String passwordsEmpl;
  String resptPasswordsEmpl;
  Uint8List? fotoEmpl;
  String rol;

  UsuariosEmpl({
    required this.idUsuarioEmpl,
    required this.cedlEmpleado,
    required this.nombreEmpleado,
    required this.nombreUsuarioEmpl,
    required this.emailEmpl,
    required this.passwordsEmpl,
    required this.resptPasswordsEmpl,
    this.fotoEmpl,
    required this.rol
  });

  factory UsuariosEmpl.fromJson(Map<String, dynamic> json) {
    return UsuariosEmpl(
      idUsuarioEmpl: json['idUsuarioEmpl'],
      cedlEmpleado: json['cedlEmpleado'],
      nombreEmpleado: json['nombreEmpleado'],
      nombreUsuarioEmpl: json['nombreUsuarioEmpl'],
      emailEmpl: json['emailEmpl'],
      passwordsEmpl: json['passwordsEmpl'],
      resptPasswordsEmpl: json['resptPasswordsEmpl'],
      rol: json['rol'],
      fotoEmpl: json['fotoEmpl'] != null ? Uint8List.fromList(List<int>.from(json['fotoEmpl'])) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idUsuarioEmpl': idUsuarioEmpl,
      'cedlEmpleado': cedlEmpleado,
      'nombreEmpleado': nombreEmpleado,
      'nombreUsuarioEmpl': nombreUsuarioEmpl,
      'emailEmpl': emailEmpl,
      'passwordsEmpl': passwordsEmpl,
      'resptPasswordsEmpl': resptPasswordsEmpl,
      'rol': rol,
      'fotoEmpl': fotoEmpl,
    };
  }
}