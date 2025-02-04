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

  Future<void> actualizarCrud(int id, SpInsertarRespuestas answer) async {
    final db = await _databaseHelper.database;

    await db.update(
      'localRespuestas',
      answer.toJson(),
      where: 'idSesion = ?',
      whereArgs: [id],
    );
    print('Campo finalizarSesion actualizado a 1 para idUsuarios: $id');
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

  Future<void> deleteAnswerCrud(int id) async {
    final db = await _databaseHelper.database;
    await db.delete(
        'RespuestasLocal',
        where: 'idSesion = ?',
        whereArgs: [id]
    );
    print("Respuesta borrada y agregada nuevamente por parte del usuario con ID: $id");
  }
}