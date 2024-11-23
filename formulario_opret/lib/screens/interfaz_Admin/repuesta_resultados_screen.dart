import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:formulario_opret/models/Stored%20Procedure/sp_Filtrar_Respuestas.dart';
import 'package:formulario_opret/screens/interfaz_Admin/navbar/navbar.dart';
import 'package:formulario_opret/services/respuestas_services.dart';

class RepuestaResultadosScreen extends StatefulWidget {
  final TextEditingController filtrarUsuarioController;
  final TextEditingController filtrarEmailController;
  final TextEditingController filtrarId;
  final TextEditingController filtrarCedula;

  const RepuestaResultadosScreen({
    super.key,
    required this.filtrarId,
    required this.filtrarCedula,
    required this.filtrarUsuarioController,
    required this.filtrarEmailController,
  });

  @override
  State<RepuestaResultadosScreen> createState() => _RepuestaResultadosScreenState();
}

class _RepuestaResultadosScreenState extends State<RepuestaResultadosScreen> {
  final ApiServiceRespuesta _apiServiceRespuesta =  ApiServiceRespuesta('https://10.0.2.2:7190');
  late Future<List<SpFiltrarRespuestas>> _respuestaData;
  final TextEditingController searchController = TextEditingController();
  List<SpFiltrarRespuestas> respuestasFiltrados = [];
  List<SpFiltrarRespuestas> todasLasRespuestas = [];

  @override
  void initState() {
    super.initState();
    _respuestaData = Future.value([]);
    _loadRespuestas();
  }

  Future<void> _loadRespuestas() async {
    final respuestas = await _apiServiceRespuesta.getRespuestas();
    setState(() {
      todasLasRespuestas = respuestas; 
      respuestasFiltrados = respuestas;
      _respuestaData = Future.value(respuestas); // Actualiza el Future con los datos cargados
    });
  }

  void _filtrarRespuestas(String query) async {
    // final respuestas = await _respuestaData;
    final respuestasFiltradasTemp = todasLasRespuestas.where((answer) {
      final queryLower = query.toLowerCase();
      return (answer.sp_IdUsuarios?.toLowerCase().contains(queryLower) ?? false) ||
            (answer.sp_Cedula?.toLowerCase().contains(queryLower) ?? false) || 
            (answer.sp_NombreApellido?.toLowerCase().contains(queryLower) ?? false) || 
            (answer.sp_Usuarios?.toLowerCase().contains(queryLower) ?? false) || 
            (answer.sp_NoEncuesta?.toLowerCase().contains(queryLower) ?? false) || 
            (answer.sp_IdSesion?.toString().toLowerCase().contains(queryLower) ?? false) || 
            (answer.sp_CodPreguntas?.toString().toLowerCase().contains(queryLower) ?? false) || 
            (answer.sp_CodSupPreguntas?.toLowerCase().contains(queryLower) ?? false);
    }).toList();

    setState(() {
      respuestasFiltrados = respuestasFiltradasTemp;
    });
  }

  void _limpiarBusqueda() { 
    searchController.clear(); 
    setState(() { 
      respuestasFiltrados = todasLasRespuestas; 
    }); 
  } 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Navbar(
        filtrarUsuarioController: widget.filtrarUsuarioController,
        filtrarEmailController: widget.filtrarEmailController,
        filtrarId: widget.filtrarId,
        filtrarCedula: widget.filtrarCedula,
      ),

      appBar: AppBar(
        title: const Text('Tablas de Respuestas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, size: 30.0),
            tooltip: 'Recargar',
            onPressed: () {
              setState(() {
                _loadRespuestas();
              });
            },
          )
        ],
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: FormBuilder(
              child: FormBuilderTextField(
                name: 'search',
                controller: searchController,
                style: const TextStyle(fontSize: 20.0),
                decoration: InputDecoration( 
                  labelText: 'Buscar', 
                  labelStyle: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold), 
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: _limpiarBusqueda,
                      )
                    : null 
                ),
                onChanged: (value) { 
                  if (value!.isNotEmpty) { 
                    _filtrarRespuestas(value); 
                  } else { 
                    setState(() { 
                      respuestasFiltrados = []; 
                    }); 
                  } 
                },
              )
            )
          ),
          Expanded(
            child: FutureBuilder<List<SpFiltrarRespuestas>>(
              future: _respuestaData, 
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting){
                  return const Center(child: CircularProgressIndicator());
                }else if (snapshot.hasError){
                  return Center(child: Text('Error al cargar los datos: ${snapshot.error}'));
                } else {
                  final answerData = respuestasFiltrados.isNotEmpty
                      ? respuestasFiltrados
                      : snapshot.data ?? [];

                  return SingleChildScrollView(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text('ID del Usuario', style: TextStyle(fontSize: 23.0))),
                          DataColumn(label: Text('Cedula de Identida', style: TextStyle(fontSize: 23.0))),
                          DataColumn(label: Text('Nombre y Apellido', style: TextStyle(fontSize: 23.0))),
                          DataColumn(label: Text('Usuarios', style: TextStyle(fontSize: 23.0))),
                          DataColumn(label: Text('No. Encuesta', style: TextStyle(fontSize: 23.0))),
                          DataColumn(label: Text('Numero de Sesion', style: TextStyle(fontSize: 23.0))),
                          DataColumn(label: Text('Numero de Pregunta', style: TextStyle(fontSize: 23.0))),
                          DataColumn(label: Text('Pregunta', style: TextStyle(fontSize: 23.0))),
                          DataColumn(label: Text('Numero de Sub-Pregunta', style: TextStyle(fontSize: 23.0))),
                          DataColumn(label: Text('Sub-Pregunta', style: TextStyle(fontSize: 23.0))),
                          DataColumn(label: Text('Respuesta', style: TextStyle(fontSize: 23.0))),
                          DataColumn(label: Text('Comentarios', style: TextStyle(fontSize: 23.0))),
                          DataColumn(label: Text('Justificacion', style: TextStyle(fontSize: 23.0))),
                        ], 
                        rows: answerData.map((answer) {
                          return DataRow(
                            cells: [
                              DataCell(answer.sp_IdUsuarios != null ? Text(answer.sp_IdUsuarios!, style: const TextStyle(fontSize: 20.0)) : const Text('')),
                              DataCell(answer.sp_Cedula != null ? Text(answer.sp_Cedula!, style: const TextStyle(fontSize: 20.0)) : const Text('')),
                              DataCell(answer.sp_NombreApellido != null ? Text(answer.sp_NombreApellido!, style: const TextStyle(fontSize: 20.0)) : const Text('')),
                              DataCell(answer.sp_Usuarios != null ? Text(answer.sp_Usuarios!, style: const TextStyle(fontSize: 20.0)) : const Text('')),
                              DataCell(answer.sp_NoEncuesta != null ? Text(answer.sp_NoEncuesta!, style: const TextStyle(fontSize: 20.0)) : const Text('')),
                              DataCell(Text(answer.sp_IdSesion.toString(), style: const TextStyle(fontSize: 20.0))),
                              DataCell(Text(answer.sp_CodPreguntas.toString(), style: const TextStyle(fontSize: 20.0))),
                              DataCell(answer.sp_Preguntas != null ? Text(answer.sp_Preguntas!, style: const TextStyle(fontSize: 20.0)) : const Text('')),
                              DataCell(answer.sp_CodSupPreguntas != null ? Text(answer.sp_CodSupPreguntas!, style: const TextStyle(fontSize: 20.0)) : const Text('')),
                              DataCell(answer.sp_SupPreguntas != null ? Text(answer.sp_SupPreguntas!, style: const TextStyle(fontSize: 20.0)) : const Text('')),
                              DataCell(answer.sp_Respuestas != null ? Text(answer.sp_Respuestas!, style: const TextStyle(fontSize: 20.0)) : const Text('')),
                              DataCell(answer.sp_Comentarios != null ? Text(answer.sp_Comentarios!, style: const TextStyle(fontSize: 20.0)) : const Text('')),
                              DataCell(answer.sp_Justificacion != null ? Text(answer.sp_Justificacion!, style: const TextStyle(fontSize: 20.0)) : const Text('')),
                            ]
                          );
                        }).toList(),
                      ),
                    ),
                  );
                }
              }
            ),
          ),
        ]
      )
    );
  }
}