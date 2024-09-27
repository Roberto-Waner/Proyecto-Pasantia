import 'dart:convert';
import 'dart:io';
// import 'package:formulario_opret/models/login_Empl.dart';
import 'package:formulario_opret/models/userEmpleado.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String baseUrl;

  ApiService(this.baseUrl);

  // POST: api/UsuariosEmpls
  Future<http.Response> createUsuarioEmpl(UsuariosEmpl usuarioEmpl) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/UsuariosEmpls'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: jsonEncode(usuarioEmpl.toJson()),
      ).timeout(const Duration(seconds: 20)); // Timeout de 10 segundos

      if (response.statusCode == 201) {
        print('Usuario Empleado creado con éxito');
      } else {
        print('Error al crear Usuario Empleado: ${response.statusCode}');
        print('Cuerpo de la respuesta: ${response.body}');
      }

      return response;
    } catch (e) {
      // Manejo de excepciones generales, como problemas de red
      print('Error al crear Usuario Empleado: $e');
      rethrow; // Lanza de nuevo la excepción si se desea manejar más arriba
    }
  }

  // GET: api/UsuariosEmpls
  Future<List<UsuariosEmpl>> getUsuariosEmpls() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/UsuariosEmpls'))
        .timeout(const Duration(seconds: 20));

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        return body.map((json) => UsuariosEmpl.fromJson(json)).toList();
      } else {
        throw Exception('Error al cargar usuarios: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al cargar usuarios: $e');
      rethrow;
    }
  }

  Future<UsuariosEmpl?> getUsuarioEmplByToken() async {
    try {
      // Obtener el token almacenado
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        throw Exception('Token no encontrado');
      }

      // Realizar solicitud GET con el token
      final response = await http.get(
        Uri.parse('$baseUrl/api/UsuariosEmpls/getUser'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 20));

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        return UsuariosEmpl.fromJson(jsonResponse);
      } else {
        throw Exception('Error al cargar el usuario: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al cargar el usuario: $e');
      rethrow;
    }
  }

  // PUT: api/UsuariosEmpls/{id}
  Future<http.Response> updateUsuarioEmpl(String id, UsuariosEmpl usuarioEmpl) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/api/UsuariosEmpls/$id'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: jsonEncode(usuarioEmpl.toJson()),
      ).timeout(const Duration(seconds: 20));

      if (response.statusCode == 204) {
        print('Usuario Empleado actualizado con éxito');
      } else {
        print('Error al actualizar usuario: ${response.statusCode}');
        print('Cuerpo de la respuesta: ${response.body}');
      }

      return response;
    } catch (e) {
      print('Error al actualizar Usuario Empleado: $e');
      rethrow;
    }
  }

  // DELETE: api/UsuariosEmpls/{id}
  Future<http.Response> deleteUsuarioEmpl(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/api/UsuariosEmpls/$id'),
      ).timeout(const Duration(seconds: 20));

      if (response.statusCode == 204) {
        print('Usuario Empleado eliminado con éxito');
      } else {
        print('Error al eliminar usuario: ${response.statusCode}');
        print('Cuerpo de la respuesta: ${response.body}');
      }

      return response;
    } catch (e) {
      print('Error al eliminar Usuario Empleado: $e');
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