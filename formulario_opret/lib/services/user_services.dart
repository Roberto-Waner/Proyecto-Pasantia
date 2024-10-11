import 'dart:convert';
import 'dart:io';
import 'package:formulario_opret/models/usuarios.dart';
import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String baseUrl;

  ApiService(this.baseUrl);

  // POST: api/Usuarios
  Future<http.Response> createUsuarios(Usuarios user) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/Usuarios'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: jsonEncode(user.toJson()),
      ).timeout(const Duration(seconds: 20)); // Timeout de 10 segundos

      if (response.statusCode == 201) {
        print('Usuario creado con éxito');
      } else {
        print('Error al crear el Usuario: ${response.statusCode}');
        print('Cuerpo de la respuesta: ${response.body}');
      }

      return response;
    } catch (e) {
      // Manejo de excepciones generales, como problemas de red
      print('Error al crear Usuario: $e');
      rethrow; // Lanza de nuevo la excepción si se desea manejar más arriba
    }
  }

  // GET: api/Usuarios
  Future<List<Usuarios>> getUsuarios() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/Usuarios'))
        .timeout(const Duration(seconds: 20));

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        return body.map((json) => Usuarios.fromJson(json)).toList();
      } else {
        throw Exception('Error al cargar usuarios: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al cargar usuarios: $e');
      rethrow;
    }
  }

  // Future<UsuariosEmpl?> getUsuarioEmplByToken() async {
  //   try {
  //     // Obtener el token almacenado
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     String? token = prefs.getString('token');

  //     if (token == null) {
  //       throw Exception('Token no encontrado');
  //     }

  //     // Realizar solicitud GET con el token
  //     final response = await http.get(
  //       Uri.parse('$baseUrl/api/UsuariosEmpls/getUser'),
  //       headers: {
  //         HttpHeaders.contentTypeHeader: 'application/json',
  //         HttpHeaders.authorizationHeader: 'Bearer $token',
  //       },
  //     ).timeout(const Duration(seconds: 20));

  //     if (response.statusCode == 200) {
  //       var jsonResponse = jsonDecode(response.body);
  //       return UsuariosEmpl.fromJson(jsonResponse);
  //     } else {
  //       throw Exception('Error al cargar el usuario: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print('Error al cargar el usuario: $e');
  //     rethrow;
  //   }
  // }

  // PUT: api/Usuarios/{id}
  Future<http.Response> updateUsuario(String id, Usuarios user) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/api/Usuarios/$id'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: jsonEncode(user.toJson()),
      ).timeout(const Duration(seconds: 20));

      if (response.statusCode == 204) {
        print('Usuario actualizado con éxito');
      } else {
        print('Error al actualizar usuario: ${response.statusCode}');
        print('Cuerpo de la respuesta: ${response.body}');
      }

      return response;
    } catch (e) {
      print('Error al actualizar Usuario: $e');
      rethrow;
    }
  }

  // DELETE: api/Usuarios/{id}
  Future<http.Response> deleteUsuario(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/api/Usuarios/$id'),
      ).timeout(const Duration(seconds: 20));

      if (response.statusCode == 204) {
        print('Usuario eliminado con éxito');
      } else {
        print('Error al eliminar usuario: ${response.statusCode}');
        print('Cuerpo de la respuesta: ${response.body}');
      }

      return response;
    } catch (e) {
      print('Error al eliminar Usuario: $e');
      rethrow;
    }
  }
}
//-------------------------------------Login del Administrador------------------------------------------
  // Future<String?> loginUser(LoginEmpleado loginEmpl) async {
  //   try {
  //     final response = await http.post(
  //       Uri.parse('$baseUrl/api/UsuariosEmpls/login'),
  //       headers: {'Content-Type': 'application/json'},
  //       body: jsonEncode(loginEmpl.toJson()),
  //     );

  //     if (response.statusCode == 200) {
  //       var jsonResponse = jsonDecode(response.body);
  //       return jsonResponse['result']; // Retorna el JWT
  //     } else {
  //       print('Login failed: ${response.statusCode}');
  //       return null;
  //     }
  //   } catch (e) {
  //     // Manejo de excepciones
  //     print('Error occurred: $e');
  //     rethrow;
  //   }
  // }

// GET: api/UsuariosEmpls/{token}
  // Future<List<UsuariosEmpl>> getUsuariosEmpl(String token) async {
  //   try {
  //     final response = await http.get(
  //       Uri.parse('$baseUrl/api/UsuariosEmpls'),
  //       headers: {
  //         HttpHeaders.contentTypeHeader: 'application/json',
  //         HttpHeaders.authorizationHeader: 'Bearer $token', // JWT Token
  //       },
  //     ).timeout(const Duration(seconds: 20));

  //     if (response.statusCode == 200) {
  //       List<dynamic> body = jsonDecode(response.body);
  //       return body.map((json) => UsuariosEmpl.fromJson(json)).toList();
  //     } else {
  //       throw Exception('Error al cargar usuarios: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print('Error al cargar usuarios: $e');
  //     rethrow;
  //   }
  // }