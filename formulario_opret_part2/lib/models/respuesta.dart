class Respuesta {
  // int idRespuesta;
  String idUsuarioEmpl;
  String noEncuesta;
  int idPreguntas;
  String? respuestas;
  String? valoracion;

  Respuesta({
    // required this.idRespuesta,
    required this.idUsuarioEmpl,
    required this.noEncuesta,
    required this.idPreguntas,
    this.respuestas,
    this.valoracion
  });

  factory Respuesta.fromJson(Map<String, dynamic> json) {
    return Respuesta(
      // idRespuesta: json['idRespuesta'],
      idUsuarioEmpl: json['idUsuarioEmpl'],
      noEncuesta: json['noEncuesta'],
      idPreguntas: json['idPreguntas'],
      respuestas: json['respuestas'],
      valoracion: json['valoracion']
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    // data['idRespuesta'] = idRespuesta;
    data['idUsuarioEmpl'] = idUsuarioEmpl;
    data['noEncuesta'] = noEncuesta;
    data['idPreguntas'] = idPreguntas;
    data['respuestas'] = respuestas;
    data['valoracion'] = valoracion;
    return data;
  }
}