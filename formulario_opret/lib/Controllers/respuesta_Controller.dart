import 'package:formulario_opret/data/respuesta_crud.dart';
import 'package:formulario_opret/models/Stored%20Procedure/sp_Insertar_Respuestas.dart';
import 'package:formulario_opret/services/Stream/stream_services.dart';
import 'package:formulario_opret/services/respuestas_services.dart';

class RespuestaController {
  final RespuestaCrud _respuestaCrud = RespuestaCrud();
  // final RespuestaRepository _respuestaRepository = RespuestaRepository();
  final ApiServiceRespuesta _apiServiceRespuesta = ApiServiceRespuesta('https://10.0.2.2:7190');
  final StreamServices _streamServices = StreamServices('https://10.0.2.2:7190');

  RespuestaController() {
    _streamServices.backendAvailabilityStream.listen((isAvailable) {
      if (isAvailable) {
        syncDataResp();
      }
    });
  }

  // Guardar respuesta localmente
  // Future<void> saveRespuesta(SpInsertarRespuestas respuesta) async {
  //   // await _respuestaCrud.insertRespuesta(respuesta);
  //   await _respuestaCrud.insertRespuesta(respuesta);
  //   print('Respuesta guardada localmente');

  //   // Sincronizar los datos si hay conexión
  //   if (respuesta.finalizarSesion){
  //     syncDataResp();
  //   }
  // }

  Future<void> saveRespuesta(SpInsertarRespuestas respuesta) async {
    await _respuestaCrud.insertRespuesta(respuesta);
    // try{
    //   final localResponse = await _respuestaCrud.insertRespuesta(respuesta);
    //   if(localResponse == 201) {
    //     print('Respuesta guardado localmente');
    //   } else {
    //     final remoteResponse = await _apiServiceRespuesta.postRespuesta(respuesta);
    //     if(remoteResponse.statusCode == 201) {
    //       print('Respuesta guardado en servidor');
    //     } else {
    //       localResponse;
    //     }
    //   }
    // } catch (e) {
    //   rethrow;
    // }
  }

  Future<void> syncDataResp() async {
    try{
      List<SpInsertarRespuestas> respuestasPendientes = await _respuestaCrud.getAnswerCrud();

      for (SpInsertarRespuestas answer in respuestasPendientes) {
        final isCheckOk = await _apiServiceRespuesta.service.check();
        if (isCheckOk) {
          final postResponse = await _apiServiceRespuesta.postRespuesta(answer);
          if (postResponse.statusCode == 201) {
            await _respuestaCrud.marcarRespuestaSincronizada(answer.idSesion); // usamos idSesion para identificar
            print('Respuesta sincronizada con la api');
          }else { 
            print('Error al sincronizar la respuesta: ${postResponse.statusCode}'); 
          }
        } else { 
          print('No hay conexión a la API para sincronizar la respuesta.'); 
        }
      }
    } catch (e) {
      print('Error al sincronizar la respuesta: $e');
    }
  }

  // Liberar recursos cuando el controlador no se necesite más
  // void dispose() {
  //   _streamServices.dispose();
  // }
}