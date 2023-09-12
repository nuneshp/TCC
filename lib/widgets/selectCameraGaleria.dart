
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';


Future<ImageSource?> selectCameraGaleriaDialog(context) async {
    ImageSource? _escolhido;
    await showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Escolher a partir de'),
          content: SingleChildScrollView(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                  onTap: () {
                    _escolhido = ImageSource.camera;
                    Navigator.of(context).pop();
                  },
                  child: Column(
                    children: [
                      Lottie.asset("assets/lotties/camera.json", height: 120),
                      Text("Câmera")
                    ],
                  ), ),
              InkWell(
                  onTap: () {
                    _escolhido = ImageSource.gallery;
                    Navigator.of(context).pop();
                  },
                  child: Column(
                    children: [
                      Lottie.asset("assets/lotties/galeria.json", height: 120),
                      Text("Galeria")
                    ],
                  ))
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

    return _escolhido;
  }