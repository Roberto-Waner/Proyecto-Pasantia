import 'package:formulario_opret/database_cache/Database_Helper.dart';
import 'package:formulario_opret/models/Stored%20Procedure/sp_Insertar_Respuestas.dart';
import 'package:sqflite/sqflite.dart';

class RespuestaCrud {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  // Insertar respuesta localmente
  Future<int> insertRespuesta(SpInsertarRespuestas respuesta) async {
    final db = await _databaseHelper.database;
    return await db.insert(
      'localRespuestas',
      respuesta.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<SpInsertarRespuestas>> getAnswerCrud() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'localRespuestas',
      where: 'isUpdated = 0'
    );
    return List.generate(maps.length, (i) {
      var map = maps[i];
      map.remove('id'); // Removemos el campo 'id' antes de enviar a la API
      return SpInsertarRespuestas.fromJson(maps[i]);
    });
  }

  // Obtener respuestas pendientes de sincronización
  // Future<List<SpInsertarRespuestas>> obtenerRespuestasPendientes() async {
  //   final db = await _databaseHelper.database;
  //   final List<Map<String, dynamic>> maps = await db.query(
  //     'RespuestasLocal',
  //     where: 'isUpdated = 0',
  //   );
  //   return maps.map((map) => SpInsertarRespuestas.fromJson(map)).toList();
  // }

  // Eliminar respuestas que ya fueron sincronizadas
  // Future<int> eliminarRespuesta(String noEncuesta) async {
  //   final db = await _databaseHelper.database;
  //   return await db.delete(
  //     'RespuestasLocal',
  //     where: 'noEncuesta = ?',
  //     whereArgs: [noEncuesta],
  //   );
  // }

  // Marcar respuesta como sincronizada
  Future<void> marcarRespuestaSincronizada(int id) async {
    final db = await _databaseHelper.database;
    await db.update(
      'localRespuestas',
      {'isUpdated': 1},
      where: 'id = ?', 
      whereArgs: [id]
    );
  }

  Future<void> insertarRespuesta(SpInsertarRespuestas respuesta) async {
    final db = await DatabaseHelper.instance.database;

    // Verificar si finalizarSesion es true para incrementar el id
    if(respuesta.finalizarSesion!) {
      // Obtener el último ID utilizado y sumarle 1
      List<Map<String, dynamic>> result = await db.rawQuery('SELECT IFNULL(MAX(id), 0) + 1 AS id FROM localRespuestas');
      int id = result.first['id'];

      // Insertar la nueva respuesta con el nuevo ID
      await db.insert(
        'localRespuestas',
        respuesta.toJson()..['id'] = id,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      print('Sesión finalizada. Respuesta con ID $id insertada.');
    } else {
      // Mantener el mismo id para respuestas de la misma sesión
      List<Map<String, dynamic>> result = await db.rawQuery('SELECT IFNULL(MAX(id), 1) AS id FROM localRespuestas');
      int id = result.first['id'];

      // Insertar la nueva respuesta con el nuevo ID
      await db.insert(
        'localRespuestas',
        respuesta.toJson()..['id'] = id,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      print('Respuesta añadida a la sesión con ID $id.');
    }
  }

  // Future<int> marcarRespuestaSincronizada(String noEncuesta) async {
  //   final db = await _databaseHelper.database;
  //   return await db.update(
  //     'RespuestasLocal',
  //     {'isUpdated': 1, 'isDeleted': 0},
  //     where: 'noEncuesta = ?',
  //     whereArgs: [noEncuesta],
  //   );
  // }
}

  /*
  Future<int> insertAnswersCrud(Respuesta answer) async {
    final db = await _databaseHelper.database;
    return await db.insert(
      'RespuestasLocal', 
      answer.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Respuesta>> queryAnswersCrud() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'RespuestasLocal'
    ).timeout(const Duration(seconds: 5));
    return List.generate(maps.length, (i) {
      return Respuesta.fromJson(maps[i]);
    });
  }

  Future<int> deleteAnswersCrud(String id) async {
    final db = await _databaseHelper.database;
    return await db.delete(
      'RespuestasLocal',
      where: 'noEncuesta = ?',
      whereArgs: [id]
    );
  }

  Future<void> clearSyncFlags(String id) async {
    final db = await _databaseHelper.database;
    await db.update(
      'RespuestasLocal', 
      {'isUpdated': 0, 'isDeleted': 0},
      where: 'noEncuesta = ?',
      whereArgs: [id]
    );
    print("Marcas de sincronización limpiadas para el usuario con ID: $id");
  }
  */

  // Marcar respuesta como sincronizada
  /*
  Future<int> marcarRespuestaSincronizada(String noEncuesta) async {
    final db = await _databaseHelper.database;
    return await db.update(
      'RespuestasLocal',
      {'isUpdated': 1},
      where: 'noEncuesta = ?',
      whereArgs: [noEncuesta],
    );
  }
  */