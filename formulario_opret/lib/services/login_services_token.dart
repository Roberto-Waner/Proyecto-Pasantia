import 'dart:convert';
import 'dart:io';
import 'package:formulario_opret/models/login_Admin.dart';
import 'package:formulario_opret/models/login_Empl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiServiceToken {
  final String baseUrl;

  ApiServiceToken(this.baseUrl);

  //-------------------------------------Login del Empleado------------------------------------------
  Future<String?> loginUser(LoginEmpleado loginEmpl) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/UsuariosEmpls/login'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: jsonEncode(loginEmpl.toJson()),
      ).timeout(const Duration(seconds: 20));

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);

        String token = jsonResponse['result'];
        
        // Guardar el token en SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);

        return token; // Devuelve el JWT
      } else {
        print('Error al iniciar sesión: ${response.statusCode}');
        print('Cuerpo de la respuesta: ${response.body}');
        return null;
      }
    } catch (e) {
      // Manejo de excepciones
      print('Error al iniciar sesión: $e');
      rethrow;
    }
  }

  //-------------------------------------Login del Administrador------------------------------------------
  Future<String?> loginAdministrador (LoginAdmin loginAdmin) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/UsuariosAdmins/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(loginAdmin.toJson()),
      ).timeout(const Duration(seconds: 20));

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        return jsonResponse['result']; // Retorna el JWT
      } else {
        print('Login failed: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      // Manejo de excepciones
      print('Error occurred: $e');
      rethrow;
    }
  }
}

//-------------------------------------Obtener datos del usuario------------------------------------------
  // Future<void> getCurrentUser(String userId) async {
  //   if (token == null) return;

  //   try{
  //     final response = await http.get(
  //       Uri.parse('$baseUrl/api/UsuariosEmpls/$userId'),
  //       headers: {
  //         'Content-Type': 'application/json', 
  //         'Authorization': 'Bearer $token'
  //       },
  //     ).timeout(const Duration(seconds: 20));

  //     if (response.statusCode == 200) {
  //       var jsonResponse = jsonDecode(response.body);
  //       currentUser = UsuariosEmpl.fromJson(jsonResponse);
  //     } else {
  //       print('Failed to get user data: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print('Error occurred: $e');
  //     rethrow;
  //   }
  // }

  // Future<String?> loginUser(LoginEmpleado loginEmpl) async {
  //   try {
  //     final response = await http.post(
  //       Uri.parse('$baseUrl/api/UsuariosEmpls/login'),
  //       headers: {'Content-Type': 'application/json'},
  //       body: jsonEncode(loginEmpl.toJson()),
  //     ).timeout(const Duration(seconds: 20));

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