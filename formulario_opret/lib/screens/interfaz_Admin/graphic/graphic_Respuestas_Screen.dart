import 'package:flutter/material.dart';
import 'package:formulario_opret/models/Stored%20Procedure/sp_Filtrar_Respuestas.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class GraphicRespScreen extends StatelessWidget {
  final List<SpFiltrarRespuestas> data;

  const GraphicRespScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    Map<String, int> frecuencias = obtenerFrecuencias(data);
    List<ChartData> chartData = frecuencias.entries.map((entry) => ChartData(entry.key, entry.value)).toList();

    return Scaffold(
      appBar: AppBar( title: const Text('Gráfica de Respuestas'), ),
      body: Center(
        child: SfCartesianChart(
          primaryXAxis: const CategoryAxis(),
          title: const ChartTitle(text: 'Reporte de las Respuestas'),
          legend: const Legend(isVisible: true),
          tooltipBehavior: TooltipBehavior(enable: true),
          series: <CartesianSeries>[
            ColumnSeries<ChartData, String>(
              dataSource: chartData,
              xValueMapper: (ChartData data, _) => data.respuesta,
              yValueMapper: (ChartData data, _) => data.frecuencia,
              name: 'Frecuencia',
              color: Colors.blue, // Color de las barras
              dataLabelSettings: const DataLabelSettings(
                isVisible: true,
                textStyle: TextStyle(fontSize: 16, color: Colors.black), // Estilo de las etiquetas
              ),
            ),
          ],
          plotAreaBackgroundColor: Colors.grey[200], // Color de fondo del área del gráfico
          borderWidth: 2, // Ancho del borde del gráfico
          borderColor: Colors.grey, // Color del borde del gráfico
        ),
      )
    );
  }
}

class ChartData {
  final String respuesta;
  final int frecuencia;

  ChartData(this.respuesta, this.frecuencia);
}

Map<String, int> obtenerFrecuencias(List<SpFiltrarRespuestas> data) {
  Map<String, int> frecuencias = {};
  for (var respuesta in data) {
    if (respuesta.sp_Respuestas != null && respuesta.sp_Respuestas!.isNotEmpty) {
      frecuencias[respuesta.sp_Respuestas!] = (frecuencias[respuesta.sp_Respuestas!] ?? 0) + 1;
    }
  }
  return frecuencias;
}