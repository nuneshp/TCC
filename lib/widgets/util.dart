import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import 'package:tcc_hugo/const_colors.dart';

class Espaco extends StatelessWidget {
  double height;
  Espaco({Key? key, this.height = 10}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
    );
  }
}

class Util {
  Future<XFile?> getImage(ImageSource source) async {
    final ImagePicker _picker = ImagePicker();
    XFile? image =
        await _picker.pickImage(source: source, maxHeight: 800, maxWidth: 800);

    if (image != null) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        cropStyle: CropStyle.circle,
        sourcePath: image.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
        ],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Posicionar Imagem',
              toolbarColor: kSecundaryColor,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: true),
        ],
      );

      image = XFile(croppedFile!.path);
    }

    return image;
  }

  getData(context, Function(DateTime)? onTap, {DateTime? current}) {
    DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: DateTime.now().subtract(const Duration(days: 365 * 20)),
        maxTime: DateTime.now(),
        onChanged: onTap,
        onConfirm: onTap,
        currentTime: current!=null?current:DateTime.now(),
        locale: LocaleType.pt);
  }

  String idadePet(DateTime nascimento) {
    int diferenca = DateTime.now().difference(nascimento).inDays;

    int anos = (diferenca / 365).truncate();
    int meses = ((diferenca - 365 * anos) / 30).truncate();

    String idade = "";
    if (anos > 0) {
      idade += "$anos ano";
      if (anos > 1) {
        idade += "s";
      }
    }else if(anos==0 && meses==0){
      idade = "$diferenca dia";
      if(diferenca>1){
        idade+="s";
      }
    }

    if (anos > 0 && meses > 0) {
      idade += " e";
    }

    if (meses > 1) {
      idade += " $meses meses";
    } else if (meses > 0) {
      idade += " $meses mês";
    }

    return idade;
  }
}
