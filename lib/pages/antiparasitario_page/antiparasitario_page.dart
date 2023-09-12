import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tcc_hugo/const_colors.dart';
import 'package:tcc_hugo/models/antiparasitario.dart';
import 'package:tcc_hugo/repositorys/antiparasitario_repository.dart';
// import 'package:tcc_hugo/models/vermifugo.dart';
// import 'package:tcc_hugo/repositorys/vermifugo_repository.dart';
import 'package:tcc_hugo/repositorys/pet_repository.dart';
import 'package:tcc_hugo/widgets/showConfirma.dart';
import 'package:tcc_hugo/widgets/util.dart';

import 'components/addAntiparasitario.dart';

class AntiparasitarioPage extends StatefulWidget {
  static const routeName = '/antiparasitario';
  AntiparasitarioPage({Key? key}) : super(key: key);

  @override
  State<AntiparasitarioPage> createState() => _AntiparasitarioPageState();
}

class _AntiparasitarioPageState extends State<AntiparasitarioPage> {
  @override
  Widget build(BuildContext context) {
    int indexPet = ModalRoute.of(context)!.settings.arguments as int;

    return Consumer2<PetsRepository, AntiparasitariosRepository>(
        builder: (context, pets, antiparasitarios, child) {
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
              addAntiparasitarioDialog(context, pets.lista[indexPet].id!);
            },
            child: Icon(Icons.add)),
        body: Column(
          children: [
            Center(
                child: Image.asset(
              "assets/images/ico_antiparasitario.png",
              height: 120,
            )),
            Espaco(),
            const Text(
              "Antiparasitários",
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontSize: 20,
                  color: kPrimaryColor,
                  fontWeight: FontWeight.w600),
            ),
            Espaco(),
            antiparasitarios.isLoading
                ? Expanded(
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [CircularProgressIndicator()],
                  ))
                : (antiparasitarios.map[pets.lista[indexPet].id] != null &&
                        antiparasitarios.map[pets.lista[indexPet].id]!.isNotEmpty)
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
                                itemCount: antiparasitarios
                                    .map[pets.lista[indexPet].id]!.length,
                                itemBuilder: (context, index) {
                                  final sortedAntiparasitarios = List<Antiparasitario>.from(
                                      antiparasitarios.map[pets.lista[indexPet].id]!);
                                  sortedAntiparasitarios.sort((a, b) => a.data!
                                      .compareTo(b
                                          .data!)); // Ordena pelo critério da data

                                  final antiparasitario = sortedAntiparasitarios[
                                      sortedAntiparasitarios.length - 1 - index];

                                  return card(
                                      antiparasitario: antiparasitario,
                                      indexPet: indexPet);
                                })))
                    : Expanded(
                        child:
                            Center(child: Text("Nenhum antiparasitários cadastrado")))
          ],
        ),
      );
    });
  }

  card({required Antiparasitario antiparasitario, required int indexPet}) {
    bool _deletando = false;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Card(
        elevation: 5,
        child: Container(
            child: ListTile(
              contentPadding: EdgeInsets.only(left: 10),
                leading: ClipOval(
                    child: Container(
                        height: 40,
                        width: 40,
                        color: kSecundaryColor,
                        child: Icon(
                          Icons.bug_report_outlined,
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
                          "${DateFormat('dd-MM-yyyy').format(antiparasitario.data!)}     ",
                          style: TextStyle(
                              color: kSecundaryColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 12),
                        ),
                         if(antiparasitario.custo!=null)
                        Text("${UtilBrasilFields.obterReal(antiparasitario.custo!)}",
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
                    Text("${antiparasitario.marca != '' ? antiparasitario.marca!.toUpperCase() : '--'}",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 15)),
                            Divider(),
                    Text(
                        "Repetir em: ${antiparasitario.proximaData != null ? DateFormat('dd-MM-yyyy').format(antiparasitario.proximaData!) : ''}",
                        style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w600,
                            fontSize: 12)),
                  ],
                ),
                trailing: Consumer2<PetsRepository, AntiparasitariosRepository>(
                      builder: (context, pets, antiparasitarios, child) {
                        return PopupMenuButton<String>(
                          onSelected: (value) async {
                            // Aqui você pode lidar com a opção selecionada
                            if (value == 'editar') {
                              addAntiparasitarioDialog(context, pets.lista[indexPet].id!,
                                  antiparasitario: antiparasitario);
                            } else if (value == 'remover') {
                              bool confirma = await showConformaDialog(
                                  context,
                                  "Deseja remover o Antiparasitário cadastrado?",
                                  "Remover");

                              if (confirma) {
                                setState(() {
                                  _deletando = true;

                                  antiparasitarios.remove(antiparasitario, pets.lista[indexPet].id!);
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
