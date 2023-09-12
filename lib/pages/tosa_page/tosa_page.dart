import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tcc_hugo/const_colors.dart';
import 'package:tcc_hugo/models/tosa.dart';
import 'package:tcc_hugo/repositorys/tosa_repository.dart';
import 'package:tcc_hugo/repositorys/pet_repository.dart';
import 'package:tcc_hugo/widgets/showConfirma.dart';
import 'package:tcc_hugo/widgets/util.dart';

import 'components/addTosa.dart';

class TosaPage extends StatefulWidget {
  static const routeName = '/tosa';
  TosaPage({Key? key}) : super(key: key);

  @override
  State<TosaPage> createState() => _TosaPageState();
}

class _TosaPageState extends State<TosaPage> {
  @override
  Widget build(BuildContext context) {
    int indexPet = ModalRoute.of(context)!.settings.arguments as int;

    return Consumer2<PetsRepository, TosasRepository>(
        builder: (context, pets, tosas, child) {
      return Scaffold(
        backgroundColor: kWhite,
        appBar: AppBar(
          title: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: pets.lista[indexPet].foto != null
                    ? ClipOval(
                        child: Image.network(
                          pets.lista[indexPet].foto!,
                          width: 40,
                        ),
                      )
                    : ClipOval(
                        child: Image.asset(
                          "assets/images/logo.png",
                          height: 40,
                          width: 40,
                        ),
                      ),
              ),
              Text("${pets.lista[indexPet].nome!.toUpperCase()}",
                  style: TextStyle(
                      fontSize: 16,
                      color: kPrimaryColor,
                      fontWeight: FontWeight.w600)),
            ],
          ),
          elevation: 0,
          backgroundColor: kWhite,
          iconTheme: IconThemeData(color: kPrimaryColor),
        ),
        floatingActionButton: FloatingActionButton(
            backgroundColor: kPrimaryColor,
            isExtended: true,
            onPressed: () {
              addTosaDialog(context, pets.lista[indexPet].id!);
            },
            child: Icon(Icons.add)),
        body: Column(
          children: [
            Center(
                child: Image.asset(
              "assets/images/ico_tosa.png",
              height: 120,
            )),
            Espaco(),
            const Text(
              "tosas",
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontSize: 20,
                  color: kPrimaryColor,
                  fontWeight: FontWeight.w600),
            ),
            Espaco(),
            tosas.isLoading
                ? Expanded(
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [CircularProgressIndicator()],
                  ))
                : (tosas.map[pets.lista[indexPet].id] != null &&
                        tosas.map[pets.lista[indexPet].id]!.isNotEmpty)
                    ? Expanded(
                        child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20.0),
                                topRight: Radius.circular(20.0),
                              ),
                              color: kSecundaryColor.withOpacity(
                                  0.3), // Cor de fundo do container
                            ),
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            // width: MediaQuery.of(context).size.width * 0.9,
                            padding: EdgeInsets.only(top: 20),
                            child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount:
                                    tosas.map[pets.lista[indexPet].id]!.length,
                                itemBuilder: (context, index) {
                                  final sortedTosas = List<Tosa>.from(
                                      tosas.map[pets.lista[indexPet].id]!);
                                  sortedTosas.sort((a, b) => a.data!.compareTo(
                                      b.data!)); // Ordena pelo critério da data

                                  final tosa = sortedTosas[
                                      sortedTosas.length - 1 - index];
                                  return card(
                                      tosa: tosa,
                                      indexPet: indexPet);
                                })))
                    : Expanded(
                        child: Center(child: Text("Nenhuma tosa cadastrada")))
          ],
        ),
      );
    });
  }

  card({required Tosa tosa, required int indexPet}) {
    bool _deletando = false;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Card(
        elevation: 5,
        child: Container(
            child: ListTile(
                leading: ClipOval(
                    child: Container(
                        height: 40,
                        width: 40,
                        color: kSecundaryColor,
                        child: Icon(
                          Icons.cut,
                          color: kWhite,
                        ))),
                title: Row(
                  children: [
                    Icon(
                      Icons.calendar_month,
                      size: 18,
                    ),
                    Text(
                      "${DateFormat('dd-MM-yyyy').format(tosa.data!)}     ",
                      style: TextStyle(
                          color: kSecundaryColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 12),
                    ),
                    if(tosa.custo!=null)
                    Text("${UtilBrasilFields.obterReal(tosa.custo!)}",
                            style: TextStyle(
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w600,
                                fontSize: 14)),
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Divider(),
                    Text(
                        "Repetir em: ${tosa.proximaData != null ? DateFormat('dd-MM-yyyy').format(tosa.proximaData!) : ''}",
                        style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w600,
                            fontSize: 12)),
                  ],
                ),
                trailing: Consumer2<PetsRepository, TosasRepository>(
                      builder: (context, pets, tosas, child) {
                        return PopupMenuButton<String>(
                          onSelected: (value) async {
                            // Aqui você pode lidar com a opção selecionada
                            if (value == 'editar') {
                              addTosaDialog(context, pets.lista[indexPet].id!,
                                  tosa: tosa);
                            } else if (value == 'remover') {
                              bool confirma = await showConformaDialog(
                                  context,
                                  "Deseja remover a Tosa cadastrada?",
                                  "Remover");

                              if (confirma) {
                                setState(() {
                                  _deletando = true;

                                  tosas.remove(tosa, pets.lista[indexPet].id!);
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
                    ))),
      ),
    );
  }
}
