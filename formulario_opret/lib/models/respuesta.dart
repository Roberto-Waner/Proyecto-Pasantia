class Respuesta {
  // int idRespuesta;
  String idUsuarios;
  String noEncuesta;
  int codPregunta;
  String? respuestas;
  String? valoracion;
  String? comentarios;
  String? justificacion;

  Respuesta({
    // required this.idRespuesta,
    required this.idUsuarios,
    required this.noEncuesta,
    required this.codPregunta,
    this.respuestas,
    this.valoracion,
    this.comentarios,
    this.justificacion,
  });

  factory Respuesta.fromJson(Map<String, dynamic> json) {
    return Respuesta(
      // idRespuesta: json['idRespuesta'],
      idUsuarios: json['idUsuarios'],
      noEncuesta: json['noEncuesta'],
      codPregunta: json['codPregunta'],
      respuestas: json['respuesta1'],
      valoracion: json['valoracion'],
      comentarios: json['comentarios'],
      justificacion: json['justificacion']
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    // data['idRespuesta'] = idRespuesta;
    data['idUsuarios'] = idUsuarios;
    data['noEncuesta'] = noEncuesta;
    data['codPregunta'] = codPregunta;
    data['respuesta1'] = respuestas;
    data['valoracion'] = valoracion;
    data['comentarios'] = comentarios;
    data['justificacion'] = justificacion;
    return data;
  }
}