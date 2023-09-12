import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcc_hugo/const_colors.dart';
import 'package:tcc_hugo/pages/pet_page/componets/novoGrafico.dart';
import 'package:tcc_hugo/pages/pet_page/componets/resumoInformacoesImportantes.dart';
import 'package:tcc_hugo/pages/pet_page/componets/graficoDoPeso.dart';
import 'package:tcc_hugo/pages/pet_page/componets/widgetItensPet.dart';
import 'package:tcc_hugo/repositorys/banho_repository.dart';
import 'package:tcc_hugo/repositorys/peso_repository.dart';


import 'componets/widgetCabecalhoPet.dart';

class PetDetalhesPage extends StatefulWidget {
  static const routeName = '/petDetalhes';
  
   PetDetalhesPage({Key? key,}) : super(key: key);

  @override
  State<PetDetalhesPage> createState() => _PetDetalhesPageState();
}

class _PetDetalhesPageState extends State<PetDetalhesPage> {

 

  @override
  Widget build(BuildContext context) {
    
    final indexPet = ModalRoute.of(context)!.settings.arguments as int;
    

    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(
       title: Text("Detalhes do Pet", style: TextStyle(
                            fontSize: 16,
                            color: kPrimaryColor,
                            fontWeight: FontWeight.w600)),
        elevation: 0,
        backgroundColor: kWhite,
        iconTheme: IconThemeData(color: kPrimaryColor),
        actions: [
          //  InkWell(
          //   child: Padding(
          //     padding: const EdgeInsets.all(8.0),
          //     child: Icon(Icons.notifications_none_rounded),
          //   ),
          //   onTap: () {},
          // ),
        ],
      ),
  
      body:SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           WidgetCabecalhoPet(indexPet: indexPet),
           Divider(),
           WidgetItensPet(indexPet: indexPet),
           Divider(),
          GraficoHistorico(indexPet: indexPet),
           Divider(),
           ResumoInformacoesImportantes(indexPet: indexPet)
          ],
        ),
      )
       
   
      
     );
  }
}