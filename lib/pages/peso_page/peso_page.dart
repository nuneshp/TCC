import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tcc_hugo/const_colors.dart';
import 'package:tcc_hugo/models/peso.dart';
import 'package:tcc_hugo/pages/peso_page/components/addPeso.dart';
import 'package:tcc_hugo/repositorys/peso_repository.dart';
import 'package:tcc_hugo/repositorys/pet_repository.dart';
import 'package:tcc_hugo/widgets/showConfirma.dart';
import 'package:tcc_hugo/widgets/util.dart';

class PesoPage extends StatefulWidget {
  static const routeName = '/peso';
  PesoPage({Key? key}) : super(key: key);

  @override
  State<PesoPage> createState() => _PesoPageState();
}

class _PesoPageState extends State<PesoPage> {
  @override
  Widget build(BuildContext context) {
    int indexPet = ModalRoute.of(context)!.settings.arguments as int;

    return Consumer2<PetsRepository, PesosRepository>(
      builder: (context, pets, pesos, child) {
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
                addPesoDialog(context, pets.lista[indexPet].id!);
              },
              child: Icon(Icons.add)),
          body: Column(
            children: [
              Center(
                  child: Image.asset(
                "assets/images/ico_peso.png",
                height: 120,
              )),
              Espaco(),
              const Text(
                "Minhas Pesagens",
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontSize: 20,
                    color: kPrimaryColor,
                    fontWeight: FontWeight.w600),
              ),
              Espaco(),
              pesos.isLoading
                  ? Expanded(
                      child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [CircularProgressIndicator()],
                    ))
                  : (pesos.map[pets.lista[indexPet].id] != null &&
                          pesos.map[pets.lista[indexPet].id]!.isNotEmpty)
                      ? Expanded(
                          child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20.0),
                              topRight: Radius.circular(20.0),
                            ),
                            color: kSecundaryColor
                                .withOpacity(0.3), // Cor de fundo do container
                          ),
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          // width: MediaQuery.of(context).size.width * 0.9,
                          padding: EdgeInsets.only(top: 20),
                          child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount:
                                  pesos.map[pets.lista[indexPet].id]!.length,
                              itemBuilder: (context, index) {
                                final sortedPesos = List<Peso>.from(
                                    pesos.map[pets.lista[indexPet].id]!);
                                sortedPesos.sort((a, b) => a.data!.compareTo(
                                    b.data!)); // Ordena pelo critério da data

                                final peso =
                                    sortedPesos[sortedPesos.length - 1 - index];

                                double pesoAnterior;
                                if ((sortedPesos.length - 2 - index) >= 0) {
                                  pesoAnterior = sortedPesos[
                                          sortedPesos.length - 2 - index]
                                      .peso!;
                                } else {
                                  pesoAnterior = peso.peso!;
                                }

                                return card(
                                    peso: peso,
                                    pesoAnterior: pesoAnterior,
                                    indexPet: indexPet);
                              }),
                        ))
                      : Expanded(
                          child: Center(child: Text("Nenhum peso cadastrado")))
            ],
          ),
        );
      },
    );
  }

  card(
      {required Peso peso,
      required double pesoAnterior,
      required int indexPet}) {
    bool _deletando = false;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Card(
        elevation: 5,
        child: Container(
            child: ListTile(

                dense: true,
                contentPadding: EdgeInsets.only(left:10),
                leading: ClipOval(
                    child: Container(
                        height: 40,
                        width: 40,
                        color: kSecundaryColor,
                        child: Icon(
                          Icons.balance,
                          color: kWhite,
                        ))),
                title: Row(
                  children: [
                    Icon(
                      Icons.calendar_month,
                      size: 18,
                    ),
                    Text(
                      "${DateFormat('dd-MM-yyyy').format(peso.data!)}",
                      style: TextStyle(
                          color: kSecundaryColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 12),
                    ),
                  ],
                ),
                subtitle: Row(
                  children: [
                    Text("   ${peso.peso} Kg  | ",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 15)),
                    Text(
                        "${((peso.peso! - pesoAnterior) > 0) ? "+" : ""}${(100 * (peso.peso! - pesoAnterior) / pesoAnterior).toStringAsFixed(2)}%",
                        style: TextStyle(
                            color: (peso.peso! - pesoAnterior) > 0
                                ? Colors.green
                                : Colors.red,
                            fontWeight: FontWeight.w600,
                            fontSize: 12)),
                  ],
                ),
                trailing: Consumer2<PetsRepository, PesosRepository>(
                      builder: (context, pets, pesos, child) {
                        return PopupMenuButton<String>(
                          onSelected: (value) async {
                            // Aqui você pode lidar com a opção selecionada
                            if (value == 'editar') {
                              addPesoDialog(context, pets.lista[indexPet].id!,
                                  peso: peso);
                            } else if (value == 'remover') {
                              bool confirma = await showConformaDialog(
                                  context,
                                  "Deseja remover o Peso cadastrado?",
                                  "Remover");

                              if (confirma) {
                                setState(() {
                                  _deletando = true;

                                  pesos.remove(peso, pets.lista[indexPet].id!);
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
