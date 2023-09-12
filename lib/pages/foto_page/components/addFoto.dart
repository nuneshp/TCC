import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tcc_hugo/const_colors.dart';
import 'package:tcc_hugo/models/foto.dart';
import 'package:tcc_hugo/repositorys/foto_repository.dart';
import 'package:tcc_hugo/services/auth_service.dart';
import 'package:tcc_hugo/services/storage.dart';
import 'package:tcc_hugo/widgets/circularProgress.dart';
import 'package:tcc_hugo/widgets/showAndNav.dart';
import 'package:tcc_hugo/widgets/textFormGenerico.dart';

Future<void> addFotoDialog(
    BuildContext context, String idPet, XFile foto) async {
  await showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return addFoto(
        idPet: idPet,
        foto: foto,
      );
    },
  );
}

class addFoto extends StatefulWidget {
  String idPet;
  XFile foto;
  addFoto({required this.idPet, required this.foto, super.key});

  @override
  State<addFoto> createState() => _addFotoState();
}

class _addFotoState extends State<addFoto> {
  TextEditingController legenda = TextEditingController();
  double percentCarregado = 0;
  bool loading = false;
  String? textStatus;
  String? downloadUrl;
  
  @override
  Widget build(BuildContext context) {
  
    return 
    Stack(
      children: [
        AlertDialog(
          title: Column(
            children: [
              ClipRRect(
                  child: Container(
                      color: kPrimaryColor,
                      child: Image.file(File(widget.foto.path)))),
            ],
          ),
          content: Container(
            child: SingleChildScrollView(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextFormGenerico(
                  controller: legenda,
                  label: "Legenda",
                  prefix: Icons.currency_exchange_outlined,
                  keyboardType: TextInputType.text,
                ),
              ],
            )),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            Consumer2<AuthService, FotosRepository>(
                builder: (context, auth, fotos, child) {
              return TextButton(
                child: const Text('adicionar'),
                onPressed: () async {
                  setState(() {
                    loading=true;
                  });

                  UploadTask task =
                      await Storage(auth: auth).upload(widget.foto.path);

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

                      setState(() => textStatus = "Salvando informações");
                      final foto = Foto(
                          foto: downloadUrl,
                          legenda: legenda.text,
                          data: DateTime.now());
                      try {
                        await fotos.set(foto, widget.idPet);
                        
                        showAndNav(
                          context: context,
                          image: "assets/lotties/sucesso.json",
                          
                        );

                        setState(() {
                          loading = false;
                        });
                      } catch (e) {
                        showAndNav(
                          context: context,
                          image: "assets/lotties/falha.json",
                        );

                        setState(() {
                          loading = false;
                        });
                      }
                    }
                  });

                },
              );
            })
          ],
        ),
        CircularProgress(textStatus: textStatus, visible: loading)
      ],
    );
  }
}
