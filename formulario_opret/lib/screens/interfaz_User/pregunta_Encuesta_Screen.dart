// import 'package:flutter/material.dart';
// import 'package:formulario_opret/models/pregunta.dart';
// import 'package:formulario_opret/screens/interfaz_User/navbarUser/navbar_Empl.dart';
// import 'package:formulario_opret/services/pregunta_services.dart';

// class PreguntaEncuestaScreen extends StatefulWidget {
//   const PreguntaEncuestaScreen({super.key});

//   @override
//   State<PreguntaEncuestaScreen> createState() => _PreguntaEncuestaScreenState();
// }

// class _PreguntaEncuestaScreenState extends State<PreguntaEncuestaScreen> {
//   final ApiServicePreguntas _apiQuestions = ApiServicePreguntas('https://10.0.2.2:7002');
//   late List<Pregunta> dataQuestion = []; //para la llamada de los datos
//   String userNameEmpl = 'data';
//   String emailEmpl = 'data';

//   @override
//   void initState() {
//     super.initState();
//     _refreshPreguntas(); //utilizado para cargar los datos al cargar la pagina y se cargan los datos
//   }

//   void _refreshPreguntas() async {
//     setState(() {}); //se usar para actualizar el arbol de widget cuando se cambien los datos
//     dataQuestion = await _apiQuestions.getPreguntasListada();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       drawer: NavbarEmpl(userNameEmpl: userNameEmpl, emailEmpl: emailEmpl),
//       appBar: AppBar(title: const Text('Preguntas de Encuesta')),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               shrinkWrap: true,
//               itemCount: dataQuestion.length,
//               itemBuilder: (BuildContext context, int index) {
//                 return ListTile(
//                   leading: Text("${dataQuestion[index].idPreguntas}"),
//                   title: Text(dataQuestion[index].preguntas),
//                 );
//               },
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   void _showRespuestaDialog(Pregunta pregunta) {
//     showDialog(
//       context: context, 
//       builder: (BuildContext context, ) {
//         return AlertDialog(
//           title: Text('Pregunta No: ${pregunta.idPreguntas}'),
//           content: Text(pregunta.preguntas),
//           actions: <Widget>[
//             TextButton(
//               child: const Text("Cerrar"),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               }
//             ),
//             TextButton(onPressed: () {}, 
//               child: const Text('Proxima Pregunta')
//             ),
//             TextButton(onPressed: () {}, 
//               child: const Text('Finalizar Pregunta')
//             )
//           ]
//         );
//       }
//     );
//   }
// }