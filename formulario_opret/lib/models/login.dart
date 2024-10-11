
class Login {
  String userName;
  String password;

  Login({required this.userName, required this.password});

  factory Login.fromJson(Map<String, dynamic> json){
    return Login(
      userName: json['loginUsuario'],
      password: json['loginPasswords'],
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'loginUsuario': userName,
      'loginPasswords': password,
    };
  }
}