import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:formulario_opret/models/pregunta.dart';
import 'package:formulario_opret/screens/interfaz_Admin/navbar/navbar.dart';
import 'package:formulario_opret/services/pregunta_services.dart';
import 'package:formulario_opret/widgets/input_decoration.dart';

class PreguntaScreenNavbar extends StatefulWidget {
  final TextEditingController filtrarUsuarioController;
  final TextEditingController filtrarEmailController;
  final TextEditingController filtrarId;
  final TextEditingController filtrarCedula;

  const PreguntaScreenNavbar({
    super.key,
    required this.filtrarId,
    required this.filtrarCedula,
    required this.filtrarUsuarioController,
    required this.filtrarEmailController,
  });

  @override
  State<PreguntaScreenNavbar> createState() => _PreguntaScreenNavbarState();
}

class _PreguntaScreenNavbarState extends State<PreguntaScreenNavbar> {
  final ApiServicePreguntas _apiServicePreguntas = ApiServicePreguntas('https://10.0.2.2:7002');
  late Future<List<Pregunta>> _preguntas;

  @override
  void initState(){
    super.initState();
    _preguntas = _apiServicePreguntas.getPreguntas();
  }

  void _refreshPreguntas() {
    setState(() {
      _preguntas = _apiServicePreguntas.getPreguntas();
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
      appBar: AppBar(title: const Text('Sesion de Preguntas')),
      body: FutureBuilder<List<Pregunta>>(
        future: _preguntas,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }else if(snapshot.hasError) {
            return const Center(child: Text('Error al cargar la Sesion de Preguntas.', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)));
          }else {
            final question = snapshot.data ?? [];

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('No', style: TextStyle(fontSize: 23.0))),
                  DataColumn(label: Text('Preguntas', style: TextStyle(fontSize: 23.0))),
                  DataColumn(label: Text('Accion', style: TextStyle(fontSize: 23.0)))
                ],
                rows: question.map((ask) {
                  return DataRow(
                    cells: [
                      DataCell(Text(ask.idPreguntas.toString() , style: const TextStyle(fontSize: 20.0))), // Conversión explícita de int a String usando .toString()
                      DataCell(Text(ask.preguntas, style: const TextStyle(fontSize: 20.0))),
                      DataCell(
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                _showEditDialog(ask);
                              }, 
                              icon: const Icon(Icons.edit)
                            ),
                            
                            IconButton(
                              onPressed: () {
                                _showDeleteDialog(ask);
                              },
                              icon: const Icon(Icons.delete)
                            )
                          ],
                        )
                      )
                    ]
                  );
                }).toList(),
              ),
            );
          }
        }
      ),
      floatingActionButton: FloatingActionButton( //aqui se crea un boton flotante para agregar
        onPressed: () {
          _showCreateDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showCreateDialog() {
    final formKey = GlobalKey<FormBuilderState>();

    showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
          title: const Text('Crear Pregunta', style: TextStyle(fontSize: 33.0)),
          contentPadding: EdgeInsets.zero,
          content: Container(
            margin: const EdgeInsets.fromLTRB(90, 20, 90, 50),  // Aplica margen
            width: 500,
            child: FormBuilder(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FormBuilderTextField(
                    name: 'no',
                    decoration: InputDecorations.inputDecoration(
                      labeltext: 'Numero de la Pregunta',
                      labelFrontSize: 30.5,
                      hintext: '#',
                      hintFrontSize: 30.0,
                      icono: const Icon(Icons.numbers,size: 30.0),
                    ),
                    style: const TextStyle(fontSize: 30.0),
                    validator: FormBuilderValidators.numeric(errorText: 'Este campo es requerido')
                  ),
                  
                  FormBuilderTextField(
                    name: 'pregunta',
                    decoration: InputDecorations.inputDecoration(
                      labeltext: 'Ingresar la Pregunta',
                      labelFrontSize: 30.5,
                      hintext: '¿Agregar preguntas?',
                      hintFrontSize: 30.0,
                      icono: const Icon(Icons.question_mark_outlined,size: 30.0),
                    ),
                    style: const TextStyle(fontSize: 30.0),
                    validator: FormBuilderValidators.required(errorText: 'Este campo es requerido')
                  ),
                ],
              )
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (formKey.currentState!.saveAndValidate()) {
                  final formData = formKey.currentState!.value;
                  Pregunta nuevaPregunta = Pregunta(
                    idPreguntas: int.tryParse(formData['no']) ?? 0, //aqui tambien se debe de combertir el tipo de dato que debe de recibir
                    preguntas: formData['pregunta']
                  );

                  try{
                    final response = await ApiServicePreguntas('https://10.0.2.2:7002').postPreguntas(nuevaPregunta);

                    if(response.statusCode == 201) {
                      print('La pregunta fue creado con éxito');
                      Navigator.of(context).pop();
                      _refreshPreguntas();
                    } else {
                      print('Error al crear la pregunta: ${response.body}');
                    }
                  } catch (e) {
                    print('Excepción al crear la pregunta: $e');
                  }
                }
              },
              child: const Text('Crear', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold))
            )
          ],
        );
      }
    );
  }

  void _showEditDialog(Pregunta questionUpLoad) {
    final formKey = GlobalKey<FormBuilderState>();

    showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
          title: const Text('Modificar Pregunta', style: TextStyle(fontSize: 33.0)),
          contentPadding: EdgeInsets.zero,
          content: Container(
            margin: const EdgeInsets.fromLTRB(90, 20, 90, 50),
            child: FormBuilder(
              key: formKey,
              initialValue: {
                // 'no': questionUpLoad.idPreguntas.toString(),
                'pregunta': questionUpLoad.preguntas,
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // FormBuilderTextField(
                  //   name: 'no',
                  //   decoration: InputDecorations.inputDecoration(
                  //     labeltext: 'Numero de la Pregunta',
                  //     labelFrontSize: 30.5,
                  //     hintext: '#',
                  //     hintFrontSize: 30.0,
                  //     icono: const Icon(Icons.numbers,size: 30.0),
                  //   ),
                  //   style: const TextStyle(fontSize: 30.0),
                  // ),

                  FormBuilderTextField(
                    name: 'pregunta',
                    decoration: InputDecorations.inputDecoration(
                      labeltext: 'Ingresar la Pregunta',
                      labelFrontSize: 30.5,
                      hintext: '¿Agregar preguntas?',
                      hintFrontSize: 30.0,
                      icono: const Icon(Icons.question_mark_outlined,size: 30.0),
                    ),
                    style: const TextStyle(fontSize: 30.0),
                    validator: FormBuilderValidators.required(errorText: 'Este campo es requerido')
                  ),
                ],
              )
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if(formKey.currentState!.saveAndValidate()){
                  final formData = formKey.currentState!.value;
                  Pregunta askUpLoad = Pregunta(
                    idPreguntas: questionUpLoad.idPreguntas.toInt(), 
                    preguntas: formData['pregunta']
                  );

                  try{
                    final response = await ApiServicePreguntas('https://10.0.2.2:7002')
                      .putPreguntas(questionUpLoad.idPreguntas, askUpLoad);

                    if(response.statusCode == 204) {
                      print('La pregunta fue modificada con éxito');
                      Navigator.of(context).pop();
                      _refreshPreguntas();
                    } else {
                      print('Error al modificar la pregunta: ${response.body}');
                    }
                  } catch (e) {
                    print('Excepción al modificar la pregunta: $e');
                  }
                }
              }, 
              child: const Text('Editar', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold))
            )
          ]
        );
      }
    );
  }

  void _showDeleteDialog(Pregunta questionDelete) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Eliminar Pregunta', style: TextStyle(fontSize: 33.0)),
          contentPadding: const EdgeInsets.fromLTRB(70, 30, 70, 50),
          content: Text('¿Estás seguro de que deseas eliminar la pregunta numero: ${questionDelete.idPreguntas}?', style: const TextStyle(fontSize: 30)),
          actions: [
            TextButton(
              child: const Text('Cancelar', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo si se cancela
              },
            ),
            TextButton(
              child: const Text('Eliminar', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              onPressed: () async {
                // Llamar al servicio de eliminación
                try {
                  final response = await ApiServicePreguntas('https://10.0.2.2:7002')
                      .deletePreguntas(questionDelete.idPreguntas);
                  if (response.statusCode == 204) {
                    print('Pregunta eliminado con éxito');
                    Navigator.of(context).pop(); // Cerrar el diálogo después de la eliminación
                    // Refrescar la lista de usuarios aquí
                    _refreshPreguntas();
                  } else {
                    print('Error al eliminar la pregunta: ${response.body}');
                  }
                } catch (e) {
                  print('Excepción al eliminar la pregunta: $e');
                }
              },
            ),
          ],
        );
      }
    );
  }
}