
class LoginEmpleado {
  String userName;
  String password;

  LoginEmpleado({required this.userName, required this.password});

  factory LoginEmpleado.fromJson(Map<String, dynamic> json){
    return LoginEmpleado(
      userName: json['nombreUsuarioEmpl'],
      password: json['passwordsEmpl'],
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'nombreUsuarioEmpl': userName,
      'passwordsEmpl': password,
    };
  }
}