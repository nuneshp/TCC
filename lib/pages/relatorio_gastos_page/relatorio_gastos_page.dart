import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tcc_hugo/const_text_styles.dart';
import 'package:tcc_hugo/models/pet.dart';
import 'package:tcc_hugo/pages/relatorio_gastos_page/components/cardGastos.dart';
import 'package:tcc_hugo/repositorys/antiparasitario_repository.dart';
import 'package:tcc_hugo/repositorys/banho_repository.dart';
import 'package:tcc_hugo/repositorys/consulta_repository.dart';
import 'package:tcc_hugo/repositorys/pet_repository.dart';
import 'package:tcc_hugo/repositorys/tosa_repository.dart';
import 'package:tcc_hugo/repositorys/vacina_repository.dart';
import 'package:tcc_hugo/repositorys/vermifugo_repository.dart';
import 'package:tcc_hugo/widgets/util.dart';

import '../../const_colors.dart';

class RelatorioGastosPage extends StatefulWidget {
  static const routeName = '/relatorioGastos';
  const RelatorioGastosPage({super.key});

  @override
  State<RelatorioGastosPage> createState() => _RelatorioGastosPageState();
}

class _RelatorioGastosPageState extends State<RelatorioGastosPage> {
  late DateTime inicio;
  late DateTime fim;
  String selecionado = "mes";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    inicio = DateTime(DateTime.now().year, DateTime.now().month, 1);
    fim = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(
        title: Text("Voltar",
            style: TextStyle(
                fontSize: 16,
                color: kPrimaryColor,
                fontWeight: FontWeight.w600)),
        iconTheme: const IconThemeData(color: kPrimaryColor),
        elevation: 0,
        backgroundColor: kWhite,
      ),
      body: SingleChildScrollView(child: Consumer<PetsRepository>(
        builder: (context, pets, child) {
          if (pets.isLoading) return Container();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: const Text(
                  "Gastos Detalhados",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20,
                      color: kPrimaryColor,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                child: Text("Resumo detalhado dos gastos por pets",
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                    )),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                      onPressed: () {
                        setState(() {
                          selecionado = "mes";
                          inicio = DateTime(
                              DateTime.now().year, DateTime.now().month, 1);
                          fim = DateTime.now();
                        });
                      },
                      child: Text("Este mês",
                          style: TextStyle(
                              color: selecionado == "mes"
                                  ? kPrimaryColor
                                  : Colors.grey))),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          selecionado = "ano";
                          inicio = DateTime(DateTime.now().year, 1, 1);
                          fim = DateTime.now();
                        });
                      },
                      child: Text(
                        "Este Ano",
                        style: TextStyle(
                            color: selecionado == "ano"
                                ? kPrimaryColor
                                : Colors.grey),
                      )),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          selecionado = "periodo";
                        });
                      },
                      child: Text("Período",
                          style: TextStyle(
                              color: selecionado == "periodo"
                                  ? kPrimaryColor
                                  : Colors.grey))),
                ],
              ),
              if (selecionado == "periodo") Divider(),
              if (selecionado == "periodo")
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("De: "),
                    TextButton(
                        onPressed: () {
                          Util().getData(context, (data) {
                            setState(() {
                              inicio = data;
                            });
                          }, current: inicio);
                        },
                        child:
                            Text("${DateFormat('dd-MM-yyyy').format(inicio)}", style: TextStyle(color:kPrimaryColor, fontSize: 18,fontWeight: FontWeight.w400),)),
                    Text("Até: "),
                    TextButton(
                        onPressed: () {
                          Util().getData(context, (data) {
                            setState(() {
                              fim = data;
                            });
                          }, current: fim);
                        },
                        child: Text("${DateFormat('dd-MM-yyyy').format(fim)}",style: TextStyle(color:kPrimaryColor, fontSize: 18,fontWeight: FontWeight.w400) ))
                  ],
                ),
              if(selecionado=="periodo")  
              Divider(),
              ...pets.lista.map((pet) => CardGastos(pet, inicio, fim)).toList()
            ],
          );
        },
      )),
    );
  }
}
