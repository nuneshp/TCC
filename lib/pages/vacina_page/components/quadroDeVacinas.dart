import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tcc_hugo/pages/vacina_page/components/addVacina.dart';
import 'package:tcc_hugo/repositorys/pet_repository.dart';
import 'package:tcc_hugo/repositorys/vacina_repository.dart';
import 'package:tcc_hugo/widgets/showConfirma.dart';

import '../../../const_colors.dart';
import '../../../models/vacina.dart';

class QuadroDeVacinas extends StatefulWidget {
  int indexPet;
  QuadroDeVacinas({required this.indexPet, super.key});

  @override
  State<QuadroDeVacinas> createState() => _QuadroDeVacinasState();
}

class _QuadroDeVacinasState extends State<QuadroDeVacinas> {
  @override
  Widget build(BuildContext context) {
    return Consumer2<PetsRepository, VacinasRepository>(
        builder: (context, pets, vacinas, child) {

          

      Map<String, List<Vacina>> vacinaCat =
          vacinas.getVacinasCat(pets.lista[widget.indexPet].id!);
      print("tamanho" + vacinaCat.length.toString());

      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: (vacinaCat.isNotEmpty)
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: vacinaCat.entries.map((categoria) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                      ),
                      color: kPrimaryColor
                          .withOpacity(0.7), // Cor de fundo do container
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: ListView(
                      scrollDirection: Axis.vertical,
                      children: [
                        Center(
                            child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            categoria.key,
                            style: TextStyle(
                                color: kWhite,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        )), // Título da coluna
                        SizedBox(height: 10),

                        ...[categoria].map((entry) {
                          String categoria = entry.key;
                          List<Vacina> vacinas = entry.value;

                          vacinas.sort((vacina1, vacina2) =>
                              vacina2.data!.compareTo(vacina1.data!));

                          return Column(
                            children: [
                              ...vacinas.map((vacina) {
                                return card(
                                    vacina: vacina,
                                    idPet: pets.lista[widget.indexPet].id!);
                              }).toList(),
                            ],
                          );
                        }).toList(),

                        SizedBox(height: 20),
                      ],
                    ),
                  );
                }).toList(),
              )
            : Center(child: Text("Nenhuma vacina cadastrada")),
      );
    });
  }

  card({required Vacina vacina, required String idPet}) {
    bool _deletando = false;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Card(
        elevation: 5,
        child: Row(children: [
          Container(
            width: 30,
            height: 75,
            color: kPrimaryColor,
            child: RotatedBox(
                quarterTurns: 3,
                child: Center(
                    child: Text(
                  "${vacina.dose != '' ? vacina.dose : '--'}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: kWhite, fontSize: 12, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.clip,
                  maxLines: 2,
                ))),
          ),
          Expanded(
            child: ListTile(
              contentPadding: EdgeInsets.only(left: 10),
                leading: ClipOval(
                    child: Container(
                        height: 40,
                        width: 40,
                        color: kSecundaryColor,
                        child: Icon(
                          Icons.colorize,
                          color: kWhite,
                        ))),
                title: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_month,
                          size: 18,
                        ),
                        Text(
                          "${DateFormat('dd-MM-yyyy').format(vacina.data!)}     ",
                          style: TextStyle(
                              color: kSecundaryColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 12),
                        ),
                        if(vacina.custo!=null)
                        Text("${UtilBrasilFields.obterReal(vacina.custo!)}",
                            style: TextStyle(
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w600,
                                fontSize: 14)),
                      ],
                    ),
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${vacina.marca != '' ? vacina.marca!.toUpperCase() : '--'}",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 15)),
                    // Divider(),        
                    Text(
                        "Repetir em: ${vacina.proximaData != null ? DateFormat('dd-MM-yyyy').format(vacina.proximaData!) : ''}",
                        style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w600,
                            fontSize: 12)),
                  ],
                ),
                trailing: Consumer2<PetsRepository, VacinasRepository>(
                      builder: (context, pets, vacinas, child) {
                        return PopupMenuButton<String>(
                          onSelected: (value) async {
                            // Aqui você pode lidar com a opção selecionada
                            if (value == 'editar') {
                              addVacinaDialog(context, pets.lista[widget.indexPet].id!,
                                  vacina: vacina);
                            } else if (value == 'remover') {
                              bool confirma = await showConformaDialog(
                                  context,
                                  "Deseja remover a Vacina cadastrada?",
                                  "Remover");

                              if (confirma) {
                                setState(() {
                                  _deletando = true;

                                  vacinas.remove(vacina, idPet);
                                });
                              }
                            }
                          },
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<String>>[
                            PopupMenuItem<String>(
                                value: 'editar',
                                child: ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  visualDensity: VisualDensity.compact,
                                  // dense: true,
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text("Editar",style: TextStyle(color: Colors.grey[600])),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      ClipOval(
                                        child: Container(
                                          padding: EdgeInsets.all(5),
                                          color: kPrimaryColor,
                                          child: Icon(
                                            Icons.edit,
                                            color: kWhite,
                                            size: 16,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                            PopupMenuItem<String>(
                                value: 'remover',
                                child: ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  visualDensity: VisualDensity.compact,
                                  // dense: true,
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text("Remover", style: TextStyle(color: Colors.grey[600]),),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      ClipOval(
                                        child: Container(
                                          padding: EdgeInsets.all(5),
                                          color: Colors.red,
                                          child: Icon(
                                            Icons.delete_outline,
                                            color: kWhite,
                                            size: 16,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                            // Adicione mais opções aqui, se necessário
                          ],
                        );
                      },
                    )
                
               
                ),
          )
        ]),
      ),
    );
  }
}
