import 'package:formulario_opret/Repositories/respuesta_Repository.dart';
import 'package:formulario_opret/data/respuesta_crud.dart';
import 'package:formulario_opret/models/respuesta.dart';
import 'package:formulario_opret/services/Stream/stream_services.dart';
import 'package:formulario_opret/services/respuestas_services.dart';

class RespuestaController {
  final RespuestaCrud _respuestaCrud = RespuestaCrud();
  final ApiServiceRespuesta _apiServiceRespuesta = ApiServiceRespuesta('https://10.0.2.2:7190');
  final StreamServices _streamServices = StreamServices('https://10.0.2.2:7190');
  final RespuestaRepository _respuestaRepository = RespuestaRepository();

  RespuestaController() {
    _streamServices.backendAvailabilityStream.listen((isAvailable) {
      if (isAvailable) {
        syncDataResp();
      }
    });
  }

  // Guardar respuesta localmente
  Future<void> saveRespuesta(Respuesta respuesta, bool finalizarSesion) async {
    // await _respuestaCrud.insertRespuesta(respuesta);
    await _respuestaRepository.insertarRespuesta(respuesta, finalizarSesion: finalizarSesion);
    if (finalizarSesion) {
      print('Generando noEncuesta y sincronizando con el backend...');
      await syncDataResp();
    }
    print('Respuesta guardada localmente');
  }

  // Sincronizar respuestas pendientes con el backend
  // Future<void> syncDataResp() async {
  //   List<Respuesta> respuestasPendientes = await _respuestaCrud.obtenerRespuestasPendientes();
  //   for (var respuesta in respuestasPendientes) {
  //     print('Repuesta pendiente: $respuestasPendientes');
  //     try{
  //       final postResponse = await _apiServiceRespuesta.postRespuesta(respuesta);
  //       // Si la respuesta ya existe (por ejemplo, código 409 Conflicto), actualiza la respuesta
  //       if(postResponse.statusCode == 409) {
  //         final putResponse = await _apiServiceRespuesta.putRespuesta(respuesta.noEncuesta!, respuesta);
  //         if (putResponse.statusCode == 200) {
  //           await _respuestaCrud.marcarRespuestaSincronizada(respuesta.noEncuesta!);
  //           print('Respuesta actualizada: ${respuesta.noEncuesta}');
  //         }
  //       } else if (postResponse.statusCode == 201) {
  //         // Si se publica con éxito (código 201 creado) 
  //         await _respuestaCrud.marcarRespuestaSincronizada(respuesta.noEncuesta!); 
  //         print('Respuesta sincronizada: ${respuesta.noEncuesta}');
  //       }
  //     } catch (e) {
  //       print('Error al sincronizar la respuesta: $e');
  //     }
  //   }
  // }

  Future<void> syncDataResp() async {
    try{
      List<Respuesta> respuestasPendientes = await _respuestaCrud.obtenerRespuestasPendientes();

      for(Respuesta answer in respuestasPendientes) {
        final isCheckOk = await _apiServiceRespuesta.service.check();
        if(isCheckOk) {
          try{
            final response = await _apiServiceRespuesta.postRespuesta(answer);
            if (response.statusCode == 201) {
              await _respuestaCrud.marcarRespuestaSincronizada(answer.noEncuesta!);
              print('Respuesta sincronizada: ${answer.noEncuesta}');
            } else /*if (response == )*/{
              print('Error al enviar la respuesta en la Api: ${response.statusCode}');
              print('Cuerpo de la respuesta: ${response.body}');
            }
          } catch (e) {
            print('Error al enviar respuesta a la API: $e');
          }
          
        } else {
          print('No hay conexión a la API para sincronizar la respuesta: ${answer.noEncuesta}');
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

  /*
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
      List<Respuesta> respuestasLocales = await _respuestaCrud.queryAnswersCrud();

      for(Respuesta respuesta in respuestasLocales) {
        final isCheckOk = await _apiServiceRespuesta.service.check();

        if(isCheckOk) {
          final response = await _apiServiceRespuesta.postRespuesta(respuesta);

          if(response.statusCode == 201) {
            await _respuestaCrud.deleteAnswersCrud(respuesta.noEncuesta!); // Eliminar respuesta de SQLite después de sincronizar
            // await _respuestaCrud.clearSyncFlags(respuesta.noEncuesta);
            print('Respuesta sincronizada y eliminada de SQLite.');
          } else { 
            print('Error al sincronizar la respuesta: ${response.reasonPhrase}'); 
          }
        } else {
          // Si la API no está disponible, guardar localmente y marcar como pendiente
          print('La API no está disponible, se guardarán los cambios localmente.');
        }
        
      }
    } catch (e) { 
      print('Error al sincronizar respuestas: $e'); 
    }
  }
  */