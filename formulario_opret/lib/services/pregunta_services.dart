import 'dart:convert';
import 'dart:io';
import 'package:formulario_opret/models/Stored%20Procedure/sp_preguntasCompleta.dart';
import 'package:formulario_opret/models/pregunta.dart';
import 'package:http/http.dart' as http;

class ApiServicePreguntas {
  final String baseUrl;

  ApiServicePreguntas(this.baseUrl);

  // GET: api/SesionPreguntas
  Future<List<Preguntas>> getPreguntas() async {
    try{
      final response = await http.get(Uri.parse('$baseUrl/api/Preguntas')).timeout(const Duration(seconds: 20));

      if(response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        return body.map((json) => Preguntas.fromJson(json)).toList();
      } else {
        throw Exception('Error al cargar las Preguntas: ${response.statusCode}');
      }

    }catch(e){
      print('Error al cargar la pregunta: $e');
      rethrow;
    }
  }

  Future<List<SpPreguntascompleta>> getSpPreguntascompletaListada() async {
    List<SpPreguntascompleta> dataQuestion = [];

    try{
      final response = await http.get(Uri.parse('$baseUrl/api/PreguntasCompletas/obtenerPreguntasCompleto')).timeout(const Duration(seconds: 20));

      if(response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);
        dataQuestion = jsonData.map((json) => SpPreguntascompleta.fromJson(json)).toList();
      } else {
        throw Exception('Error al cargar las SpPreguntascompleta: ${response.statusCode}');
      }

    }catch(e){
      print('Error al cargar la SpPreguntascompleta: $e');
      rethrow;
    }

    return dataQuestion;
  }

  // POST: api/SesionPreguntas
  Future<http.Response> postPreguntas(Preguntas pregunta) async {
    try{
      final response = await http.post(
        Uri.parse('$baseUrl/api/Preguntas'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: jsonEncode(pregunta.toJson()),
      ).timeout(const Duration(seconds: 20));

      if(response.statusCode == 201){
        print('Pregunta creada con éxito');
      }else {
        print('Error al crear la pregunta: ${response.statusCode}');
        print('Cuerpo de la respuesta: ${response.body}');
      }

      return response;
    }catch (e) {
      // Manejo de excepciones generales, como problemas de red
      print('Error al crear la Pregunta: $e');
      rethrow; // Lanza de nuevo la excepción si se desea manejar más arriba
    }
  }

  // PUT: api/SesionPreguntas/5
  Future<http.Response> putPreguntas(int id, Preguntas pregunta) async {
    try{
      final response = await http.put(
        Uri.parse('$baseUrl/api/Preguntas/$id'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: jsonEncode(pregunta.toJson()),
      ).timeout(const Duration(seconds: 20));

      if(response.statusCode == 204) {
        print('Pregunta actualizada con éxito');
      }else{
        print('Error al actualizar la pregunta: ${response.statusCode}');
        print('Cuerpo de la respuesta: ${response.body}');
      }

      return response;
    } catch (e) {
      print('Error al actualizar la pregunta $e');
      rethrow;
    }
  }

  // DELETE: api/SesionPreguntas/5
  Future<http.Response> deletePreguntas(int id) async {
    try{
      final response = await http.delete(
        Uri.parse('$baseUrl/api/Preguntas/$id'),
      ).timeout(const Duration(seconds: 20));

      if(response.statusCode == 204) {
        print('Pregunta eliminada con éxito');
      }else{
        print('Error al eliminar la pregunta: ${response.statusCode}');
        print('Cuerpo de la respuesta: ${response.body}');
      }

      return response;
    }catch (e) {
      print('Error al eliminar la pregunta: $e');
      rethrow;
    }
  }
}