import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:formulario_opret/models/Stored%20Procedure/sp_preguntasCompleta.dart';
import 'package:formulario_opret/models/pregunta.dart';
import 'package:formulario_opret/models/respuesta.dart';
import 'package:formulario_opret/screens/interfaz_User/navbarUser/navbar_Empl.dart';
import 'package:formulario_opret/services/pregunta_services.dart';
import 'package:formulario_opret/services/respuestas_services.dart';

class PreguntaEncuestaScreen extends StatefulWidget {
  final TextEditingController filtrarUsuarioController;
  final TextEditingController filtrarEmailController;
  final TextEditingController filtrarId;
  final TextEditingController filtrarCedula;
  final TextEditingController noEncuestaFiltrar;

  const PreguntaEncuestaScreen({
    super.key,
    required this.noEncuestaFiltrar,
    required this.filtrarUsuarioController,
    required this.filtrarEmailController,
    required this.filtrarId,
    required this.filtrarCedula, 
  });

  @override
  State<PreguntaEncuestaScreen> createState() => _PreguntaEncuestaScreenState();
}

class _PreguntaEncuestaScreenState extends State<PreguntaEncuestaScreen> {
  final ApiServicePreguntas _apiQuestions = ApiServicePreguntas('https://10.0.2.2:7190');
  final ApiServiceRespuesta _apiRespuesta = ApiServiceRespuesta('https://10.0.2.2:7190');
  late List<SpPreguntascompleta> dataQuestion = []; //para la llamada de los datos
  final _formKey = GlobalKey<FormBuilderState>();
  List<bool> _isExpandedList = []; //una lista de booleanos para controlar si cada Card está expandido o no.

  @override
  void initState() {
    super.initState();
    _refreshPreguntas(); //utilizado para cargar los datos al cargar la pagina y se cargan los datos
  }

  void _refreshPreguntas() async {
    dataQuestion = await _apiQuestions.getSpPreguntascompletaListada();
    setState(() {
      _isExpandedList = List<bool>.filled(dataQuestion.length, false);
    }); //se usar para actualizar el arbol de widget cuando se cambien los datos
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavbarEmpl(
        filtrarUsuarioController: widget.filtrarUsuarioController,  
        filtrarEmailController: widget.filtrarEmailController,
        filtrarId: widget.filtrarId,
        filtrarCedula: widget.filtrarCedula,
      ),

      appBar: AppBar(title: const Text('Preguntas de Encuesta')),

      body: dataQuestion.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.all(28.0),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: dataQuestion.length,
              physics: const NeverScrollableScrollPhysics(), // Evita conflictos de desplazamiento
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _isExpandedList[index] = !_isExpandedList[index];
                    });
                  },
                  child: Card(
                    elevation: 3,//para elevar hacia delante los cuadros de la preguntas
                    margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      height: _isExpandedList[index] ? null : 175, // Altura cambiable
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                  children: [
                                    const TextSpan(
                                      text: 'Numero de la pregunta: ',
                                      style: TextStyle(fontSize: 35.0, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 1, 1, 1)), // Estilo en negrita
                                    ),
                                    TextSpan(
                                      text: '${dataQuestion[index].sp_CodPregunta}',
                                      style: const TextStyle(fontSize: 35.0, color: Color.fromARGB(255, 1, 1, 1)), // Estilo normal
                                    )
                                  ]
                                )
                              ),
                              const SizedBox(height: 10),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    const TextSpan(
                                      text: '- Respuesta que solo recibe es: ',
                                      style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 1, 1, 1)), // Estilo en negrita
                                    ),
                                    TextSpan(
                                      text: dataQuestion[index].sp_TipoRespuesta,
                                      style: const TextStyle(fontSize: 28.0, color: Color.fromARGB(255, 1, 1, 1)), // Estilo normal
                                    )
                                  ]
                                )
                              ),
                              const SizedBox(height: 15),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    const TextSpan(
                                      text: '- Pregunta: ',
                                      style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 1, 1, 1)), // Estilo en negrita
                                    ),
                                    TextSpan(
                                      text: dataQuestion[index].sp_Pregunta,
                                      style: const TextStyle(fontSize: 28.0, color: Color.fromARGB(255, 1, 1, 1)), // Estilo normal
                                    )
                                  ]
                                )
                              ),
                              const SizedBox(height: 15),
                              if (dataQuestion[index].sp_SubPregunta != null)
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      const TextSpan(
                                        text: '-- Sub-Pregunta: ',
                                        style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 1, 1, 1)), // Estilo en negrita
                                      ),
                                      TextSpan(
                                        text: dataQuestion[index].sp_SubPregunta,
                                        style: const TextStyle(fontSize: 26.0, color: Color.fromARGB(255, 1, 1, 1)), // Estilo normal
                                      )
                                    ]
                                  )
                                ),
                              const SizedBox(height: 5),
                              if (dataQuestion[index].sp_Rango != null)
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      const TextSpan(
                                        text: '- Rango Determinado: \n    ',
                                        style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 1, 1, 1)), // Estilo en negrita
                                      ),
                                      TextSpan(
                                        text: dataQuestion[index].sp_Rango,
                                        style: const TextStyle(fontSize: 26.0, color: Color.fromARGB(255, 1, 1, 1)), // Estilo normal
                                      )
                                    ]
                                  )
                                ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {
                                    _showPreguntaDialog(dataQuestion[index]); // Muestra el diálogo al hacer clic
                                  },
                                  child: const Text('Responder.', style: TextStyle(fontSize: 26.0)),
                                ),
                              ),
                            ]
                          ),
                        ),
                        // leading: Text("No. ${dataQuestion[index].sp_CodPregunta}", style: const TextStyle(fontSize: 30.0),),
                        // title: Text('Pregunta. \n${dataQuestion[index].sp_Pregunta}',style: const TextStyle(fontSize: 30.0),),
                        // subtitle: Text('Sub-Pregunta. \n${dataQuestion[index].sp_SubPregunta}' ?? '',style: const TextStyle(fontSize: 30.0)),
                        // trailing: Text('Rango determinado. \n${dataQuestion[index].sp_Rango}' ?? '',style: const TextStyle(fontSize: 30.0)),
                        // // trailing: Text(dataQuestion[index].sp_Rango ?? '',style: const TextStyle(fontSize: 30.0)),
                        // onTap: () {
                        //   _showPreguntaDialog(dataQuestion[index]); // Muestra el diálogo al hacer clic
                        // },
                      ),
                    ),
                  ),
                );
              },
            )
        ),
    );
  }

  void _showPreguntaDialog(SpPreguntascompleta question) {
    String? selectedResponse;

    showDialog(
      context: context, 
      builder: (BuildContext context, ) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('Pregunta No: ${question.sp_CodPregunta}. ${question.sp_Pregunta}', style: const TextStyle(fontSize: 30.0)),
              content: FormBuilder(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // if (dataQuestion[index].sp_TipoRespuesta == '')
                    /*
                    FormBuilderDropdown<String>(
                      name: 'tipoRespuesta',
                      decoration: const InputDecoration(
                        labelText: 'Responder esta pregunta con:',
                          labelStyle: TextStyle(fontSize: 30.0)
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'Abierta',
                          child: Text('Respuesta-Abierta', style: TextStyle(fontSize: 30.0))
                        ),
                        DropdownMenuItem(
                          value: 'SiNoNA',
                          child: Text('Selecionar: Si, No, N/A', style: TextStyle(fontSize: 30.0)),
                        ),
                        DropdownMenuItem(
                          value: 'Calificacion',
                          child: Text('Calific. 1 a 10', style: TextStyle(fontSize: 30.0)),
                        )
                      ],
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedResponse = newValue;
                        });
                      },
                    ),

                    // En caso de selecionar respuesta abierta
                    if (selectedResponse == 'Abierta')
                      FormBuilderTextField(
                        name: 'respuestaAbierta',
                        decoration: const InputDecoration(
                          labelText: 'Escribe tu respuesta',
                          labelStyle: TextStyle(fontSize: 20.0)
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                        ]),
                      ),
                    
                    // En caso de selecionar Selecion de Si, No o N/A
                    if (selectedResponse == 'SiNoNA')
                      FormBuilderDropdown<String>(
                        name: 'respuestaSiNoNA',
                        decoration: const InputDecoration(
                          labelText: 'Selecionar: Si, No, N/A',
                          labelStyle: TextStyle(fontSize: 20.0)
                        ),
                        items: const [
                          DropdownMenuItem(value: 'Si', child: Text('Si')),
                          DropdownMenuItem(value: 'No', child: Text('No')),
                          DropdownMenuItem(value: 'N/A', child: Text('N/A')),
                        ]
                      ),
                    
                    // En caso de selecionar Calificar del 1 a 10
                    if (selectedResponse == 'Calificacion')
                      FormBuilderDropdown<String>(
                        name: 'respuestaCalificacion',
                        decoration: const InputDecoration(
                          labelText: 'Calific. 1 a 10',
                          labelStyle: TextStyle(fontSize: 20.0)
                        ),
                        items: const [
                          DropdownMenuItem(value: '1', child: Text('1')),
                          DropdownMenuItem(value: '2', child: Text('2')),
                          DropdownMenuItem(value: '3', child: Text('3')),
                          DropdownMenuItem(value: '4', child: Text('4')),
                          DropdownMenuItem(value: '5', child: Text('5')),
                          DropdownMenuItem(value: '6', child: Text('6')),
                          DropdownMenuItem(value: '7', child: Text('7')),
                          DropdownMenuItem(value: '8', child: Text('8')),
                          DropdownMenuItem(value: '9', child: Text('9')),
                          DropdownMenuItem(value: '10', child: Text('10')),
                        ]
                        // items: List.generate(10, (index) {
                        //   return DropdownMenuItem(
                        //     value: index + 1,
                        //     child: Text('${index + 1}'),
                        //   );
                        // })
                      )
                      */
                  ],
                )
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text("Cerrar", style: TextStyle(fontSize: 30.0)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }
                ),

                TextButton(
                  onPressed: () {
                    if (_formKey.currentState?.saveAndValidate() ?? false) {
                      final responseForm = _formKey.currentState!.value;
                      // _saveRespuesta(question, responseForm);
                      Navigator.of(context).pop();
                    }
                  }, 
                  child: const Text('Proxima Pregunta', style: TextStyle(fontSize: 30.0))
                ),

                TextButton(
                  onPressed: () {
                    if (_formKey.currentState?.saveAndValidate() ?? false) {
                      final responseForm = _formKey.currentState!.value;
                      // _saveRespuesta(question, responseForm);
                      // _finalizarEncuesta();
                      Navigator.of(context).pop();
                    }
                  }, 
                  child: const Text('Finalizar Pregunta', style: TextStyle(fontSize: 30.0))
                )
              ]
            );
          }
        );
      }
    );
  }

  // Guardar respuesta en la API
  void _saveRespuesta(Preguntas question, Map<String, dynamic> respuestaForm) async {
    // Verificamos si el formulario es válido antes de guardar
    if (_formKey.currentState!.saveAndValidate()){
      final dataAnswer = _formKey.currentState!.value;

      // Determinamos el tipo de respuesta ingresada por el usuario
      final String? respuestaFinal = dataAnswer['respuestaAbierta'] ??
                                      dataAnswer['respuestaSiNoNA'] ??
                                      dataAnswer['respuestaCalificacion'];

      // Verificamos que exista alguna respuesta válida
      if(respuestaFinal == null || respuestaFinal.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor, completa la respuesta.'))
        );
        return;
      }

      // Creamos el objeto `Respuesta` con los datos recopilados
      Respuesta nuevaRespuesta = Respuesta(
        // idRespuesta: int.parse(dataAnswer['idRespuesta']),
        idUsuarios: widget.filtrarId.text, // ID del usuario
        noEncuesta: widget.noEncuestaFiltrar.text, // Identificador de la encuesta
        codPregunta: question.codPregunta,
        respuestas: respuestaFinal,
        // respuestas: dataAnswer['tipoRespuesta'],
        valoracion: dataAnswer['valoracion'],
        comentarios: dataAnswer['comentarios'],
        justificacion: dataAnswer['justificacion']
      );

      // Imprimir los datos a enviar para depuración
      print('Datos de la respuesta: ${nuevaRespuesta.toJson()}');

      try{
        final response = await _apiRespuesta.postRespuesta(nuevaRespuesta);

        if (response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Respuesta guardada con éxito'))
          );
        }else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al guardar la respuesta: ${response.reasonPhrase}'))
          );
        }

      } catch (e) {
        // Manejo de errores
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } else {
      // Si el formulario no es válido
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, completa todos los campos requeridos.')),
      );
    }
  }

  // Pasar a la siguiente pregunta (implementación pendiente)
  void _nextQuestion() {
    
  }

  // Finalizar la encuesta (implementación pendiente)
  void _finalizarEncuesta() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Encuesta finalizada con éxito'))
    );
  }
}