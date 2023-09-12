import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tcc_hugo/const_colors.dart';
import 'package:tcc_hugo/models/vermifugo.dart';
import 'package:tcc_hugo/models/pet.dart';
import 'package:tcc_hugo/repositorys/vermifugo_repository.dart';
import 'package:tcc_hugo/widgets/dropDownGenerico.dart';
import 'package:tcc_hugo/widgets/textFormGenerico.dart';
import 'package:tcc_hugo/widgets/util.dart';
import 'package:wc_form_validators/wc_form_validators.dart';

Future<void> addVermifugoDialog(context, String idPet,
    {Vermifugo? vermifugo}) async {
  await showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AddVermifugo(idPet: idPet, vermifugo: vermifugo);
    },
  );
}

class AddVermifugo extends StatefulWidget {
  String idPet;
  Vermifugo? vermifugo;
  AddVermifugo({required this.idPet, this.vermifugo, super.key});

  @override
  State<AddVermifugo> createState() => _AddVermifugoState();
}

class _AddVermifugoState extends State<AddVermifugo> {
  late Pet pet;
  TextEditingController data = TextEditingController();
  TextEditingController marca = TextEditingController();

  TextEditingController custo = TextEditingController();
  int repetirEm = 90;
  int repetirEmDef = 0;

  DateTime _data = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.vermifugo != null) {
      setState(() {
        data.text = DateFormat('dd-MM-yyyy').format(widget.vermifugo!.data!);
        _data = widget.vermifugo!.data!;
        if (widget.vermifugo!.custo != null)
          custo.text = UtilBrasilFields.obterReal(widget.vermifugo!.custo!);

        if(widget.vermifugo!.marca!=null)
          marca.text = widget.vermifugo!.marca!;
      });

      final repetir = widget.vermifugo!.proximaData!
          .difference(widget.vermifugo!.data!)
          .inDays;
      if (repetir == 15 || repetir == 30 || repetir == 90) {
        setState(() {
          repetirEm = repetir;
        });
      } else {
        setState(() {
          repetirEm = 0;
          repetirEmDef = repetir;
        });
      }
    } else {
      data.text = DateFormat('dd-MM-yyyy').format(_data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(
        children: [
          ClipOval(
              child: Container(
                  height: 100,
                  color: kPrimaryColor,
                  child: Image.asset("assets/images/ico_vermifugo.png"))),
          Espaco(),
          Text(
            widget.vermifugo == null
                ? 'Adicionar Vermífugo'
                : 'Editar Vermífugo',
            style: TextStyle(color: kPrimaryColor),
          ),
        ],
      ),
      content: Container(
        child: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Espaco(),
            TextFormGenerico(
                controller: marca,
                keyboardType: TextInputType.name,
                label: "Marca",
                prefix: Icons.abc),
            Espaco(),
            TextFormGenerico(
              controller: custo,
              label: "Custo (R\$)",
              prefix: Icons.currency_exchange_outlined,
              validator: Validators.required("Digite a Data do Banho"),
              keyboardType: TextInputType.number,
              moeda: true,
            ),
            Espaco(),
            TextFormGenerico(
              controller: data,
              label: "Data da Administração",
              prefix: Icons.date_range_outlined,
              validator: Validators.required("Digite a Data da Administração"),
              keyboardType: TextInputType.none,
              onTap: () => Util().getData(context, (date) {
                _data = date;
                data.text = DateFormat('dd-MM-yyyy').format(date);
              },current: widget.vermifugo?.data!),
            ),
            Espaco(),
            DropDownGenerico(
              map: {'15 dias': 15, '30 dias': 30, '3 meses': 90, 'Definir': 0},
              label: "Repetir em",
              funcao: (int x) {
                setState(() {
                  repetirEm = x;
                });
              },
              valor: repetirEm,
              prefix: Icons.repeat,
            ),
            repetirEm == 0
                ? Row(
                    children: [
                      Slider(
                        value: repetirEmDef
                            .toDouble(), // Converte o valor para double
                        min: 0, // Valor mínimo do volume (int)
                        max: 100, // Valor máximo do volume (int)
                        onChanged: (newValue) {
                          setState(() {
                            repetirEmDef = newValue
                                .toInt(); // Converte o novo valor para int
                          });
                        },
                        activeColor: kPrimaryColor,
                      ),
                      Text(
                        "${repetirEmDef} ${(repetirEmDef != 1) ? 'dias' : 'dia'}", // Exibe o valor atual do Slider
                        style: TextStyle(
                            color:
                                kPrimaryColor), // Define a cor do texto como vermelho
                      )
                    ],
                  )
                : Container()
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
        Consumer<VermifugosRepository>(builder: (context, vermifugos, child) {
          return TextButton(
            child: Text(widget.vermifugo == null ? 'adicionar' : 'alterar'),
            onPressed: () {
              Vermifugo _vermifugo = Vermifugo(
                  data: _data,
                  marca: marca.text,
                  proximaData: _data.add(repetirEm != 0
                      ? Duration(days: repetirEm)
                      : Duration(days: repetirEmDef)),
                  custo: (custo.text != "")
                      ? UtilBrasilFields.converterMoedaParaDouble(custo.text)
                      : 0);

              if (widget.vermifugo != null)
                vermifugos.update(widget.vermifugo!, _vermifugo, widget.idPet);
              else
                vermifugos.set(_vermifugo, widget.idPet);

              Navigator.pop(context);
            },
          );
        })
      ],
    );
  }
}
