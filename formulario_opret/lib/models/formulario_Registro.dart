// import 'package:flutter/material.dart';

class FormularioRegistro {
  String noEncuesta;
  String idUsuarioEmpl;
  String cedlEmpleado;
  String? fechaEncuesta;
  String? hora;
  String? estacion;
  String? linea;

  FormularioRegistro({
    required this.noEncuesta,
    required this.idUsuarioEmpl,
    required this.cedlEmpleado,
    this.fechaEncuesta,
    this.hora,
    this.estacion,
    this.linea
  });

  factory FormularioRegistro.fromJson(Map<String, dynamic> json) {
    return FormularioRegistro(
      noEncuesta: json['noEncuesta'],
      idUsuarioEmpl: json['idUsuarioEmpl'],
      cedlEmpleado: json['cedlEmpleado'],
      fechaEncuesta: json['fechaEncuesta'],
      hora: json['hora'],
      estacion: json['estacion'],
      linea: json['linea'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['noEncuesta'] = noEncuesta;
    data['idUsuarioEmpl'] = idUsuarioEmpl;
    data['cedlEmpleado'] = cedlEmpleado;
    data['fechaEncuesta'] = fechaEncuesta;
    data['hora'] = hora;
    data['estacion'] = estacion;
    data['linea'] = linea;
    return data;
  }
}