import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tcc_hugo/const_colors.dart';
import 'package:tcc_hugo/models/tosa.dart';
import 'package:tcc_hugo/models/pet.dart';
import 'package:tcc_hugo/repositorys/tosa_repository.dart';
import 'package:tcc_hugo/widgets/dropDownGenerico.dart';
import 'package:tcc_hugo/widgets/textFormGenerico.dart';
import 'package:tcc_hugo/widgets/util.dart';
import 'package:wc_form_validators/wc_form_validators.dart';

Future<void> addTosaDialog(context, String idPet, {Tosa? tosa}) async {
  await showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AddTosa(idPet: idPet, tosa: tosa);
    },
  );
}

class AddTosa extends StatefulWidget {
  String idPet;
  Tosa? tosa;
  AddTosa({required this.idPet, this.tosa, super.key});

  @override
  State<AddTosa> createState() => _AddTosaState();
}

class _AddTosaState extends State<AddTosa> {
  //  late TosasRepository tosas;
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
    if (widget.tosa != null) {
      setState(() {
        data.text = DateFormat('dd-MM-yyyy').format(widget.tosa!.data!);
        _data = widget.tosa!.data!;
        if (widget.tosa!.custo != null)
          custo.text = UtilBrasilFields.obterReal(widget.tosa!.custo!);
      });

      final repetir =
          widget.tosa!.proximaData!.difference(widget.tosa!.data!).inDays;
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
                  child: Image.asset("assets/images/ico_tosa.png"))),
          Espaco(),
          Text(
            widget.tosa == null ? 'Adicionar tosa' : 'Editar tosa',
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
              controller: data,
              label: "Data do tosa",
              prefix: Icons.date_range_outlined,
              validator: Validators.required("Digite a Data do tosa"),
              keyboardType: TextInputType.none,
              onTap: () => Util().getData(context, (date) {
                _data = date;
                data.text = DateFormat('dd-MM-yyyy').format(date);
              },current: widget.tosa?.data!),
            ),
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
        Consumer<TosasRepository>(
          builder: (context, tosas, child) {
            return TextButton(
              child: Text(widget.tosa == null ? 'adicionar' : 'alterar'),
              onPressed: () {
                Tosa _tosa = Tosa(
                    data: _data,
                    proximaData: _data.add(repetirEm != 0
                        ? Duration(days: repetirEm)
                        : Duration(days: repetirEmDef)),
                    custo: (custo.text != "")
                        ? UtilBrasilFields.converterMoedaParaDouble(custo.text)
                        : 0);

                if (widget.tosa != null)
                  tosas.update(widget.tosa!, _tosa, widget.idPet);
                else
                  tosas.set(_tosa, widget.idPet);

                Navigator.pop(context);
              },
            );
          },
        )
      ],
    );
  }
}
