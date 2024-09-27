class Pregunta {
  int idPreguntas;
  String preguntas;

  Pregunta({
    required this.idPreguntas, 
    required this.preguntas
  });

  factory Pregunta.fromJson(Map<String, dynamic> json) {
    return Pregunta(
      idPreguntas: json['idPreguntas'],
      preguntas: json['preguntas']
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idPreguntas'] = idPreguntas;
    data['preguntas'] = preguntas;
    return data;
  }
}