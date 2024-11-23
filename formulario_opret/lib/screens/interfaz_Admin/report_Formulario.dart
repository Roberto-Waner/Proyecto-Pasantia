import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:formulario_opret/models/Stored%20Procedure/sp_Filtrar_FormRegistro.dart';
import 'package:formulario_opret/screens/interfaz_Admin/navbar/navbar.dart';
import 'package:formulario_opret/services/form_Registro_services.dart';

class ReportFormulario extends StatefulWidget {
  final TextEditingController filtrarUsuarioController;
  final TextEditingController filtrarEmailController;
  final TextEditingController filtrarId;
  final TextEditingController filtrarCedula;

  const ReportFormulario({
    super.key,
    required this.filtrarId,
    required this.filtrarCedula,
    required this.filtrarUsuarioController,
    required this.filtrarEmailController,
  });

  @override
  State<ReportFormulario> createState() => _ReportFormularioState();
}

class _ReportFormularioState extends State<ReportFormulario> {
  final ApiServiceFormRegistro _apiServiceFormRegistro = ApiServiceFormRegistro('https://10.0.2.2:7190');
  late Future<List<SpFiltrarFormRegistro>> _formRegistroData;
  final TextEditingController searchController = TextEditingController();
  List<SpFiltrarFormRegistro> formFiltrados = [];
  List<SpFiltrarFormRegistro> todosCampForm = [];

  @override
  void initState() {
    super.initState();
    _formRegistroData = Future.value([]);
    _formRegistroData = _apiServiceFormRegistro.getFormRegistro();
    _refreshFormularios();
  }

  Future<void> _refreshFormularios() async {
    final form = await _apiServiceFormRegistro.getFormRegistro();
    setState(() {
      todosCampForm = form;
      formFiltrados = form;
      _formRegistroData = Future.value(form);
    });
  }

  void _filtrarForm(String query) async {
    final filtrar = todosCampForm.where((formulario) {
      final queryLower = query.toLowerCase();
      return (formulario.sp_IdUsuarios?.toLowerCase().contains(queryLower) ?? false) ||
            (formulario.sp_Cedula?.toLowerCase().contains(queryLower) ?? false) ||
            (formulario.sp_Usuarios?.toLowerCase().contains(queryLower) ?? false) ||
            (formulario.sp_NombreApellido?.toLowerCase().contains(queryLower) ?? false);
    }).toList();

    setState(() {
      formFiltrados = filtrar;
    });
  }

  void _limpiarBusqueda() {
    searchController.clear();
    setState(() {
      formFiltrados = todosCampForm;
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
        title: const Text('Tablas de Formularios'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, size: 30.0),
            tooltip: 'Recargar',
            onPressed: () {
              setState(() {
                _refreshFormularios();
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
                    _filtrarForm(value); 
                  } else { 
                    setState(() { 
                      formFiltrados = []; 
                    }); 
                  } 
                },
              )
            )
          ),
          Expanded(
            child: FutureBuilder<List<SpFiltrarFormRegistro>>(
              future: _formRegistroData, 
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting){
                  return const Center(child: CircularProgressIndicator());
                }else if (snapshot.hasError){
                  return Center(child: Text('Error al cargar los datos: ${snapshot.error}'));
                } else {
                  final formularioData = formFiltrados.isNotEmpty
                        ? formFiltrados
                        : snapshot.data ?? [];

                  return SingleChildScrollView(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text('ID del Usuario', style: TextStyle(fontSize: 23.0))),
                          DataColumn(label: Text('Cedula de Identidad', style: TextStyle(fontSize: 23.0))),
                          DataColumn(label: Text('Usuarios', style: TextStyle(fontSize: 23.0))),
                          DataColumn(label: Text('Nombre y Apellido', style: TextStyle(fontSize: 23.0))),
                          DataColumn(label: Text('Fecha de form. Realizado', style: TextStyle(fontSize: 23.0))),
                          DataColumn(label: Text('Hora', style: TextStyle(fontSize: 23.0))),
                          DataColumn(label: Text('Linea de metro', style: TextStyle(fontSize: 23.0))),
                          DataColumn(label: Text('Estacion de metro', style: TextStyle(fontSize: 23.0))),
                          // DataColumn(label: Text('Accion', style: TextStyle(fontSize: 23.0)))
                        ], 
                        rows: formularioData.map((form) {
                          return DataRow(
                            cells: [
                              DataCell(Text(form.sp_IdUsuarios!, style: const TextStyle(fontSize: 20.0))),
                              DataCell(Text(form.sp_Cedula!, style: const TextStyle(fontSize: 20.0))),
                              DataCell(Text(form.sp_Usuarios!, style: const TextStyle(fontSize: 20.0))),
                              DataCell(Text(form.sp_NombreApellido!, style: const TextStyle(fontSize: 20.0))),
                              DataCell(Text(form.sp_FechaEncuesta!, style: const TextStyle(fontSize: 20.0))),
                              DataCell(Text(form.sp_HoraEncuesta!, style: const TextStyle(fontSize: 20.0))),
                              DataCell(Text(form.sp_NombreLinea!, style: const TextStyle(fontSize: 20.0))),
                              DataCell(Text(form.sp_NombrEstacion!, style: const TextStyle(fontSize: 20.0))),
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