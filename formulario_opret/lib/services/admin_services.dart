// import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
// import 'package:formulario_opret/models/login_Admin.dart';
import 'package:formulario_opret/models/userAdministrador.dart';
import 'package:http/http.dart' as http;

class ApiServiceAdmin {
  final String baseUrl;

  ApiServiceAdmin(this.baseUrl);

  // POST: api/UsuariosAdmins
  Future<http.Response> createUsuarioAdmin(UsuarioAdministrador admin) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/UsuariosAdmins'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: jsonEncode(admin.toJson()), // Imprimir el JSON que se está enviando
      ).timeout(const Duration(seconds: 20));

      /*verificando response.statusCode == 201, que es el 
      código de estado HTTP para cuando un recurso es creado 
      (usualmente en respuestas a solicitudes POST).*/
      
      if (response.statusCode == 201) {
        // Successfully created
        print('Usuario Administrador created successfully');
      } else {
        // Handle error
        print('Failed to create Usuario Administrador: ${response.statusCode}');
        print('Response body: ${response.body}');
      }

      return response;
    } catch (e) {
      // Handle exception
      print('Error occurred: $e');
      rethrow;
    }
  }

  // GET: api/UsuariosAdmins
  Future<List<UsuarioAdministrador>> getUsuarioAdmins(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/UsuariosAdmins'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Añadir el JWT en los headers
        },
      ).timeout(const Duration(seconds: 20));

      // Verificar si la solicitud fue exitosa
      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        return body.map((json) => UsuarioAdministrador.fromJson(json)).toList();
      } else {
        throw Exception('Error al cargar el Usuario Administrador: ${response.statusCode}');
      }
    } catch (e) {
      // Manejar la excepción
      print('Error occurred: $e');
      rethrow;
    }
  }


  // GET: api/UsuariosAdmins/5
  Future<UsuarioAdministrador> getUsuarioAdmin(String id) async {
    try{ 
      final httpClient = HttpClient()
      ..connectionTimeout = const Duration(seconds: 5)
      ..idleTimeout = const Duration(seconds: 20);

      final request = await httpClient.getUrl(Uri.parse('$baseUrl/api/UsuariosAdmins/$id'));

      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();
      
      if (response.statusCode == 200) {
        print('Usuario Administrador retrieved successfully');
        return UsuarioAdministrador.fromJson(jsonDecode(responseBody));
      } else {
        print('Failed to retrieve Usuarios Administradores: ${response.statusCode}');
        print('Response body: $responseBody');
        throw Exception('Failed to load Usuario Administrador');
      }

    } catch (e) {
      // Handle exception
      print('Error occurred: $e');
      rethrow;
    }
  }

  // PUT: api/UsuariosAdmins/{id}
  Future<http.Response> updateUsuarioAdmin(String adminId, UsuarioAdministrador admin) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/api/UsuariosAdmins/$adminId'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: jsonEncode(admin.toJson()),
      ).timeout(const Duration(seconds: 20));

      if(response.statusCode == 204) {
        print('Usuario Administrador actualizada con éxito');
      }else{
        print('Error al actualizar el Usuario Administrador: ${response.statusCode}');
        print('Cuerpo de la respuesta: ${response.body}');
      }

      return response;

    } catch (e) {
      // Manejo de excepciones
      print('Error occurred: $e');
      rethrow;
    }
  }

  //-------------------------------------Login del Administrador------------------------------------------
  // Future<String?> login(LoginAdmin loginAdmin) async {
  //   try {
  //     final response = await http.post(
  //       Uri.parse('$baseUrl/api/UsuariosAdmins/login'),
  //       headers: {'Content-Type': 'application/json'},
  //       body: jsonEncode(loginAdmin.toJson()),
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
}

/*
¿Cuándo deberías usar request.headers.set(...)?
Solicitudes POST, PUT, PATCH, etc.: Necesitarás especificar el 
  Content-Type si estás enviando datos en el cuerpo de la 
  solicitud (por ejemplo, JSON).

Solicitudes GET: No es necesario a menos que estés configurando 
  encabezados personalizados (como un token de autenticación) o 
  si el servidor requiere ciertos encabezados para procesar la 
  solicitud correctamente.

Si estuvieras enviando algún encabezado adicional en una 
solicitud GET, podrías agregarlo así:

Ejemplo:
  request.headers.set('Authorization', 'Bearer <your_token_here>');
*/

// Future<List<UsuarioAdministrador>> getUsuarioAdmins() async {
  //   try {
  //     final response = await http.get(Uri.parse('$baseUrl/api/UsuariosAdmins')).timeout(const Duration(seconds: 20));

  //      /*Como estás realizando una solicitud GET para obtener 
  //      datos, el código de estado que esperas debería ser 200, 
  //      que indica que la solicitud fue exitosa y los datos 
  //      fueron recuperados correctamente.*/

  //     if(response.statusCode == 200) {
  //       List<dynamic> body = jsonDecode(response.body);
  //       return body.map((json) => UsuarioAdministrador.fromJson(json)).toList();
  //     } else {
  //       throw Exception('Error al cargar el Usuario Administrador: ${response.statusCode}');
  //     }
      
  //   } catch (e) {
  //     // Handle exception
  //     print('Error occurred: $e');
  //     rethrow;
  //   }
  // }