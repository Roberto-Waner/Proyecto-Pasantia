import 'dart:convert';
import 'dart:io';
import 'package:formulario_opret/models/formulario_Registro.dart';
import 'package:http/http.dart' as http;

class ApiServiceFormRegistro {
  final String baseUrl;

  ApiServiceFormRegistro(this.baseUrl);

  // GET: api/RegistroForms
  Future<List<FormularioRegistro>> getFormRegistro() async {
    try{
      final response = await http.get(Uri.parse('$baseUrl/api/RegistroForms')).timeout(const Duration(seconds: 20));

      if(response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        return body.map((json) => FormularioRegistro.fromJson(json)).toList();
      } else {
        throw Exception('Error al cargar el Registro de los formularios: ${response.statusCode}');
      }

    } catch(e){
      print('Error al cargar los Registro: $e');
      rethrow;
    }
  }

  // POST: api/RegistroForms
  Future<http.Response> postFormRegistro(FormularioRegistro formReg) async {
    try{
      final response = await http.post(
        Uri.parse('$baseUrl/api/RegistroForms'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: jsonEncode(formReg.toJson())
      ).timeout(const Duration(seconds: 20));

      if(response.statusCode == 201){
        print('Registro creada con éxito');
      }else {
        print('Error al crear los registro: ${response.statusCode}');
        print('Cuerpo de la respuesta: ${response.body}');
      }

      return response;
    } catch(e){
      print('Error al cargar los Registro: $e');
      rethrow;
    }
  }

  // PUT: api/RegistroForms/5
  Future<http.Response> putFormRegistro(String noEncuesta, FormularioRegistro formReg) async {
    try{
      final response = await http.put(
        Uri.parse('$baseUrl/api/RegistroForms/$noEncuesta'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: jsonEncode(formReg.toJson())
      ).timeout(const Duration(seconds: 20));

      if(response.statusCode == 204){
        print('Registro actualizado con éxito');
      }else {
        print('Error al actualizado los registro: ${response.statusCode}');
        print('Cuerpo de la respuesta: ${response.body}');
      }

      return response;
    } catch(e){
      print('Error al actualizado los Registro: $e');
      rethrow;
    }
  }

  // DELETE: api/RegistroForms/5
  Future<http.Response> deleteFormRegistro(String noEncuesta) async {
    try{
      final response = await http.delete(
        Uri.parse('$baseUrl/api/RegistroForms/$noEncuesta'),
      ).timeout(const Duration(seconds: 20));

      if(response.statusCode == 204){
        print('Registro elimidano con éxito');
      }else {
        print('Error al elimidano los registro: ${response.statusCode}');
        print('Cuerpo de la respuesta: ${response.body}');
      }

      return response;
    } catch(e){
      print('Error al elimidar los Registro: $e');
      rethrow;
    }
  }
}