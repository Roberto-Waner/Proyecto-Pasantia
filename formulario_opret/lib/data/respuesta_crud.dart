import 'package:formulario_opret/database_cache/Database_Helper.dart';
import 'package:formulario_opret/models/Stored%20Procedure/sp_Insertar_Respuestas.dart';
import 'package:sqflite/sqflite.dart';

class RespuestaCrud {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  // Insertar múltiples respuestas localmente
  Future<void> insertRespuestas(List<SpInsertarRespuestas> respuestas) async {
    final db = await _databaseHelper.database;

    // Usamos un batch para realizar múltiples inserciones en una sola transacción
    Batch batch = db.batch();
    for (var respuesta in respuestas) {
      batch.insert(
        'localRespuestas',
        respuesta.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
    print('Respuestas guardadas en la base de datos local SQLite con éxito');
  }

  Future<List<SpInsertarRespuestas>> getAnswerCrud() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'localRespuestas',
      // where: 'isUpdated = 0'
    );
    return List.generate(maps.length, (i) {
      return SpInsertarRespuestas.fromJson(maps[i]);
    });
  }

  // para vaciar la tabla despues de que se hayan guardado hacia la api
  Future<void> vaciarTable() async {
    final db = await _databaseHelper.database;
    await db.delete('localRespuestas');
    print('Todos los registros eliminados de la tabla localRespuestas');
  }

  // Cargar una respuesta específica desde la caché local
  Future<SpInsertarRespuestas?> getRespuestaById(int idSesion) async {
    try {
      final db = await DatabaseHelper.instance.database;
      final result = await db.query(
        'localRespuestas',
        where: 'idSesion = ?',
        whereArgs: [idSesion],
      );
      if (result.isNotEmpty) {
        return SpInsertarRespuestas.fromJson(result.first);
      }
      return null;
    } catch (e) {
      print('Error al cargar la respuesta: $e');
      return null;
    }
  }

  // Actualizar una respuesta específica en la caché local
  Future<void> updateRespuesta(SpInsertarRespuestas respuesta) async {
    try {
      final db = await DatabaseHelper.instance.database;
      await db.update(
        'localRespuestas',
        respuesta.toJson(),
        where: 'idSesion = ?',
        whereArgs: [respuesta.idSesion],
      );
      print('Respuesta actualizada en la caché local para idSesion: ${respuesta.idSesion}');
      print('dato actualizado: $db');
    } catch (e) {
      print('Error al actualizar la respuesta: $e');
    }
  }

  Future<int> permissionToEdict() async {
    final db = await _databaseHelper.database;

    // Actualizar todos los registros de la tabla localRespuestas a isUpdated = 1
    return await db.update(
      'localRespuestas',
      {'isUpdated': 1},
    );
  }
}