import 'package:formulario_opret/database_cache/Database_Helper.dart';
import 'package:formulario_opret/models/respuesta.dart';
import 'package:sqflite/sqflite.dart';

class RespuestaCrud {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  // Insertar respuesta localmente
  Future<int> insertRespuesta(Respuesta respuesta) async {
    final db = await _databaseHelper.database;
    return await db.insert(
      'RespuestasLocal',
      respuesta.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Respuesta>> getAnswerCrud() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'RespuestasLocal',
      // where: 'isDeleted = 0'
    );
    // Imprimir las respuestas en la consola 
    print('Todas las respuestas:'); 
    maps.forEach((map) { print(map); });
    return List.generate(maps.length, (i) {
      return Respuesta.fromJson(maps[i]);
    });
  }

  // Obtener respuestas pendientes de sincronización
  Future<List<Respuesta>> obtenerRespuestasPendientes() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'RespuestasLocal',
      where: 'isUpdated = 0',
    );
    return maps.map((map) => Respuesta.fromJson(map)).toList();
  }

  // Eliminar respuestas que ya fueron sincronizadas
  Future<int> eliminarRespuesta(String noEncuesta) async {
    final db = await _databaseHelper.database;
    return await db.delete(
      'RespuestasLocal',
      where: 'noEncuesta = ?',
      whereArgs: [noEncuesta],
    );
  }

  // Marcar respuesta como sincronizada
  Future<int> marcarRespuestaSincronizada(String noEncuesta) async {
    final db = await _databaseHelper.database;
    return await db.update(
      'RespuestasLocal',
      {'isUpdated': 1, 'isDeleted': 0},
      where: 'noEncuesta = ?',
      whereArgs: [noEncuesta],
    );
  }
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