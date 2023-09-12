
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:tcc_hugo/const_colors.dart';

// class GraficoPizzaPorCategoria extends StatefulWidget {
//   const GraficoPizzaPorCategoria({super.key});

//   @override
//   State<StatefulWidget> createState() => GraficoPizzaPorCategoriaState();
// }

// class GraficoPizzaPorCategoriaState extends State {
//   int touchedIndex = 0;

//   @override
//   Widget build(BuildContext context) {
//     return AspectRatio(
//       aspectRatio: 1.3,
//       child: AspectRatio(
//         aspectRatio: 1,
//         child: PieChart(
//           PieChartData(
//             pieTouchData: PieTouchData(
//               touchCallback: (FlTouchEvent event, pieTouchResponse) {
//                 setState(() {
//                   if (!event.isInterestedForInteractions ||
//                       pieTouchResponse == null ||
//                       pieTouchResponse.touchedSection == null) {
//                     touchedIndex = -1;
//                     return;
//                   }
//                   touchedIndex =
//                       pieTouchResponse.touchedSection!.touchedSectionIndex;
//                 });
//               },
//             ),
//             borderData: FlBorderData(
//               show: false,
//             ),
//             sectionsSpace: 0,
//             centerSpaceRadius: 0,
//             sections: showingSections(),
//           ),
//         ),
//       ),
//     );
//   }

//   List<PieChartSectionData> showingSections() {
//     return List.generate(2, (i) {
//       final isTouched = i == touchedIndex;
//       final fontSize = isTouched ? 20.0 : 16.0;
//       final radius = isTouched ? 110.0 : 100.0;
//       final widgetSize = isTouched ? 55.0 : 40.0;
//       const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

//       switch (i) {
//         case 0:
//           return PieChartSectionData(
//             color: kSecundaryColor,
//             value: 40,
//             title: '40%',
//             radius: radius,
//             titleStyle: TextStyle(
//               fontSize: fontSize,
//               fontWeight: FontWeight.bold,
//               color: const Color(0xffffffff),
//               shadows: shadows,
//             ),
//             badgeWidget: _Badge(
//               'assets/images/ico_consulta.png',
//               size: widgetSize,
//               borderColor: Colors.black,
//             ),
//             badgePositionPercentageOffset: .98,
//           );
//         case 1:
//           return PieChartSectionData(
//             color: kPrimaryColor,
//             value: 30,
//             title: '30%',
//             radius: radius,
//             titleStyle: TextStyle(
//               fontSize: fontSize,
//               fontWeight: FontWeight.bold,
//               color: const Color(0xffffffff),
//               shadows: shadows,
//             ),
//             badgeWidget: _Badge(
//               'assets/images/ico_banho.png',
//               size: widgetSize,
//               borderColor: Colors.black,
//             ),
//             badgePositionPercentageOffset: .98,
//           );
        
//         default:
//           throw Exception('Oh no');
//       }
//     });
//   }
// }

// class _Badge extends StatelessWidget {
//   const _Badge(
//     this.asset, {
//     required this.size,
//     required this.borderColor,
//   });
//   final String asset;
//   final double size;
//   final Color borderColor;

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedContainer(
//       duration: PieChart.defaultDuration,
//       width: size,
//       height: size,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         shape: BoxShape.circle,
//         border: Border.all(
//           color: borderColor,
//           width: 2,
//         ),
//         boxShadow: <BoxShadow>[
//           BoxShadow(
//             color: Colors.black.withOpacity(.5),
//             offset: const Offset(3, 3),
//             blurRadius: 3,
//           ),
//         ],
//       ),
//       padding: EdgeInsets.all(size * .15),
//       child: Center(
//         child: Image.asset(
//           asset,
//         ),
//       ),
//     );
//   }
// }