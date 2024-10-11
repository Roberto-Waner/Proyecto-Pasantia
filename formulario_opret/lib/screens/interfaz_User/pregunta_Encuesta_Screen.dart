import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
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
  final ApiServicePreguntas _apiQuestions = ApiServicePreguntas('https://10.0.2.2:7128');
  final ApiServiceRespuesta _apiRespuesta = ApiServiceRespuesta('https://10.0.2.2:7128');
  late List<Pregunta> dataQuestion = []; //para la llamada de los datos
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    super.initState();
    _refreshPreguntas(); //utilizado para cargar los datos al cargar la pagina y se cargan los datos
  }

  void _refreshPreguntas() async {
    dataQuestion = await _apiQuestions.getPreguntasListada();
    setState(() {}); //se usar para actualizar el arbol de widget cuando se cambien los datos
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

      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: dataQuestion.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: Text("${dataQuestion[index].noPregunta}"),
                  title: Text(dataQuestion[index].pregunta1 ?? ''),
                  onTap: () {
                    _showPreguntaDialog(dataQuestion[index]); // Muestra el diálogo al hacer clic
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }

  void _showPreguntaDialog(Pregunta question) {
    // final formKey = GlobalKey<FormBuilderState>();
    String? selectedResponse;

    showDialog(
      context: context, 
      builder: (BuildContext context, ) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('Pregunta No: ${question.noPregunta}. ${question.pregunta1}'),
              content: FormBuilder(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FormBuilderDropdown<String>(
                      name: 'tipoRespuesta',
                      decoration: const InputDecoration(
                        labelText: 'Responder esta pregunta con:'
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'Abierta',
                          child: Text('Respuesta-Abierta')
                        ),
                        DropdownMenuItem(
                          value: 'SiNoNA',
                          child: Text('Selecionar: Si, No, N/A'),
                        ),
                        DropdownMenuItem(
                          value: 'Calificacion',
                          child: Text('Calific. 1 a 10'),
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
                  ],
                )
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text("Cerrar"),
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
                  child: const Text('Proxima Pregunta')
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
                  child: const Text('Finalizar Pregunta')
                )
              ]
            );
          }
        );
      }
    );
  }

  // Guardar respuesta en la API
  // void _saveRespuesta(Pregunta question, Map<String, dynamic> respuestaForm) async {
  //   // Verificamos si el formulario es válido antes de guardar
  //   if (_formKey.currentState!.saveAndValidate()){
  //     final dataAnswer = _formKey.currentState!.value;

  //     // Determinamos el tipo de respuesta ingresada por el usuario
  //     final String? respuestaFinal = dataAnswer['respuestaAbierta'] ??
  //                                     dataAnswer['respuestaSiNoNA'] ??
  //                                     dataAnswer['respuestaCalificacion'];

  //     // Verificamos que exista alguna respuesta válida
  //     if(respuestaFinal == null || respuestaFinal.isEmpty) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('Por favor, completa la respuesta.'))
  //       );
  //       return;
  //     }

  //     // Creamos el objeto `Respuesta` con los datos recopilados
  //     final nuevaRespuesta = Respuesta(
  //       // idRespuesta: int.parse(dataAnswer['idRespuesta']),
  //       idUsuarioEmpl: widget.filtrarId.text, // ID del usuario
  //       noEncuesta: widget.noEncuestaFiltrar.text, // Identificador de la encuesta
  //       idPreguntas: question.idPreguntas,
  //       respuestas: respuestaFinal,
  //       // respuestas: dataAnswer['tipoRespuesta'],
  //       valoracion: dataAnswer['valoracion'] // Valoración es opcional
  //     );

  //     // Imprimir los datos a enviar para depuración
  //     print('Datos de la respuesta: ${nuevaRespuesta.toJson()}');

  //     try{
  //       final response = await _apiRespuesta.postRespuesta(nuevaRespuesta);

  //       if (response.statusCode == 201) {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(content: Text('Respuesta guardada con éxito'))
  //         );
  //       }else {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(content: Text('Error al guardar la respuesta: ${response.reasonPhrase}'))
  //         );
  //       }

  //     } catch (e) {
  //       // Manejo de errores
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Error: $e')),
  //       );
  //     }
  //   } else {
  //     // Si el formulario no es válido
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Por favor, completa todos los campos requeridos.')),
  //     );
  //   }
  // }

  // Pasar a la siguiente pregunta (implementación pendiente)
  void _nextQuestion() {
    // Implementar la lógica para ir a la siguiente pregunta en la lista
  }

  // Finalizar la encuesta (implementación pendiente)
  void _finalizarEncuesta() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Encuesta finalizada con éxito'))
    );
  }
}

// void _ventanaRespuesta (Respuesta respuesta) {
//   final formKey = GlobalKey<FormBuilderState>();
  
//   FormBuilder(
//     child: Column(
//       children: [
//         FormBuilderDropdown <String>(
//           name: 'name', 
//           decoration: const InputDecoration(
//             labelText: 'Respuesta'
//           ),
//           items: const [
//             DropdownMenuItem(
//               child: Text('Respuesta abierta'),
//               value: 'RespuestaAbierta'
//             ),
//             DropdownMenuItem(child: Text('data'))
//           ]
//         )
//       ],
//     ),
//   );
// }

// if (question == 'Abierta')
// FormBuilderTextField(
//   name: 'respuestaAbierta',
//   decoration: const InputDecoration(
//     labelText: 'Escribe tu respuesta'
//   ),
//   validator: FormBuilderValidators.compose([
//     FormBuilderValidators.required(),
//   ]),
// )