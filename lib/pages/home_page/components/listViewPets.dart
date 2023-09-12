import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:tcc_hugo/const_colors.dart';
import 'package:tcc_hugo/const_text_styles.dart';
import 'package:tcc_hugo/models/foto.dart';
import 'package:tcc_hugo/repositorys/foto_repository.dart';
import 'package:tcc_hugo/repositorys/pet_repository.dart';
import 'package:tcc_hugo/widgets/showAndNav.dart';
import 'package:tcc_hugo/widgets/showConfirma.dart';

class ListViewPets extends StatefulWidget {
  const ListViewPets({Key? key}) : super(key: key);

  @override
  State<ListViewPets> createState() => _ListViewPetsState();
}

class _ListViewPetsState extends State<ListViewPets> {
  @override
  Widget build(BuildContext context) {
    return Consumer<PetsRepository>(
      builder: (context, pets, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    "Meus Pets",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20,
                        color: kPrimaryColor,
                        fontWeight: FontWeight.w600),
                  ),
                  InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed('/addEditPet');
                      },
                      child: Row(children: [
                        Text("Adicionar ",
                            style: styleText1.copyWith(fontSize: 12)),
                        Icon(
                          Icons.add_circle_outline,
                          color: kPrimaryColor,
                        )
                      ]))
                ],
              ),
            ),
            pets.isLoading
                ? Container(
                  height: 150,
                  width: MediaQuery.of(context).size.width,
                  child: Center(child: CircularProgressIndicator()),
                )
                : Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    height: pets.lista.length == 0 ? 120 : 150,
                    child: pets.lista.length == 0
                        ? Container(
                            width: 120,
                            child: InkWell(
                                onTap: () {
                                  Navigator.pushNamed(context, "/addEditPet");
                                },
                                child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    elevation: 2,
                                    color: kPrimaryColor.withAlpha(150),
                                    child: Stack(
                                      children: [
                                        Align(
                                          alignment: Alignment.center,
                                          child: Lottie.asset(
                                            "assets/lotties/add.json",
                                          ),
                                        ),
                                        Align(
                                            alignment: Alignment.bottomCenter,
                                            child: Lottie.asset(
                                              "assets/lotties/cat_show.json",
                                            )),
                                      ],
                                    ))))
                        : ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: pets.lista.length,
                            itemBuilder: (context, index) {
                              return Container(
                                width: 120,
                                child: InkWell(
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    elevation: 2,
                                    color: kWhite,
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.vertical(
                                                top: Radius.circular(20)),
                                            child: AspectRatio(
                                              aspectRatio: 1 / 1,
                                              child: Container(
                                                  color: kPrimaryColor
                                                      .withAlpha(50),
                                                  child: pets.lista[index]
                                                              .foto !=
                                                          null
                                                      ? FadeInImage
                                                          .assetNetwork(
                                                              fit: BoxFit.cover,
                                                              placeholder:
                                                                  "assets/images/loading_pet.gif",
                                                              image: pets
                                                                  .lista[index]
                                                                  .foto!,
                                                              imageErrorBuilder:
                                                                  (context,
                                                                      error,
                                                                      stackTrace) {
                                                                return Image
                                                                    .asset(
                                                                  "assets/images/logo.png",
                                                                );
                                                              })
                                                      : Image.asset(
                                                          "assets/images/logo.png")),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Center(
                                              child: Text(
                                                pets.lista[index].nome!
                                                    .toUpperCase(),
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 10,
                                                    color: kPrimaryColor),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  onTap: () => Navigator.pushNamed(
                                      context, '/petDetalhes',
                                      arguments: index),
                                  onLongPress: () =>
                                      selectEditarRemoverDialog(index),
                                ),
                              );
                            },
                          )),
          ],
        );
      },
    );
  }

  Future<void> selectEditarRemoverDialog(int index) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Escolha a opção'),
          content: SingleChildScrollView(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.pushNamed(context, '/addEditPet',
                            arguments: index);
                      },
                      child: Column(children: [
                        ClipOval(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Lottie.asset("assets/lotties/edit_ico.json",
                              height: 80, repeat: true),
                        )),
                        Text("Editar")
                      ])),
                  Consumer2<PetsRepository, FotosRepository>(builder: (context, pets, fotos, child) {
                    return InkWell(
                        onTap: () async {
                          bool confirma = await showConformaDialog(
                              context,
                              "Deseja Remover ${pets.lista[index].nome}?",
                              "Remover",
                              descricao:
                                  "Ao remover o pet, todos os dados serão perdidos permanentemente!");
                          if (confirma) {
                            pets.remove(pets.lista[index], fotos.map[pets.lista[index].id]!);
                          
                          await showAndNav(
                                context: context,
                                image: "assets/lotties/delete.json");
                          }
                        },
                        child: Column(children: [
                          ClipOval(
                              child: Container(
                                  padding: EdgeInsets.all(8.0),
                                  child: Lottie.asset(
                                      "assets/lotties/delete_ico.json",
                                      height: 80,
                                      repeat: true))),
                          Text("Remover")
                        ]));
                  })
                ],
              )
            ],
          )),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
