import 'package:formulario_opret/data/respuesta_crud.dart';
import 'package:formulario_opret/models/respuesta.dart';
import 'package:formulario_opret/services/respuestas_services.dart';

class RespuestaController {
  final RespuestaCrud _respuestaCrud = RespuestaCrud();
  final ApiServiceRespuesta _apiServiceRespuesta = ApiServiceRespuesta('https://10.0.2.2:7190');

  Future<void> saveRespuesta(Respuesta respuesta) async {
    try{
      final response = await _apiServiceRespuesta.postRespuesta(respuesta); 
      if (response.statusCode != 201) { 
        await _saveRespuestaLocal(respuesta); 
      }
    } catch (e) { 
      await _saveRespuestaLocal(respuesta); 
    }
  }

  Future<void> _saveRespuestaLocal(Respuesta respuesta) async { 
    try { 
      await _respuestaCrud.insertAnswersCrud(respuesta); 
      print('Respuesta guardada localmente en SQLite.'); 
    } catch (e) { 
      print('Error al guardar la respuesta localmente: $e'); 
    } 
  }

  Future<void> syncDataResp() async {
    try{
      final respuestasLocales = await _respuestaCrud.queryAnswersCrud();

      for(var respuesta in respuestasLocales) {
        try{
          final response = await _apiServiceRespuesta.postRespuesta(respuesta);

          if(response.statusCode == 201) {
            await _respuestaCrud.deleteAnswersCrud(respuesta.noEncuesta); // Eliminar respuesta de SQLite después de sincronizar
            print('Respuesta sincronizada y eliminada de SQLite.');
          } else { 
            print('Error al sincronizar la respuesta: ${response.reasonPhrase}'); 
          }
        } catch (e) { 
          print('Error al sincronizar la respuesta: $e'); 
        }
      }
    } catch (e) { 
      print('Error al sincronizar respuestas: $e'); 
    }
  }
}