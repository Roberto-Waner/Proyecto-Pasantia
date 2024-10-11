import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:formulario_opret/models/pregunta.dart';
import 'package:formulario_opret/screens/interfaz_Admin/navbar/navbar.dart';
import 'package:formulario_opret/services/pregunta_services.dart';
import 'package:formulario_opret/services/rango_Respuesta_services.dart';
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
  final ApiServicePreguntas _apiServicePreguntas = ApiServicePreguntas('https://10.0.2.2:7190');
  late Future<List<Pregunta>> _preguntas;
  final ApiServiceRangoResp _apiServiceRangoResp = ApiServiceRangoResp('https://10.0.2.2:7190');
  late Future<List<RangoRespuestas>> _rangoRespuestas;

  final _formKey = GlobalKey<FormBuilderState>();

  final tipoRespuestaController = TextEditingController();
  List<String> selectedValues = [];
  int _rangoValor = 1;

  // Variable para almacenar el color original y temporal del FloatingActionButton
  Color _fabColor = const Color.fromARGB(255, 156, 223, 168);
  final Color _pressedColor = const Color.fromARGB(255, 10, 186, 43);

  @override
  void initState(){
    super.initState();
    _preguntas = _apiServicePreguntas.getPreguntas();
    _rangoRespuestas = _apiServiceRangoResp.getRangoResp();
  }

  void _refreshPreguntas() {
    setState(() {
      _preguntas = _apiServicePreguntas.getPreguntas();
    });
  }

  void _refreshTipoRespuestas() {
    setState(() {
      _rangoRespuestas = _apiServiceRangoResp.getRangoResp();
    });
  }

  // Función para restaurar el color original del FloatingActionButton
  void _resetFabColor() {
    setState(() {
      _fabColor = const Color.fromARGB(255, 156, 223, 168); // Vuelve al color original
    });
  }

  // Función para cambiar temporalmente el color al presionar el botón
  void _onFabPressed() {
    setState(() {
      _fabColor = _pressedColor; // Cambia al color cuando se presiona
    });
  }

  void _registroRango() async {
    if(_formKey.currentState!.saveAndValidate()) {
      final dataRango = _formKey.currentState!.value;

      RangoRespuestas rangoRespuestas = RangoRespuestas(
        // idTipRespuesta: int.tryParse(dataTipResp['idTipRespuesta']) ?? 0,
        rango: dataRango['rango']
      );

      try{
        final response = await ApiServiceRangoResp('https://10.0.2.2:7190').postRangoResp(rangoRespuestas);
        if(response.statusCode == 201) {
          print('El Tipo de Respuesta fue creado con éxito');
          Navigator.of(context).pop();
          _refreshTipoRespuestas();
        } else {
          print('Error al crear Tipo de Respuesta: ${response.body}');
        }
      } catch (e) {
        print('Excepción al crear el tipo de respuesta: $e');
      }
    }
  }

  void _registroPregunta() async {
    if(_formKey.currentState!.saveAndValidate()) {
      final dataPreg = _formKey.currentState!.value;

      Pregunta nuevaPregunta = Pregunta(
        noPregunta: int.tryParse(dataPreg['no']) ?? 0, 
        tipoRespuesta: dataPreg['tipoRespuesta'],
        gurpoTema: dataPreg['gurpoTema'],
        pregunta1: dataPreg['pregunta'],
        idSubPregunta: int.tryParse(dataPreg['idSubPregunta']?.toString() ?? '0') ?? 0, // Convierte a string primero, luego parsea, maneja null
        idRango: int.tryParse(dataPreg['idRango']?.toString() ?? '0') ?? 0 // Convierte a string primero, luego parsea, maneja null
      );

      try{
        final response = await ApiServicePreguntas('https://10.0.2.2:7190').postPreguntas(nuevaPregunta);

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
  }

  void _actualizarRango(RangoRespuestas upLoad) async {
    if(_formKey.currentState!.saveAndValidate()) {
      final dataRango = _formKey.currentState!.value;
      RangoRespuestas upLoadRango = RangoRespuestas(
        idRango: upLoad.idRango,
        rango: dataRango['rango']?.toString(),
      );

      try{
        final response = await ApiServiceRangoResp('https://10.0.2.2:7190').putRangoResp(upLoad.idRango!, upLoadRango);

        if(response.statusCode == 204) {
          print('El rango fue modificada con éxito');
          Navigator.of(context).pop();
          _refreshTipoRespuestas();
          
        } else {
          print('Error al modificar el tipo de respuesta: ${response.body}');
        }
      } catch (e) {
        print('Excepción al modificar el tipo de respuesta: $e');
      }
    }
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Text(
              'Tablas de Preguntas',
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            FutureBuilder<List<Pregunta>>(
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
                        DataColumn(label: Text('Tipo de Respuesta', style: TextStyle(fontSize: 23.0))),
                        DataColumn(label: Text('Tema', style: TextStyle(fontSize: 23.0))),
                        DataColumn(label: Text('Preguntas', style: TextStyle(fontSize: 23.0))),
                        DataColumn(label: Text('ID de Sub. Pregunta', style: TextStyle(fontSize: 23.0))),
                        DataColumn(label: Text('Identificador de Rango', style: TextStyle(fontSize: 23.0))),
                        DataColumn(label: Text('Accion', style: TextStyle(fontSize: 23.0)))
                      ],
                      rows: question.map((ask) {
                        return DataRow(
                          cells: [
                            DataCell(Text(ask.noPregunta.toString(), style: const TextStyle(fontSize: 20.0))), // Conversión explícita de int a String usando .toString()
                            DataCell(Text(ask.tipoRespuesta, style: const TextStyle(fontSize: 20.0))),
                            DataCell(ask.gurpoTema != null ? Text(ask.gurpoTema!, style: const TextStyle(fontSize: 20.0)) : const Text('')),
                            DataCell(ask.pregunta1 != null ? Text(ask.pregunta1!, style: const TextStyle(fontSize: 20.0)) : const Text('')),
                            DataCell(Text(ask.idSubPregunta.toString(), style: const TextStyle(fontSize: 20.0))),
                            DataCell(Text(ask.idRango.toString(), style: const TextStyle(fontSize: 20.0))),
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
            const SizedBox(height: 20),
            const Text(
              'Tablas de Rangos',
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
            ),
            FutureBuilder<List<RangoRespuestas>>(
              future: _rangoRespuestas,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }else if (snapshot.hasError) {
                  return const Center(child: Text('Error al cargar la Sesion de los Rango.', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)));
                } else {
                  final rangoResp = snapshot.data ?? [];

                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('No', style: TextStyle(fontSize: 23.0))),
                        DataColumn(label: Text('Rango', style: TextStyle(fontSize: 23.0))),
                        DataColumn(label: Text('Accion', style: TextStyle(fontSize: 23.0)))
                      ], 
                      rows: rangoResp.map((rango) {
                        return DataRow(
                          cells: [
                            DataCell(Text(rango.idRango.toString(), style: const TextStyle(fontSize: 20.0))),
                            DataCell(rango.rango != null ? Text(rango.rango!, style: const TextStyle(fontSize: 20.0)) : const Text('')),
                            DataCell(
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      _showEditDialogRangoRespuesta(rango);
                                    }, 
                                    icon: const Icon(Icons.edit)
                                  ),
                                  
                                  IconButton(
                                    onPressed: () {
                                      _showDeleteDialogRangoResp(rango);
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
            )
          ]
        ),
      ),
      floatingActionButton: Stack(
        children: [
          // Primer botón flotante - Preguntas
          Positioned(
            bottom: 80,
            right: 10,
            child: GestureDetector(
              onTapDown: (_) {
                _onFabPressed(); // Cambia el color cuando se presiona
              },
              onTapUp: (_) {
                _resetFabColor(); // Vuelve al color original cuando se suelta
              },
              onTapCancel: () {
                _resetFabColor(); // Si se cancela la presión (se arrastra el dedo fuera), también vuelve al color original
              },
              child: FloatingActionButton.extended( //aqui se crea un boton flotante para agregar
                backgroundColor: _fabColor, // Usamos la variable de estado _fabColor
                onPressed: () {
                  _showCreateDialog();
                  _onFabPressed(); // Cambia el color al hacer clic
                },
                heroTag: "pregunta",
                icon: const Icon(Icons.add),
                label: const Text('Agregar Pregunta')
              ),
            ),
          ),
          // Segundo botón flotante - Tipo de Respuestas
          Positioned(
            bottom: 10,
            right: 10,
            child: GestureDetector(
              onTapDown: (_) {
                _onFabPressed(); // Cambia el color cuando se presiona
              },
              onTapUp: (_) {
                _resetFabColor(); // Vuelve al color original cuando se suelta
              },
              onTapCancel: () {
                _resetFabColor(); // Si se cancela la presión (se arrastra el dedo fuera), también vuelve al color original
              },
              child: FloatingActionButton.extended( //aqui se crea un boton flotante para agregar
                backgroundColor: _fabColor, // Usamos la variable de estado _fabColor
                onPressed: () {
                  _showCreateDialogRangoRespuestas();
                  _onFabPressed(); // Cambia el color al hacer clic
                },
                heroTag: "tipRespuestas",
                icon: const Icon(Icons.add),
                label: const Text('Agregar tipo Respuesta')
              ),
            ),
          )
        ]
      ),
    );
  }

  void _showCreateDialog() {
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
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FormBuilderTextField(
                    name: 'no',
                    keyboardType: TextInputType.number,
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
                    name: 'tipoRespuesta',
                    decoration: InputDecorations.inputDecoration(
                      labeltext: 'Tipo de Respuesta',
                      labelFrontSize: 30.5,
                      hintext: 'Como se respondera esta pregunta',
                      hintFrontSize: 30.0,
                      icono: const Icon(Icons.numbers,size: 30.0),
                    ),
                    style: const TextStyle(fontSize: 30.0),
                    validator: FormBuilderValidators.required(errorText: 'Este campo es requerido')
                  ),

                  FormBuilderTextField(
                    name: 'gurpoTema',
                    decoration: InputDecorations.inputDecoration(
                      labeltext: 'Tema',
                      labelFrontSize: 30.5,
                      hintext: ' ',
                      hintFrontSize: 30.0,
                      icono: const Icon(Icons.numbers,size: 30.0),
                    ),
                    style: const TextStyle(fontSize: 30.0),
                    // validator: FormBuilderValidators.required(errorText: 'Este campo es requerido')
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

                  FormBuilderTextField(
                    name: 'idSubPregunta',
                    decoration: InputDecorations.inputDecoration(
                      labeltext: 'ID de Sub. Pregunta',
                      labelFrontSize: 30.5,
                      hintext: 'Asipnar el id de la sub. pregunta',
                      hintFrontSize: 30.0,
                      icono: const Icon(Icons.numbers,size: 30.0),
                    ),
                    style: const TextStyle(fontSize: 30.0),
                    // validator: FormBuilderValidators.required(errorText: 'Este campo es requerido')
                  ),

                  FormBuilderTextField(
                    name: 'idRango',
                    keyboardType: TextInputType.number,
                    decoration: InputDecorations.inputDecoration(
                      labeltext: 'Identificador de Rango',
                      labelFrontSize: 30.5,
                      hintext: '#',
                      hintFrontSize: 30.0,
                      icono: const Icon(Icons.numbers,size: 30.0),
                    ),
                    style: const TextStyle(fontSize: 30.0),
                    // validator: FormBuilderValidators.numeric(errorText: 'Este campo es requerido')
                  ),
                ],
              )
            ),
          ),
          actions: [
            TextButton(
              onPressed: _registroPregunta,
              child: const Text('Crear', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold))
            )
          ],
        );
      }
    );
  }

  void _showCreateDialogRangoRespuestas() {
    
    showDialog(
      context: context, 
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Determinar el Rango requerido', style: TextStyle(fontSize: 33.0)),
              contentPadding: EdgeInsets.zero,
              content: FormBuilder(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    
                    FormBuilderTextField(
                      name: 'rango',
                      controller: tipoRespuestaController,
                      decoration: InputDecorations.inputDecoration(
                        labeltext: 'Rango',
                        labelFrontSize: 30.5,
                        hintext: 'Determinar el Rango de la Respuestas',
                        hintFrontSize: 30.0,
                        icono: const Icon(Icons.question_answer,size: 30.0),
                      ),
                      style: const TextStyle(fontSize: 30.0),
                      validator: FormBuilderValidators.required(errorText: 'Este campo es requerido'),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Slider(
                            value: _rangoValor.toDouble(),
                            min: 1,
                            max: 10,
                            divisions: 10,
                            label: _rangoValor.toString(),
                            onChanged: (double valor) {
                              setState(() {
                                _rangoValor = valor.toInt();
                                String valorString = _rangoValor.toString();

                                // Si el valor no está en la lista, lo añadimos.
                                if (!selectedValues.contains(valorString)) {
                                  selectedValues.add(valorString);
                                } else {
                                  // Si el valor ya está en la lista y se ha reducido, lo quitamos.
                                  selectedValues.remove(valorString);
                                }

                                // Ordenar la lista de valores seleccionados
                                selectedValues.sort((a, b) => int.parse(a).compareTo(int.parse(b)));

                                // Actualizar el campo de texto con los valores concatenados
                                tipoRespuestaController.text = selectedValues.join(' | ');
                              });
                            }
                          ),
                        ],
                      )
                    )
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    // Validar el formulario antes de proceder
                    if (_formKey.currentState!.validate()) {
                      _registroRango();
                      Navigator.of(context).pop(); // Cerrar el diálogo
                    }
                  }, 
                  child: const Text('Crear', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold))
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Cerrar el diálogo sin realizar acción
                  }, 
                  child: const Text('Cancelar', style: TextStyle(fontSize: 30)),
                ),
              ],
            );
          }
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
                'tipoRespuesta': questionUpLoad.tipoRespuesta,
                'gurpoTema': questionUpLoad.gurpoTema,
                'pregunta': questionUpLoad.pregunta1,
                'idSubPregunta': questionUpLoad.idSubPregunta,
                'idRango': questionUpLoad.idRango
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FormBuilderTextField(
                    name: 'tipoRespuesta',
                    decoration: InputDecorations.inputDecoration(
                      labeltext: 'Tipo de Respuesta',
                      labelFrontSize: 30.5,
                      hintext: 'Como se respondera esta pregunta',
                      hintFrontSize: 30.0,
                      icono: const Icon(Icons.numbers,size: 30.0),
                    ),
                    style: const TextStyle(fontSize: 30.0),
                    validator: FormBuilderValidators.required(errorText: 'Este campo es requerido')
                  ),

                  FormBuilderTextField(
                    name: 'gurpoTema',
                    decoration: InputDecorations.inputDecoration(
                      labeltext: 'Tema',
                      labelFrontSize: 30.5,
                      hintext: ' ',
                      hintFrontSize: 30.0,
                      icono: const Icon(Icons.numbers,size: 30.0),
                    ),
                    style: const TextStyle(fontSize: 30.0),
                    // validator: FormBuilderValidators.required(errorText: 'Este campo es requerido')
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

                  FormBuilderTextField(
                    name: 'idSubPregunta',
                    decoration: InputDecorations.inputDecoration(
                      labeltext: 'ID de Sub. Pregunta',
                      labelFrontSize: 30.5,
                      hintext: 'Asipnar el id de la sub. pregunta',
                      hintFrontSize: 30.0,
                      icono: const Icon(Icons.numbers,size: 30.0),
                    ),
                    style: const TextStyle(fontSize: 30.0),
                    // validator: FormBuilderValidators.required(errorText: 'Este campo es requerido')
                  ),

                  FormBuilderTextField(
                    name: 'idRango',
                    decoration: InputDecorations.inputDecoration(
                      labeltext: 'Identificador de Rango',
                      labelFrontSize: 30.5,
                      hintext: '#',
                      hintFrontSize: 30.0,
                      icono: const Icon(Icons.numbers,size: 30.0),
                    ),
                    style: const TextStyle(fontSize: 30.0),
                    // validator: FormBuilderValidators.required(errorText: 'Este campo es requerido')
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
                    noPregunta: questionUpLoad.noPregunta.toInt(),
                    tipoRespuesta: formData['tipoRespuesta'],
                    gurpoTema: formData['gurpoTema'],
                    pregunta1: formData['pregunta'],
                    idSubPregunta: formData['idSubPregunta'] ?? 0,
                    idRango: formData['idRango'] ?? 0
                  );

                  try{
                    final response = await ApiServicePreguntas('https://10.0.2.2:7190')
                      .putPreguntas(questionUpLoad.noPregunta, askUpLoad);

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

  void _showEditDialogRangoRespuesta(RangoRespuestas rangoRespUpLoad) {
    showDialog(
      context: context, 
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Modificar Tipos de Respuesta', style: TextStyle(fontSize: 33.0)),
              contentPadding: EdgeInsets.zero,
              content: Container(
                margin: const EdgeInsets.fromLTRB(90, 20, 90, 50),
                child: FormBuilder(
                  key: _formKey,
                  initialValue: {
                    'rango': rangoRespUpLoad.rango,           
                  },
                  child: Column(
                    children: [
                      FormBuilderTextField(
                        name: 'rango',
                        controller: tipoRespuestaController,
                        decoration: InputDecorations.inputDecoration(
                          labeltext: 'Rango',
                          labelFrontSize: 30.5,
                          hintext: 'Determinar el Rango de la Respuestas',
                          hintFrontSize: 30.0,
                          icono: const Icon(Icons.question_answer,size: 30.0),
                        ),
                        style: const TextStyle(fontSize: 30.0),
                        validator: FormBuilderValidators.required(errorText: 'Este campo es requerido'),
                        onChanged: (value) {
                          List<String> respuestas = value!.split(' ');
                          print(respuestas);
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Determina el Rango',
                              style: TextStyle(fontSize: 30.0),
                            ),
                            Slider(
                              value: _rangoValor.toDouble(),
                              min: 1,
                              max: 10,
                              divisions: 9,
                              label: _rangoValor.toString(),
                              onChanged: (double valor) {
                                setState(() {
                                  _rangoValor = valor.toInt();
                                  String valorString = _rangoValor.toString();

                                  // Si el valor no está en la lista, lo añadimos.
                                  if (!selectedValues.contains(valorString)) {
                                    selectedValues.add(valorString);
                                  } else {
                                    // Si el valor ya está en la lista y se ha reducido, lo quitamos.
                                    selectedValues.remove(valorString);
                                  }

                                  // Ordenar la lista de valores seleccionados
                                  selectedValues.sort((a, b) => int.parse(a).compareTo(int.parse(b)));

                                  // Actualizar el campo de texto con los valores concatenados
                                  tipoRespuestaController.text = selectedValues.join(' | ');
                                });
                              }
                            )
                          ],
                        )
                      )
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    _actualizarRango(rangoRespUpLoad);
                  },
                  child: const Text('Editar', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold))
                )
              ],
            );
          }
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
          content: Text('¿Estás seguro de que deseas eliminar la pregunta numero: ${questionDelete.noPregunta}?', style: const TextStyle(fontSize: 30)),
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
                  final response = await ApiServicePreguntas('https://10.0.2.2:7190')
                      .deletePreguntas(questionDelete.noPregunta);
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

  void _showDeleteDialogRangoResp(RangoRespuestas rangoRespDelete) {
    showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
          title: const Text('Eliminar el Rango', style: TextStyle(fontSize: 33.0)),
          contentPadding: const EdgeInsets.fromLTRB(70, 30, 70, 50),
          content: Text('¿Estás seguro de que deseas eliminar el Rango enumerado como: ${rangoRespDelete.idRango}?', style: const TextStyle(fontSize: 30)),
          actions: [
            TextButton(
              child: const Text('Cancelar', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo si se cancela
              }
            ),
            TextButton(
              child: const Text('Eliminar', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              onPressed: () async {
                try{
                  final response = await ApiServiceRangoResp('https://10.0.2.2:7190')
                    .deleteRangoResp(rangoRespDelete.idRango!);

                  if (response.statusCode == 204) {
                    print('Rango eliminado con éxito');
                    Navigator.of(context).pop(); // Cerrar el diálogo después de la eliminación
                    // Refrescar la lista de usuarios aquí
                    _refreshTipoRespuestas();
                  } else {
                    print('Error al eliminar el Rango: ${response.body}');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Error al eliminar el Rango'))
                    );
                  }
                } catch (e) {
                  print('Excepción al eliminar el Rango: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Error al eliminar el Rango'))
                  );
                }                
              }
            ),
          ],
        );
      }
    );
  }
}

// FormBuilderTextField(
//   name: 'idTipRespuesta',
//   keyboardType: TextInputType.number,
//   decoration: InputDecorations.inputDecoration(
//     labeltext: 'Numero del Tipo de Respuesta',
//     labelFrontSize: 30.5,
//     hintext: '#',
//     hintFrontSize: 30.0,
//     icono: const Icon(Icons.numbers,size: 30.0),
//   ),
//   style: const TextStyle(fontSize: 30.0),
//   validator: FormBuilderValidators.numeric(errorText: 'Este campo es requerido')
// ),

// onChanged: (value) {
//   List<String> respuestas = value!.split(' ');
//   print(respuestas);
// },