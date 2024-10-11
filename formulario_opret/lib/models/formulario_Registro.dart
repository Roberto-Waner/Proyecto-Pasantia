// import 'package:flutter/material.dart';

class FormularioRegistro {
  String noEncuesta;
  String idUsuarios;
  String cedula;
  String? fecha;
  String? hora;
  String? estacion;
  String? linea;

  FormularioRegistro({
    required this.noEncuesta,
    required this.idUsuarios,
    required this.cedula,
    this.fecha,
    this.hora,
    this.estacion,
    this.linea
  });

  factory FormularioRegistro.fromJson(Map<String, dynamic> json) {
    return FormularioRegistro(
      noEncuesta: json['noEncuesta'],
      idUsuarios: json['idUsuarios'],
      cedula: json['cedula'],
      fecha: json['fecha'],
      hora: json['hora'],
      estacion: json['estacion'],
      linea: json['linea'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['noEncuesta'] = noEncuesta;
    data['idUsuarios'] = idUsuarios;
    data['cedula'] = cedula;
    data['fecha'] = fecha;
    data['hora'] = hora;
    data['estacion'] = estacion;
    data['linea'] = linea;
    return data;
  }
}