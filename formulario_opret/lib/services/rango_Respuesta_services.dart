import 'dart:convert';
import 'dart:io';
import 'package:formulario_opret/models/pregunta.dart';
import 'package:http/http.dart' as http;

class ApiServiceRangoResp {
  final String baseUrl;

  ApiServiceRangoResp(this.baseUrl);

  // GET: api/RangosRespuestas
  Future<List<RangoRespuestas>> getRangoResp() async {
    try{
      final response = await http.get(Uri.parse('$baseUrl/api/RangosRespuestas')).timeout(const Duration(seconds: 20));

      if(response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        return body.map((json) => RangoRespuestas.fromJson(json)).toList();
      } else {
        throw Exception('Error al cargar los Rangos: ${response.statusCode}');
      }

    }catch(e){
      print('Error al cargar los Rangos: $e');
      rethrow;
    }
  }

  // POST: api/RangosRespuestas
  Future<http.Response> postRangoResp(RangoRespuestas rango) async {
    try{
      final response = await http.post(
        Uri.parse('$baseUrl/api/RangosRespuestas'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: jsonEncode(rango.toJson())
      ).timeout(const Duration(seconds: 20));

      if(response.statusCode == 201){
        print('Rango agregado con Exito');
      } else {
        print('Error al agregar los Rangos: ${response.statusCode}');
        print('Cuerpo de la respuesta: ${response.body}');
      }

      return response;
    }catch(e){
      print('Error al cargar los Rangos: $e');
      rethrow;
    }
  }

  // PUT: api/RangosRespuestas/5
  Future<http.Response> putRangoResp(int id, RangoRespuestas rango) async {
    try{
      final response = await http.put(
        Uri.parse('$baseUrl/api/RangosRespuestas/$id'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: jsonEncode(rango.toJson()),
      ).timeout(const Duration(seconds: 20));

      if(response.statusCode == 204) {
        print('Rango actualizada con éxito');
      }else{
        print('Error al actualizar los Rangos: ${response.statusCode}');
        print('Cuerpo de la respuesta: ${response.body}');
      }

      return response;
    } catch (e) {
      print('Error al actualizar los Rangos $e');
      rethrow;
    }
  }

  // DELETE: api/RangosRespuestas/5
  Future<http.Response> deleteRangoResp(int id) async {
    try{
      final response = await http.delete(
        Uri.parse('$baseUrl/api/RangosRespuestas/$id'),
      ).timeout(const Duration(seconds: 20));

      if(response.statusCode == 204) {
        print('Rango eliminada con éxito');
      }else{
        print('Error al eliminar los Rangos: ${response.statusCode}');
        print('Cuerpo de la respuesta: ${response.body}');
      }

      return response;
    }catch (e) {
      print('Error al eliminar Rango: $e');
      rethrow;
    }
  }
}