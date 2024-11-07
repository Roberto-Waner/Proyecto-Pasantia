import 'package:formulario_opret/database_cache/Database_Helper.dart';
import 'package:formulario_opret/models/respuesta.dart';
import 'package:sqflite/sqflite.dart';

class RespuestaCrud {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

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
}