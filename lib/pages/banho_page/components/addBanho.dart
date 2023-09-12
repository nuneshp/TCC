import 'package:brasil_fields/brasil_fields.dart';
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

Future<void> addBanhoDialog(BuildContext context, String idPet,
    {Banho? banho}) async {
  await showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return addBanho(idPet: idPet, banho: banho,);
    },
  );
}

class addBanho extends StatefulWidget {
  String idPet;
  Banho? banho;
  addBanho({required this.idPet, this.banho, super.key});

  @override
  State<addBanho> createState() => _addBanhoState();
}

class _addBanhoState extends State<addBanho> {
  TextEditingController data = TextEditingController();
  TextEditingController marca = TextEditingController();
  TextEditingController custo = TextEditingController();
  int repetirEm = 7;
  int repetirEmDef = 0;

  DateTime _data = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
    if (widget.banho != null) {
      setState(() {
      data.text = DateFormat('dd-MM-yyyy').format(widget.banho!.data!);
      _data = widget.banho!.data!;

      if(widget.banho!.custo!=null)
      custo.text = UtilBrasilFields.obterReal(widget.banho!.custo!);
  
      });
      
      final repetir =
          widget.banho!.proximaData!.difference(widget.banho!.data!).inDays;
      if (repetir == 7 || repetir == 15 || repetir == 30 || repetir == 90) {
        setState(() {
          repetirEm = repetir;
        });
      } else {
        setState(() {
          repetirEm = 0;
          repetirEmDef = repetir;
        });
      }
    }
    else{
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
                  child: Image.asset("assets/images/ico_banho.png"))),
          Espaco(),
           Text(
            widget.banho==null?'Adicionar Banho':'Editar Banho',
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
              label: "Data do Banho",
              prefix: Icons.date_range_outlined,
              validator: Validators.required("Digite a Data do Banho"),
              keyboardType: TextInputType.none,
              onTap: () => Util().getData(context, (date) {

                _data = date;
                data.text = DateFormat('dd-MM-yyyy').format(date);
              }, current: widget.banho?.data!),
            ),
            Espaco(),
            TextFormGenerico(
              controller: custo,
              label: "Custo (R\$)",
              prefix: Icons.currency_exchange_outlined,
              keyboardType: TextInputType.number,
              moeda: true,
            ),
            Espaco(),
            DropDownGenerico(
              map: {
                '7 dias': 7,
                '15 dias': 15,
                '30 dias': 30,
                '3 meses': 90,
                'Definir': 0
              },
              label: "Repetir em",
              funcao: (int x) {
                setState(() {
                  repetirEm = x;
                });
              },
              valor: [7, 15, 30, 90].contains(repetirEm) ? repetirEm : 0,
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
        Consumer<BanhosRepository>(builder: (context, banhos, child) {
          return TextButton(
            child: Text(widget.banho==null?'adicionar':'alterar'),
            onPressed: () {
              Banho _banho = Banho(
                  data: _data,
                  proximaData: _data.add(repetirEm != 0
                      ? Duration(days: repetirEm)
                      : Duration(days: repetirEmDef)),
                  custo: (custo.text != "") ? UtilBrasilFields.converterMoedaParaDouble(custo.text) : 0);

              if (widget.banho != null)
                banhos.update(widget.banho!, _banho, widget.idPet);
              else
                banhos.set(_banho, widget.idPet);

              Navigator.pop(context);
            },
          );
        })
      ],
    );
  }
}
