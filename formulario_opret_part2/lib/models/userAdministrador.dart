import 'dart:typed_data';

class UsuarioAdministrador {
  String idUsuarioAdmin;
  String cedlAdministrador;
  String nombreAdministrador;
  String nombreUsuarioAdmin;
  String emailAdmin;
  String passwordsAdmin;
  String resptPasswordsAdmin;
  Uint8List? fotoAdmin;
  String? rol;

  UsuarioAdministrador({
    required this.idUsuarioAdmin,
    required this.cedlAdministrador,
    required this.nombreAdministrador,
    required this.nombreUsuarioAdmin,
    required this.emailAdmin,
    required this.passwordsAdmin,
    required this.resptPasswordsAdmin,
    this.fotoAdmin,
    this.rol
  });

  factory UsuarioAdministrador.fromJson(Map<String, dynamic> json) {
    return UsuarioAdministrador(
      idUsuarioAdmin: json['idUsuarioAdmin'],
      cedlAdministrador: json['cedlAdministrador'],
      nombreAdministrador: json['nombreAdministrador'],
      nombreUsuarioAdmin: json['nombreUsuarioAdmin'],
      emailAdmin: json['emailAdmin'],
      passwordsAdmin: json['passwordsAdmin'],
      resptPasswordsAdmin: json['resptPasswordsAdmin'],
      rol: json['rol'],
      fotoAdmin: json['fotoAdmin'] != null ? Uint8List.fromList(List<int>.from(json['fotoEmpl'])) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idUsuarioAdmin': idUsuarioAdmin,
      'cedlAdministrador': cedlAdministrador,
      'nombreAdministrador': nombreAdministrador,
      'nombreUsuarioAdmin': nombreUsuarioAdmin,
      'emailAdmin': emailAdmin,
      'passwordsAdmin': passwordsAdmin,
      'resptPasswordsAdmin': resptPasswordsAdmin,
      'rol': rol,
      'fotoAdmin': fotoAdmin,
    };
  }
}