class LoginAdmin {
  String userName;
  String password;

  LoginAdmin({
    required this.userName,
    required this.password,
  });

  factory LoginAdmin.fromJson(Map<String, dynamic> json) {
    return LoginAdmin(
      userName: json['nombreUsuarioAdmin'],
      password: json['passwordsAdmin'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombreUsuarioAdmin': userName,
      'passwordsAdmin': password,
    };
  }
}