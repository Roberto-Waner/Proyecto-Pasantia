import 'dart:convert';
import 'dart:io';
import 'package:formulario_opret/models/respuesta.dart';
import 'package:http/http.dart' as http;

class ApiServiceRespuesta {
  final String baseUrl;

  ApiServiceRespuesta(this.baseUrl);

  // GET: api/Respuestas
  Future<List<Respuesta>> getRespuestas() async {
    try{
      final response = await http.get(
        Uri.parse('$baseUrl/api/Respuestas')
      ).timeout(const Duration(seconds: 20));

      if(response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        return body.map((json) => Respuesta.fromJson(json)).toList();
      }else {
        throw Exception('Error al cargar las Respuestas: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al cargar las respuestas: $e');
      rethrow;
    }
  }

  // POST: api/Respuestas
  Future<http.Response> postRespuesta(Respuesta respuesta) async {
    try{
      final response = await http.post(
        Uri.parse('$baseUrl/api/Respuestas'),
        headers: {
          HttpHeaders.contentTypeHeader:  'application/json',
        },
        body: jsonEncode(respuesta.toJson())
      ).timeout(const Duration(seconds: 20));

      if(response.statusCode == 201) {
        print('Respuesta enviada con exito');
      }else {
        print('Error al enviar la respuesta: ${response.statusCode}');
        print('Cuerpo de la respuesta: ${response.body}');
      }

      return response;
    } catch (e) {
      print('Error al cargar las respuestas: $e');
      rethrow;
    }
  }

  // PUT: api/Respuestas/5
  Future<http.Response> putRespuesta (int id, Respuesta respuesta) async {
    try{
      final response = await http.put(
        Uri.parse('$baseUrl/api/Respuestas/$id'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: jsonEncode(respuesta.toJson()),
      ).timeout(const Duration(seconds: 20));

      if(response.statusCode == 204) {
        print('Respuesta actualizada con exito');
      }else {
        print('Error al actualizar la Respuesta: ${response.statusCode}');
        print('Cuerpo de la respuesta: ${response.body}');
      }

      return response;
    } catch (e) {
      print('Error al actualizar la respuesta $e');
      rethrow;
    }
  }

  // DELETE: api/Respuestas/5
  Future<http.Response> deleteRespuestas(int id) async {
    try{
      final response = await http.delete(
        Uri.parse('$baseUrl/api/Respuestas/$id'),
      ).timeout(const Duration(seconds: 20));

      if(response.statusCode == 204) {
        print('Respuesta eliminada con exito');
      }else{
        print('Error al eliminar la respuesta: ${response.statusCode}');
        print('Cuerpo de la respuesta: ${response.body}');
      }

      return response;
    }catch (e) {
      print('Error al eliminar la respuestas: $e');
      rethrow;
    }
  }
}