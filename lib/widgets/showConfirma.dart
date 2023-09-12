import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tcc_hugo/const_colors.dart';
import 'package:tcc_hugo/models/banho.dart';
import 'package:tcc_hugo/repositorys/banho_repository.dart';
import 'package:tcc_hugo/widgets/dropDownGenerico.dart';
import 'package:tcc_hugo/widgets/textFormGenerico.dart';
import 'package:tcc_hugo/widgets/util.dart';
import 'package:wc_form_validators/wc_form_validators.dart';

Future<bool> showConformaDialog(BuildContext context, String txt, String acao, {String? descricao}) async {
  bool resposta= false;
  await showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(txt),
        content: descricao!=null?Text(descricao):null,
        actions: [
          TextButton(onPressed: (){
            
            Navigator.pop(context);
          }, child: Text("Cancelar")),
          TextButton(onPressed: (){
            resposta = true;
            Navigator.pop(context);
          }, child: Text(acao))
        ],
      );
    },
  );

  return resposta;
}
