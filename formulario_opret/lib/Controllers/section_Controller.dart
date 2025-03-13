import 'dart:async';
import 'package:formulario_opret/data/section_crud.dart';
import 'package:formulario_opret/models/Stored%20Procedure/sp_preguntasCompleta.dart';
import 'package:formulario_opret/services/Stream/stream_services.dart';
import 'package:formulario_opret/services/sesion_services.dart';

class SectionController {
  final SectionCrud _sectionCrud = SectionCrud();
  final ApiServiceSesion2 _apiServiceSesion2 = ApiServiceSesion2('http://backend-api.somee.com');
  final StreamServices _streamServices = StreamServices('http://backend-api.somee.com');

  SectionController() {
    _streamServices.backendAvailabilityStream.listen((isAvailable) {
      if (isAvailable) {
        syncData();
      }
    });
  }

  Future<List<SpPreguntascompleta>> loadPreguntasFromCache() async {
    try {
      List<SpPreguntascompleta> preguntasCache = await _sectionCrud.querySectionCrud();
      // print('📌 Preguntas cargadas desde la caché: $preguntasCache');

      final preguntasHabilitados = preguntasCache.where((p) => p.sp_Estado == 1).toList();
      return preguntasHabilitados;
    } catch (e) {
      print('⚠️ Error al cargar preguntas desde la caché: $e');
      return [];
    }
  }

  Future<void> syncData() async {
    try {
      List<SpPreguntascompleta> preguntasApi = await _apiServiceSesion2.getSpPreguntascompletaListada().timeout(const Duration(seconds: 5));
      print("Datos obtenidos desde la API: $preguntasApi");

      // Filtrar preguntas con estado 'true'
      final preguntasHabilitadas = preguntasApi.where((q) => q.sp_Estado == 1).toList();
      print('✅ Preguntas habilitadas: ${preguntasHabilitadas.length}');

      if (preguntasHabilitadas.isNotEmpty) {
        await _sectionCrud.truncateSectionCrud();
        print('🗑️ Preguntas locales eliminadas.');

        await _sectionCrud.insertSectionCrud(preguntasHabilitadas);

        print("✅ Sincronización completada: ${preguntasHabilitadas.length} registros insertados.");
      } else {
        print("⚠️ La API no devolvió preguntas habilitadas.");
      }

    } catch (e) {
      print("⚠️ Error en la sincronización: $e");
    }
  }
}