import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tcc_hugo/const_colors.dart';
import 'package:tcc_hugo/models/consulta.dart';
import 'package:tcc_hugo/repositorys/banho_repository.dart';
import 'package:tcc_hugo/repositorys/consulta_repository.dart';
import 'package:tcc_hugo/repositorys/pet_repository.dart';
import 'package:tcc_hugo/widgets/showConfirma.dart';
import 'package:tcc_hugo/widgets/util.dart';

import 'components/addConsulta.dart';

class ConsultaPage extends StatefulWidget {
  static const routeName = '/consulta';
  ConsultaPage({Key? key}) : super(key: key);

  @override
  State<ConsultaPage> createState() => _ConsultaPageState();
}

class _ConsultaPageState extends State<ConsultaPage> {
  int indexPet = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    indexPet = ModalRoute.of(context)!.settings.arguments as int;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(
        title: Consumer2<PetsRepository, ConsultasRepository>(
          builder: (context, pets, consultas, child) {
            return Row(
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
                Text(
                  "${pets.lista[indexPet].nome?.toUpperCase()}",
                  style: TextStyle(
                    fontSize: 16,
                    color: kPrimaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            );
          },
        ),
        elevation: 0,
        backgroundColor: kWhite,
        iconTheme: IconThemeData(color: kPrimaryColor),
      ),
      floatingActionButton: Consumer<PetsRepository>(
        builder: (context, pets, child) {
          return FloatingActionButton(
            backgroundColor: kPrimaryColor,
            isExtended: true,
            onPressed: () {
              

              addConsultaDialog(context, pets.lista[indexPet].id!);
            },
            child: Icon(Icons.add),
          );
        },
      ),
      body: Consumer2<PetsRepository, ConsultasRepository>(
        builder: (context, pets, consultas, child) {
          return Column(
            children: [
              Center(
                child: Image.asset(
                  "assets/images/ico_consulta.png",
                  height: 120,
                ),
              ),
              Espaco(),
              const Text(
                "Consultas",
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 20,
                  color: kPrimaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Espaco(),
              consultas.isLoading
                  ? Expanded(
                      child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [CircularProgressIndicator()],
                    ))
                  : (consultas.map[pets.lista[indexPet].id] != null &&
                          consultas.map[pets.lista[indexPet].id]!.isNotEmpty)
                      ? Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount:
                                consultas.map[pets.lista[indexPet].id]!.length,
                            itemBuilder: (context, index) {
                              final sortedConsultas = List<Consulta>.from(
                                  consultas.map[pets.lista[indexPet].id]!);
                              sortedConsultas.sort((a, b) => a.data!.compareTo(
                                  b.data!)); // Ordena pelo critério da data

                              final consulta = sortedConsultas[
                                  sortedConsultas.length - 1 - index];

                              return card(
                                consulta: consulta,
                                indexPet: indexPet,
                              );
                            },
                          ),
                        )
                      : Expanded(
                          child: Center(
                              child: Text("Nenhum consulta cadastrada"))),
            ],
          );
        },
      ),
    );
  }

  card({required Consulta consulta, required int indexPet}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          Positioned(
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerRight,
                  height: 40,
                  width: 60,
                  decoration: BoxDecoration(
                      color: kSecundaryColor,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10.0),
                      )),
                  child: Consumer2<ConsultasRepository, PetsRepository>(
                      builder: (context, consultas, pets, child) {
                    return InkWell(
                        onTap: () async {
                          addConsultaDialog(context, pets.lista[indexPet].id!,
                                  consulta: consulta);
                        },
                        child: Icon(
                          Icons.edit_outlined,
                          color: kWhite,
                        ));
                  }),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  height: 40,
                  width: 60,
                  decoration: BoxDecoration(
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(10.0),
                      )),
                  child: Consumer2<ConsultasRepository, PetsRepository>(
                      builder: (context, consultas, pets, child) {
                    return InkWell(
                        onTap: () async {
                          bool confirma = await showConformaDialog(
                              context,
                              "Deseja remover a Consulta cadastrada?",
                              "Remover");
                          if (confirma) consultas.remove(consulta, pets.lista[indexPet].id!);
                        },
                        child: Icon(
                          Icons.delete_outline,
                          color: kWhite,
                        ));
                  }),
                ),
              ],
            ),
          ),
          Positioned(
            child: Padding(
              padding: const EdgeInsets.only(right: 20),
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
                            Icons.medical_information,
                            color: kWhite,
                          ))),
                  title: Row(
                    children: [
                      Icon(
                        Icons.calendar_month,
                        size: 18,
                      ),
                      Text(
                        "${DateFormat('dd-MM-yyyy').format(consulta.data!)}     ",
                        style: TextStyle(
                            color: kSecundaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 12),
                      ),
                       if(consulta.custo!=null)
                    Text("${UtilBrasilFields.obterReal(consulta.custo!)}",
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
                      RichText(
                        text: TextSpan(
                            text: "Queixa: ",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 12),
                            children: [
                              TextSpan(
                                  text:
                                      "${consulta.queixa != '' ? consulta.queixa : '--'}",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 12)),
                            ]),
                      ),
                      RichText(
                        text: TextSpan(
                            text: "Diagnóstico: ",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 12),
                            children: [
                              TextSpan(
                                  text:
                                      "${consulta.diagnostico != '' ? consulta.diagnostico : '--'}",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 12)),
                            ]),
                      ),
                      Divider(),
                      RichText(
                        text: TextSpan(
                            text: "Veterinário: ",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 12),
                            children: [
                              TextSpan(
                                  text:
                                      "${consulta.nomeVeterinario != '' ? consulta.nomeVeterinario : '--'}",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 12)),
                            ]),
                      ),
                      Text(
                          "Retorno em: ${consulta.proximaData != null ? DateFormat('dd-MM-yyyy').format(consulta.proximaData!) : ''}",
                          style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w600,
                              fontSize: 12)),
                    ],
                  ),
                )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
