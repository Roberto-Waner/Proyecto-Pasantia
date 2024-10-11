//------------------------------------------------Modelo de la tabla Pregunta
class Pregunta {
  int noPregunta;
  String tipoRespuesta;
  String? gurpoTema;
  String? pregunta1;
  int? idSubPregunta;
  int? idRango;
  // Relación con TipoRespuesta
  RangoRespuestas? rangoRespuestas; /*esto se hace cuando un modelo que representa a una tabla que tenga foreign key con otra tabla*/

  Pregunta({
    required this.noPregunta,
    required this.tipoRespuesta,
    this.gurpoTema, 
    this.pregunta1,
    this.idSubPregunta,
    this.idRango,
    this.rangoRespuestas // Inicializa la relación
  });

  factory Pregunta.fromJson(Map<String, dynamic> json) {
    return Pregunta(
      noPregunta: json['noPregunta'],
      tipoRespuesta: json['tipoRespuesta'],
      gurpoTema: json['gurpoTema'],
      pregunta1: json['pregunta1'],
      idSubPregunta: json['idSubPregunta'] ,
      idRango: json['idRango'],
      rangoRespuestas: json['rangoRespuestas'] != null
          ? RangoRespuestas.fromJson(json['rangoRespuestas']) // Si hay datos en tipoRespuesta
          : null, // Maneja el caso de que tipoRespuesta sea null
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['noPregunta'] = noPregunta;
    data['tipoPregunta'] = tipoRespuesta;
    data['gurpoTema'] = gurpoTema;
    data['pregunta1'] = pregunta1;
    data['idSubPregunta'] = idSubPregunta;
    data['idRango'] = idRango;
    if (rangoRespuestas != null) {
      data['rangoRespuestas'] = rangoRespuestas!.toJson(); // Si existe tipoRespuesta, incluirlo en el JSON
    }
    return data;
  }
}

//--------------------------------------------------Modelo de la tabla Tipo Respuesta

class RangoRespuestas {
  int? idRango;
  String? rango;

  RangoRespuestas({
    this.idRango,
    this.rango
  });

  factory RangoRespuestas.fromJson(Map<String, dynamic> json) {
    return RangoRespuestas(
      idRango: json['idRango'],
      rango: json['rango']
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    // data['idTipRespuesta'] = idTipRespuesta;
    data['rango'] = rango;
    return data;
  }
}