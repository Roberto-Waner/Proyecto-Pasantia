import 'package:formulario_opret/database_cache/Database_Helper.dart';
import 'package:formulario_opret/models/respuesta.dart';
import 'package:intl/intl.dart';

class RespuestaRepository {
  Future<void> insertarRespuesta(Respuesta respuesta, {required bool finalizarSesion}) async {
    final db = await DatabaseHelper.instance.database; 
    final year = DateFormat('yyyy').format(DateTime.now());

    // Verificar si el noEncuesta ya existe en la base de datos
    if(respuesta.noEncuesta != null) {
      List<Map<String, dynamic>> existingRespuesta = await db.query(
        'RespuestasLocal',
        where: 'noEncuesta = ?', 
        whereArgs: [respuesta.noEncuesta]
      );

      if (existingRespuesta.isNotEmpty) {
        // Si ya existe, actualizamos la respuesta
        await db.update( 
          'RespuestasLocal', 
          respuesta.toJson(), 
          where: 'noEncuesta = ?', 
          whereArgs: [respuesta.noEncuesta] 
        ); 
        print('Respuesta actualizada: ${respuesta.noEncuesta}');
      } else {
        // Si no existe, insertamos una nueva respuesta
        await db.insert('RespuestasLocal', respuesta.toJson());
      }
    }else { 
      // Si noEncuesta es null, simplemente insertamos la nueva respuesta 
      await db.insert('RespuestasLocal', respuesta.toJson()); 
    }

    // Generar el noEncuesta y actualizarlo solo si se finaliza la sesión
    if(finalizarSesion) {
      // Obtener el número de orden global para el año actual
      List<Map<String, dynamic>> ordenResult = await db.rawQuery(
        '''
          SELECT IFNULL(MAX(CAST(SUBSTR(noEncuesta, -2) AS INTEGER)), 0) + 1 AS orden
          FROM RespuestasLocal
          WHERE noEncuesta IS NOT NULL AND strftime('%Y', datetime('now')) = ?
        ''', [year]);
      
      int orden = ordenResult.first['orden'] ?? 0;
      String noEncuesta = '$year - ${orden.toString().padLeft(2, '0')}';

      // Actualizar el noEncuesta en la tabla RespuestasLocal para el conjunto de preguntas
      await db.rawUpdate(
        '''
          UPDATE RespuestasLocal
          SET noEncuesta = ?
          WHERE noEncuesta is null
        ''', [noEncuesta]);
      
      print('NoEncuesta generado: $noEncuesta');
    }
  }
}