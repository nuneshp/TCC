import 'package:chart_sparkline/chart_sparkline.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcc_hugo/const_colors.dart';
import 'package:tcc_hugo/models/antiparasitario.dart';
import 'package:tcc_hugo/repositorys/antiparasitario_repository.dart';
import 'package:tcc_hugo/repositorys/banho_repository.dart';
import 'package:tcc_hugo/repositorys/peso_repository.dart';
import 'package:tcc_hugo/repositorys/tosa_repository.dart';
import 'package:tcc_hugo/widgets/util.dart';

import '../../../models/peso.dart';
import '../../../repositorys/pet_repository.dart';
import '../../../repositorys/vermifugo_repository.dart';

class ResumoInformacoesImportantes extends StatefulWidget {
  int indexPet;
  ResumoInformacoesImportantes({Key? key, required this.indexPet})
      : super(key: key);

  @override
  State<ResumoInformacoesImportantes> createState() =>
      _ResumoInformacoesImportantesState();
}

class _ResumoInformacoesImportantesState
    extends State<ResumoInformacoesImportantes> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "   Resumo de Informações Importantes",
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontSize: 14,
                  color: kPrimaryColor,
                  fontWeight: FontWeight.w600),
            ),
            Espaco(),
            Consumer6<
                    PetsRepository,
                    PesosRepository,
                    VermifugosRepository,
                    TosasRepository,
                    BanhosRepository,
                    AntiparasitariosRepository>(
                builder: (context, pets, pesos, vermifugos, tosas, banhos,
                    antiparasitarios, child) {
              final pesosDoPet = pesos.map[pets.idPet(widget.indexPet)];
              if (pesosDoPet != null && pesosDoPet.isNotEmpty)
                pesosDoPet.sort((a, b) => a.data!.compareTo(b.data!));

              //
              final vermifugosDoPet =
                  vermifugos.map[pets.idPet(widget.indexPet)];
              if (vermifugosDoPet != null && vermifugosDoPet.isNotEmpty)
                vermifugosDoPet.sort((a, b) => a.data!.compareTo(b.data!));
              //
              final banhosDoPet = banhos.map[pets.idPet(widget.indexPet)];
              if (banhosDoPet != null && banhosDoPet.isNotEmpty)
                banhosDoPet.sort((a, b) => a.data!.compareTo(b.data!));
              //
              final tosasDoPet = tosas.map[pets.idPet(widget.indexPet)];
              if (tosasDoPet != null && tosasDoPet.isNotEmpty)
                tosasDoPet.sort((a, b) => a.data!.compareTo(b.data!));
              //
              final antiparasitariosDoPet =
                  antiparasitarios.map[pets.idPet(widget.indexPet)];
              if (antiparasitariosDoPet != null &&
                  antiparasitariosDoPet.isNotEmpty)
                antiparasitariosDoPet
                    .sort((a, b) => a.data!.compareTo(b.data!));

              return Container(
                // height: 90,
                child: GridView.count(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  crossAxisCount: 3,
                  childAspectRatio: MediaQuery.of(context).size.width /
                      (MediaQuery.of(context).size.height / 3),
                  mainAxisSpacing: 20, // Espaçamento vertical entre as linhas
                  crossAxisSpacing: 5,
                  children: [
                    bloco(
                        isLoading: banhos.isLoading,
                        preText: 'Último\nbanho:',
                        value: (banhosDoPet != null && banhosDoPet.isNotEmpty)
                            ? '${DateTime.now().difference(banhosDoPet.last.data!).inDays}'
                            : '--',
                        posText: 'dias',
                        icone: Icons.bubble_chart,
                        cor: kTertiaryColor),
                    bloco(
                        isLoading: tosas.isLoading,
                        preText: 'Última\ntosa:',
                        value: (tosasDoPet != null && tosasDoPet.isNotEmpty)
                            ? '${DateTime.now().difference(tosasDoPet.last.data!).inDays}'
                            : '--',
                        posText: 'dias',
                        icone: Icons.content_cut,
                        cor: Colors.green),
                    bloco(
                        isLoading: vermifugos.isLoading,
                        preText: 'Vermifugar\nem:',
                        value: (vermifugosDoPet != null &&
                                vermifugosDoPet.isNotEmpty)
                            ? (vermifugosDoPet.last.proximaData!
                                        .difference(DateTime.now())
                                        .inDays <
                                    0
                                ? "!"
                                : '${vermifugosDoPet.last.proximaData!.difference(DateTime.now()).inDays}')
                            : '--',
                        posText: (vermifugosDoPet != null &&
                                vermifugosDoPet.isNotEmpty)
                            ? (vermifugosDoPet.last.proximaData!
                                        .difference(DateTime.now())
                                        .inDays <
                                    0
                                ? "Urgente"
                                : 'dias')
                            : "dias",
                        icone: Icons.block,
                        cor: kSecundaryColor),
                    bloco(
                      isLoading: pesos.isLoading,
                      preText: 'Peso\natual:',
                      value: (pesosDoPet != null && pesosDoPet.isNotEmpty)
                          ? '${pesosDoPet.last.peso!.toStringAsFixed(2)}'
                          : '--',
                      posText: 'Kg',
                      icone: Icons.balance,
                    ),
                    bloco(
                        isLoading: antiparasitarios.isLoading,
                        preText: 'Antiparasitário\n repetir em:',
                        value: (antiparasitariosDoPet != null &&
                                antiparasitariosDoPet.isNotEmpty)
                            ? (antiparasitariosDoPet.last.proximaData!
                                        .difference(DateTime.now())
                                        .inDays <
                                    0
                                ? "!"
                                : '${antiparasitariosDoPet.last.proximaData!.difference(DateTime.now()).inDays}')
                            : '--',
                        posText: (antiparasitariosDoPet != null &&
                                antiparasitariosDoPet.isNotEmpty)
                            ? (antiparasitariosDoPet.last.proximaData!
                                        .difference(DateTime.now())
                                        .inDays <
                                    0
                                ? "Urgente"
                                : 'dias')
                            : "dias",
                        icone: Icons.bug_report_outlined,
                        cor: Colors.purple),
                  ],
                ),
              );
            }),
          ]),
    );
  }

  bloco(
      {required bool isLoading,
      required String preText,
      required String value,
      required String posText,
      required IconData icone,
      Color cor = kPrimaryColor}) {
    return Container(
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          Card(
            margin: EdgeInsets.only(left: 10),
            elevation: 5,
            color: kWhite,
            child: SizedBox(
              // width: 100,
              height: 80,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      preText,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: cor,
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    isLoading
                        ? Container(
                            padding: const EdgeInsets.all(2),
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: cor,
                              strokeWidth: 2,
                            ))
                        : Text(
                            value,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                    Text(
                      posText,
                      style: TextStyle(
                        color: cor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          ClipOval(
            child: Container(
              height: 30,
              width: 30,
              color: cor,
              child: Center(
                  child: Icon(
                icone,
                color: kWhite,
              )),
            ),
          ),
        ],
      ),
    );
  }
}
