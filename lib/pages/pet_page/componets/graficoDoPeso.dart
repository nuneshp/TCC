// import 'package:chart_sparkline/chart_sparkline.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:tcc_hugo/const_colors.dart';
// import 'package:tcc_hugo/repositorys/peso_repository.dart';

// import '../../../models/peso.dart';
// import '../../../repositorys/pet_repository.dart';

// class GraficoDoPeso extends StatefulWidget {
//   int indexPet;
//   GraficoDoPeso({Key? key, required this.indexPet}) : super(key: key);

//   @override
//   State<GraficoDoPeso> createState() => _GraficoDoPesoState();
// }

// class _GraficoDoPesoState extends State<GraficoDoPeso> {
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//       child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               "   Histórico de Peso",
//               textAlign: TextAlign.start,
//               style: TextStyle(
//                   fontSize: 14,
//                   color: kPrimaryColor,
//                   fontWeight: FontWeight.w600),
//             ),
//             Consumer2<PetsRepository, PesosRepository>(
//                 builder: (context, pets, pesos, child) {
//               List<double> historicoPesos = [];
//               List<Peso>? pesosDoPet = [];

//               if (pets.idPet(widget.indexPet) != null) {
//                 pesosDoPet = pesos.map[pets.idPet(widget.indexPet)];
//               }

//               if (pesosDoPet != null && pesosDoPet.isNotEmpty) {
//                 pesosDoPet.sort((a, b) => a.data!.compareTo(b.data!));
//                 for (var element in pesosDoPet) {
//                   if (element.peso != null) {
//                     historicoPesos.add(element.peso!);
//                   }
//                 }
//               }
//               return pesos.isLoading
//                   ? Center(
//                     child: Container(
//                       height: 150,
                  
//                       child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [CircularProgressIndicator(color: kPrimaryColor, strokeWidth: 3,)],
//                         ),
//                     ),
//                   )
//                   : (historicoPesos.isNotEmpty && historicoPesos != null)
//                       ? Container(
//                           decoration: BoxDecoration(
//                               color: kGrey,
//                               borderRadius:
//                                   BorderRadius.all(Radius.circular(20))),
//                           margin: EdgeInsets.only(top: 10),
//                           padding:
//                               EdgeInsets.only(left: 50, top: 20, bottom: 20),
//                           height: 150,
//                           child: Sparkline(
//                               data: historicoPesos,
//                               lineWidth: 3.0,
//                               useCubicSmoothing: true,
//                               cubicSmoothingFactor: 0.2,
//                               // averageLine: true,
//                               // averageLabel: true, // valor medio
//                               kLine: ['max', 'last'],
//                               gridLinelabelPrefix: '      ',
//                               // gridLinelabelSufix: ' Kg',
//                               gridLineLabelPrecision: 3,
//                               enableGridLines: true,
//                               gridLineWidth: 0.3,
//                               gridLineAmount: 4, // numero de linhas de grade
//                               gridLineLabelColor: kSecundaryColor,
//                               lineGradient: LinearGradient(
//                                 begin: Alignment.topCenter,
//                                 end: Alignment.bottomCenter,
//                                 colors: [
//                                   Color.fromRGBO(106, 27, 154, 1),
//                                   Color.fromRGBO(206, 147, 216, 1)
//                                 ],
//                               ),
//                               pointsMode: PointsMode.last,
//                               pointSize: 10.0,
//                               pointColor: kSecundaryColor))
//                       : Text('Nenhum peso registrado para este pet.');
//             }),
//           ]),
//     );
//   }
// }
