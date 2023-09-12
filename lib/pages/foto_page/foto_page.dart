import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tcc_hugo/const_colors.dart';
import 'package:tcc_hugo/models/foto.dart';
import 'package:tcc_hugo/repositorys/foto_repository.dart';
import 'package:tcc_hugo/repositorys/pet_repository.dart';
import 'package:tcc_hugo/widgets/selectCameraGaleria.dart';
import 'package:tcc_hugo/widgets/showConfirma.dart';
import 'package:tcc_hugo/widgets/util.dart';

import 'components/addFoto.dart';

class FotoPage extends StatefulWidget {
  static const routeName = '/foto';
  FotoPage({Key? key}) : super(key: key);

  @override
  State<FotoPage> createState() => _FotoPageState();
}

class _FotoPageState extends State<FotoPage> {
  int indexPet = 0;
  int gridNumber = 3;
  bool aguardeSalvarImagem = false;

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
        title: Consumer2<PetsRepository, FotosRepository>(
          builder: (context, pets, fotos, child) {
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
            onPressed: () async {
              ImageSource? select = await selectCameraGaleriaDialog(context);
              if (select != null) {
                XFile? foto = await Util().getImage(select);

                if (foto != null)
                  addFotoDialog(context, pets.lista[indexPet].id!, foto);
              }
            },
            child: Icon(Icons.add),
          );
        },
      ),
      body: SingleChildScrollView(
        child: Consumer2<PetsRepository, FotosRepository>(
          builder: (context, pets, fotos, child) {
            return Column(
              children: [
                Center(
                  child: Image.asset(
                    "assets/images/ico_foto.png",
                    height: 120,
                  ),
                ),
                Espaco(),
                const Text(
                  "Fotos",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 20,
                    color: kPrimaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Espaco(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          gridNumber = 3;
                        });
                      },
                      icon: Icon(Icons.grid_on_outlined),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          gridNumber = 1;
                        });
                      },
                      icon: Icon(Icons.image_outlined),
                    ),
                    if (fotos.map[pets.lista[indexPet].id] != null)
                      RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                              text:
                                  "${fotos.map[pets.lista[indexPet].id]!.length}\n",
                              style: TextStyle(
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.bold),
                              children: [
                                TextSpan(
                                    text: fotos.map[pets.lista[indexPet].id]!
                                                .length ==
                                            1
                                        ? "foto"
                                        : "fotos",
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal))
                              ])),
                  ],
                ),
                Divider(),
                Espaco(),
                fotos.isLoading
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [CircularProgressIndicator()],
                      )
                    : (fotos.map[pets.lista[indexPet].id] != null &&
                            fotos.map[pets.lista[indexPet].id]!.isNotEmpty)
                        ? (gridNumber == 3)
                            ? GridView.count(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                crossAxisCount:
                                    gridNumber, // Número de colunas desejado (neste caso, 3 colunas)
                                crossAxisSpacing:
                                    0, // Espaçamento horizontal entre os itens
                                mainAxisSpacing:
                                    0, // Espaçamento vertical entre os itens
                                children: List.generate(
                                  fotos.map[pets.lista[indexPet].id]!.length,
                                  (index) {
                                    return card(
                                      foto: fotos
                                          .map[pets.lista[indexPet].id]![index],
                                      idPet: pets.lista[indexPet].id!,
                                    );
                                  },
                                ),
                              )
                            : Column(children: [
                                ...fotos.map[pets.lista[indexPet].id]!
                                    .map((foto) {
                                  return card(
                                    foto: foto,
                                    idPet: pets.lista[indexPet].id!,
                                  );
                                }).toList()
                              ])
                        : Center(child: Text("Nenhuma foto cadastrada")),
              ],
            );
          },
        ),
      ),
    );
  }

  card({required Foto foto, required String idPet}) {
    bool _deletando = false;
    return InkWell(
      onTap: () async {
        if (gridNumber == 3) {
          await showDialog<void>(
            context: context,
            barrierDismissible: false, // user must tap button!
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: Colors.transparent,
                contentPadding: EdgeInsets.zero,
                content: IntrinsicHeight(
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Card(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FadeInImage.assetNetwork(
                                  fit: BoxFit.cover,
                                  placeholder: "assets/images/loading_pet.gif",
                                  image: foto.foto!,
                                  imageErrorBuilder:
                                      (context, error, stackTrace) {
                                    return Image.asset(
                                      "assets/images/logo.png",
                                    );
                                  }),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, right: 10, top: 10),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_month,
                                      size: 18,
                                    ),
                                    Text(
                                      "${DateFormat('dd-MM-yyyy').format(foto.data!)}",
                                      style: TextStyle(
                                          color: kSecundaryColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                              Espaco(),
                              Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 10.0, left: 10, right: 10),
                                child: Text(foto.legenda!),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          InkWell(
                            onTap: () => Navigator.pop(context),
                            child: ClipOval(
                                child: Container(
                                    height: 30,
                                    width: 30,
                                    color: kSecundaryColor,
                                    child: Icon(
                                      Icons.close,
                                      color: kWhite,
                                    ))),
                          ),
                          Espaco(
                            height: 20,
                          ),
                          Consumer<FotosRepository>(
                            builder: (context, fotos, child) {
                              bool aguarde = false;
                              if (fotos.isLoading)
                                return CircularProgressIndicator();

                              return InkWell(
                                onTap: () async {
                                  bool confirma = await showConformaDialog(
                                      context,
                                      "Deseja remover a Foto?",
                                      "Remover");

                                  if (confirma) {
                                    setState(() {
                                      aguarde = true;
                                    });

                                    await fotos.remove(foto, idPet);

                                    setState(() {
                                      aguarde = false;
                                    });
                                  }
                                 

                                  Navigator.pop(context);
                                },
                                child: ClipOval(
                                    child: Container(
                                        height: 30,
                                        width: 30,
                                        color: kSecundaryColor,
                                        child: aguarde?CircularProgressIndicator(): Icon(
                                          Icons.delete,
                                          color: kWhite,
                                        ))),
                              );
                            },
                          ),
                          Espaco(
                            height: 20,
                          ),
                          InkWell(
                            onTap: () async {

                              setState(() {
                                aguardeSalvarImagem=true;
                              });
                              await GallerySaver.saveImage(foto.foto!)
                                  .then((success) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content:
                                            Text("Imagem salva na galeria!")));
                              });

                              setState(() {
                                aguardeSalvarImagem=false;
                              });

                              Navigator.pop(context);
                            },
                            child: ClipOval(
                                child: Container(
                                    height: 30,
                                    width: 30,
                                    color: kSecundaryColor,
                                    child: aguardeSalvarImagem?CircularProgressIndicator(): Icon(
                                      Icons.download,
                                      color: kWhite,
                                    ))),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
      child: Padding(
        padding: gridNumber == 1
            ? const EdgeInsets.symmetric(horizontal: 5)
            : EdgeInsets.zero,
        child: Card(
          elevation: 5,
          child: Column(
            children: [
              FadeInImage.assetNetwork(
                  fit: BoxFit.cover,
                  placeholder: "assets/images/loading_pet.gif",
                  image: foto.foto!,
                  imageErrorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      "assets/images/logo.png",
                    );
                  }),
              if (gridNumber == 1)
                Container(
                    padding: EdgeInsets.all(10),
                    // height: 60,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_month,
                              size: 18,
                            ),
                            Text(
                              "${DateFormat('dd-MM-yyyy').format(foto.data!)}",
                              style: TextStyle(
                                  color: kSecundaryColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12),
                            ),
                          ],
                        ),
                        Espaco(),
                        Text(foto.legenda!),
                      ],
                    ))
            ],
          ),
          
        ),
      ),
    );
  }
}
