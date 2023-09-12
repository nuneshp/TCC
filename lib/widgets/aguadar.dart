// import 'package:flutter/material.dart';

// class Aguardar extends StatelessWidget {
//   BuildContext context;
//   Future retorno;
  
//    Aguardar({ Key? key, required this.context,required this.retorno}) : super(key: key);
 

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//           future: getFutureDados(),
//           builder: (context, snapshot) {
//             if (snapshot.hasData) {
//               return snapshot.data;
//             } else {
//               return Scaffold(
//                   backgroundColor: Colors.white,
//                   body:  Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: <Widget>[
//                       Container(
//                       child: Center(
//                           child: SizedBox(
//                             child: CircularProgressIndicator(),
//                             width: 60,
//                             height: 60,
//                        ))),
//                        Container(
//                          padding: EdgeInsets.all(10),
//                          child: Text("Carregando dados...")
//                        )
//                     ]

//                   )

//                   );
//             }
//           });
//   }

//   getFutureDados(){
//     return retorno;
//   }
// }