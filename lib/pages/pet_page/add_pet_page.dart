import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:tcc_hugo/const_colors.dart';
import 'package:tcc_hugo/models/pet.dart';
import 'package:tcc_hugo/repositorys/pet_repository.dart';
import 'package:tcc_hugo/services/auth_service.dart';
import 'package:tcc_hugo/services/storage.dart';
import 'package:tcc_hugo/widgets/buttonGenerico.dart';
import 'package:tcc_hugo/widgets/circularProgress.dart';
import 'package:tcc_hugo/widgets/showAndNav.dart';
import 'package:tcc_hugo/widgets/radioButton.dart';
import 'package:tcc_hugo/widgets/textFormGenerico.dart';
import 'package:tcc_hugo/widgets/util.dart';
import 'package:wc_form_validators/wc_form_validators.dart';

import '../../widgets/selectCameraGaleria.dart';

class AddPetPage extends StatefulWidget {
  static const routeName = '/addEditPet';
  AddPetPage({Key? key}) : super(key: key);

  @override
  State<AddPetPage> createState() => _AddPetPageState();
}

class _AddPetPageState extends State<AddPetPage> {
  TextEditingController nome = TextEditingController();
  TextEditingController raca = TextEditingController();
  TextEditingController sexo = TextEditingController();
  
  TextEditingController familia = TextEditingController();
  TextEditingController nascimento = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  //
  bool iniciado = false;
  bool loading = false;
  String? textStatus;
  late PetsRepository pets;
  late AuthService auth;
  //
  late DateTime _nasciemnto;
  double percentCarregado = 0;
  XFile? tempImage; //imagem a ser feito upload
  int? tempIndex; //indice do pet na lista do repositório
  late String? tempIdPet;
  late String? downloadUrl; //URL da imagem apos uplaod
  late String?
      tempURL; //URL da imagem antiga para remoçao caso esteja atualizando

  Future<void> uploadImagemAndSave() async {
    if (tempImage != null) {
      UploadTask task = await Storage(auth: auth).upload(tempImage!.path);

      task.snapshotEvents.listen((TaskSnapshot snapshot) async {
        if (snapshot.state == TaskState.running) {
          setState(() {
            percentCarregado =
                (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
            textStatus =
                "Enviando foto... ${percentCarregado.toStringAsFixed(2)}% ";
          });
        } else if (snapshot.state == TaskState.success) {
          downloadUrl = await snapshot.ref.getDownloadURL();
          save();
        }
      });
    } else {
      //apenas add sem foto
      tempURL = null;
      save();
    }

  }

  save() {
    setState(() => textStatus = "Salvando informações");
    if (tempIndex != null) {
      editar();
    } else {
      adicionar();
    }

    
  }

  adicionar() async {
    final pet = Pet(
        nome: nome.text,
        foto: tempImage != null ? downloadUrl : null,
        raca: raca.text,
        nascimento: _nasciemnto,
        sexo: sexo.text,
        familia: familia.text
        );
    try {
      await pets.setPet(pet);

      showAndNav(
          context: context,
          image: "assets/lotties/sucesso.json",
          // routeName: "/"
          );
      

      setState(() {
        loading = false;
      });
    } on AuthException catch (e) {
      showAndNav(
        context: context,
        image: "assets/lotties/falha.json",
      );

      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
    
  }

  editar() async {
    final pet = Pet(
        id: tempIdPet,
        nome: nome.text,
        foto: downloadUrl,
        raca: raca.text,
        nascimento: _nasciemnto,
        familia: familia.text,
        sexo: sexo.text);
    try {
      await pets.update(pet: pet, oldURL: tempURL);

      showAndNav(
          context: context,
          image: "assets/lotties/sucesso.json",
          // routeName: "/"
          );
      setState(() {
        loading = false;
      });
    } on AuthException catch (e) {
      showAndNav(
        context: context,
        image: "assets/lotties/falha.json",
      );

      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }

   
  }

  @override
  Widget build(BuildContext context) {
    pets = context.watch<PetsRepository>();
    auth = Provider.of<AuthService>(context);

    final indexPet = ModalRoute.of(context)!.settings.arguments as int?;
    if (indexPet != null && !iniciado) {
      nome.text = pets.lista[indexPet].nome!;
      raca.text = pets.lista[indexPet].raca!;
      sexo.text = pets.lista[indexPet].sexo!;

      if(pets.lista[indexPet].familia==null){
        familia.text = "Canino";
      }else{
        familia.text = pets.lista[indexPet].familia!;
      }
      
      nascimento.text =
          DateFormat('dd-MM-yyyy').format(pets.lista[indexPet].nascimento!);
      _nasciemnto = pets.lista[indexPet].nascimento!;
      downloadUrl = pets.lista[indexPet].foto;
      tempIndex = indexPet;
      tempURL = downloadUrl;
      tempIdPet = pets.lista[indexPet].id;
      iniciado = true;
    }

    return Scaffold(
        backgroundColor: kWhite,
        appBar: AppBar(
          title: Text(indexPet == null ? "Adicionar Pet" : "Editar Pet",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 16,
                  color: kPrimaryColor,
                  fontWeight: FontWeight.w600)),
          iconTheme: IconThemeData(color: kPrimaryColor),
          backgroundColor: kWhite,
          elevation: 0,
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Form(
                  autovalidateMode: AutovalidateMode.always,
                  key: _formKey,
                  child: Column(
                    children: [
                      InkWell(
                            child:Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          
                           tempImage != null
                                ? ClipOval(
                                    child: Image.file(File(tempImage!.path), height: 180,),
                                 
                                    )
                                : Container(
                                    height: 180,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    child: (indexPet != null &&
                                            pets.lista[indexPet].foto != null)
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(360),
                                            child: AspectRatio(
                                              aspectRatio: 1 / 1,
                                              child: FadeInImage.assetNetwork(
                                                  fit: BoxFit.cover,
                                                  placeholder:
                                                      "assets/images/logo.png",
                                                  image: pets
                                                      .lista[indexPet].foto!),
                                            ),
                                          )
                                        : Image.asset(
                                            "assets/images/logo.png",
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                            
                          
                          ClipOval(
                              child: Container(
                                  padding: EdgeInsets.all(5),
                                  color: kSecundaryColor,
                                  child: Icon(
                                    (tempImage!=null || (indexPet!=null && pets.lista[indexPet].foto != null) ) ?Icons.edit:
                                    Icons.photo_camera,
                                    size: 40,
                                    color: kWhite,
                                  ))),
                        ],),
                        onTap: () async {
                              ImageSource? select =
                                  await selectCameraGaleriaDialog(context);
                              if (select != null) {
                                XFile? temp = await Util().getImage(select);
                                setState(() {
                                  tempImage = temp;
                                });
                              }
                            },
                      ),
                      Espaco(height: 30),
                      TextFormGenerico(
                        controller: nome,
                        label: "Nome",
                        prefix: Icons.pets,
                        validator: Validators.required("Digite o nome do Pet"),
                      ),
                      Espaco(),
                      TextFormGenerico(
                        controller: raca,
                        label: "Raça",
                        prefix: Icons.category_outlined,
                      ),
                      Espaco(),
                      TextFormGenerico(
                        controller: nascimento,
                        label: "Nascimento",
                        prefix: Icons.date_range_outlined,
                        validator:
                            Validators.required("Digite a Data e Nascimento"),
                        keyboardType: TextInputType.none,
                        onTap: () => Util().getData(context, (date) {
                          _nasciemnto = date;
                          nascimento.text =
                              DateFormat('dd-MM-yyyy').format(date);
                        }),
                      ),
                      Espaco(),
                      RadioButton(controller: familia, itens: const ['Canino', 'Felino'],),
                      Espaco(),
                      RadioButton(controller: sexo, itens: const ['Macho', 'Fêmea'],),
                      Espaco(height: 30),
                      ButtonGenerico(
                        label: (indexPet == null) ? "Adicionar" : "Alterar",
                        onPressed: () async{
                          if (_formKey.currentState!.validate()) {
                            setState(() => loading = true);
                              
                             await uploadImagemAndSave();
                           
                               
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            CircularProgress(textStatus: textStatus, visible: loading),
          ],
        ));
  }
}
