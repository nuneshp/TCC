// import 'package:cripto_moedas/configs/app_settings.dart';
// import 'package:cripto_moedas/models/moeda.dart';
// import 'package:cripto_moedas/repositories/moeda_repository.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tcc_hugo/const_colors.dart';
import 'package:tcc_hugo/models/peso.dart';
import 'package:tcc_hugo/repositorys/peso_repository.dart';
import 'package:tcc_hugo/repositorys/pet_repository.dart';

class GraficoHistorico extends StatefulWidget {
  int indexPet;
  GraficoHistorico({Key? key, required this.indexPet}) : super(key: key);

  @override
  _GraficoHistoricoState createState() => _GraficoHistoricoState();
}

// enum Periodo { semana, mes, ano, total }

class _GraficoHistoricoState extends State<GraficoHistorico> {
  List<Color> cores = [
    kSecundaryColor,
  ];
  // Periodo periodo = Periodo.mes;
  List<Peso> historico = [];
  List<FlSpot> dadosGrafico = [];
  double maxX = 0;
  double maxY = 0;
  double minY = 0;
  ValueNotifier<bool> loaded = ValueNotifier(false);

  late Map<String, String> loc;
  late NumberFormat real;

  LineChartData getChartData() {
    return LineChartData(
      gridData: FlGridData(
        show: false, //linhas de grade

        drawHorizontalLine: true, // Mostrar grades horizontais
        verticalInterval: 5, // Intervalo entre as grades verticais
      ),
      titlesData: FlTitlesData(
        show: true,
        leftTitles: SideTitles(
          showTitles: true,
          reservedSize: 28, // Tamanho reservado para o título do eixo Y
          getTitles: (value) {
            if (value % 3 == 0) {
              return value.toString();
            }
            return '';
          },
        ),
        bottomTitles: SideTitles(
          showTitles: false,
        ), // Não exibir títulos no eixo X
      ),
      borderData: FlBorderData(show: false), //quadro
      minX: 0,
      maxX: maxX,
      minY: 0,
      maxY: maxY,
      lineBarsData: [
        LineChartBarData(
          spots: dadosGrafico,
          isCurved: true,
          colors: cores,
          barWidth: 2,
          dotData: FlDotData(show: true), //marcacao do ponto
          belowBarData: BarAreaData(
            show: true, //area abaixo da curva cor
            colors: cores.map((color) => color.withOpacity(0.15)).toList(),
          ),
        ),
      ],
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: kSecundaryColor,
          getTooltipItems: (data) {
            return data.map((item) {
              final date = getDate(item.spotIndex);
              return LineTooltipItem(
                real.format(item.y),
                TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
                children: [
                  TextSpan(
                    text: '\n $date',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(.5),
                    ),
                  ),
                ],
              );
            }).toList();
          },
        ),
      ),
    );
  }

  getDate(int index) {
    DateTime  date = historico[index].data!;

    return DateFormat('dd/MM/y').format(date);
  }

  // chartButton(Periodo p, String label) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 4),
  //     child: TextButton(
  //       onPressed: () => setState(() => periodo = p),
  //       child: Text(label),
  //       style: (periodo != p)
  //           ? ButtonStyle(
  //               foregroundColor: MaterialStateProperty.all(Colors.grey),
  //             )
  //           : ButtonStyle(
  //               backgroundColor: MaterialStateProperty.all(Colors.indigo[50]),
  //             ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    Map<String, String> loc = {
      'locale': 'pt_BR',
      'name': 'Kg',
    };
    real = NumberFormat.currency(locale: loc['locale'], name: loc['name']);

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "   Histórico de Peso",
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontSize: 14,
                    color: kPrimaryColor,
                    fontWeight: FontWeight.w600),
              ),
              Consumer2<PesosRepository, PetsRepository>(
                builder: (context, pesos, pets, child) {

                  if (pesos.isLoading || pets.isLoading)
                      return Center(child: CircularProgressIndicator());

                  dadosGrafico = [];

                  if (historico.isEmpty && pesos.map[pets.idPet(widget.indexPet)]!=null)
                    historico = pesos.map[pets.idPet(widget.indexPet)]!;

                    historico.sort((a, b) => a.data!.compareTo(b.data!));

                  maxX = (historico.length - 1).toDouble();
                  maxY = 0;
                  minY = double.infinity;

                  for (var item in historico) {
                    maxY = item.peso! > maxY ? item.peso! : maxY;
                    minY = item.peso! < minY ? item.peso! : minY;
                  }

                  

                  for (int i = 0; i < historico.length; i++) {
                    
                    dadosGrafico.add(FlSpot(
                      i.toDouble(),
                      historico[i].peso!,
                    ));
                  }

                  return (historico.isNotEmpty)
                          ? Container(
                              height: 200,
                              width: MediaQuery.of(context).size.width,
                              child: Padding(
                                  padding:
                                      const EdgeInsets.only(top: 20),
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: LineChart(
                                          getChartData(),
                                          swapAnimationDuration:
                                              Duration(seconds: 2),
                                        ),
                                      ),
                                      
                                    ],
                                  )))
                          : Text('Nenhum peso registrado para este pet.');
                },
              ),
            ]));
  }
}
