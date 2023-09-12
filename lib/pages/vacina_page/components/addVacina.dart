import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tcc_hugo/const_colors.dart';
import 'package:tcc_hugo/models/vacina.dart';
import 'package:tcc_hugo/models/pet.dart';
import 'package:tcc_hugo/repositorys/vacina_repository.dart';
import 'package:tcc_hugo/widgets/dropDownGenerico.dart';
import 'package:tcc_hugo/widgets/textFormGenerico.dart';
import 'package:tcc_hugo/widgets/util.dart';
import 'package:wc_form_validators/wc_form_validators.dart';

Future<void> addVacinaDialog(context, String idPet,
    {String? familia, Vacina? vacina}) async {
  await showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AddVacina(idPet, familia, vacina);
    },
  );
}

class AddVacina extends StatefulWidget {
  String idPet;
  String? familia;
  Vacina? vacina;
  AddVacina(this.idPet, this.familia, this.vacina, {super.key});

  @override
  State<AddVacina> createState() => _AddVacinaState();
}

class _AddVacinaState extends State<AddVacina> {
  late Pet pet;
  TextEditingController data = TextEditingController();

  TextEditingController marca = TextEditingController();
  TextEditingController lote = TextEditingController();
  TextEditingController outraCategoria = TextEditingController();
  TextEditingController custo = TextEditingController();
  String categoria = "Polivalente";
  int repetirEm = 21;
  String dose = "1ª dose";
  late Map<String, String> listaCategorias;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.familia == "Felino") {
      listaCategorias = {
        'Polivalente': "Polivalente",
        'Raiva': 'Raiva',
      };
    } else {
      listaCategorias = {
        'Polivalente': "Polivalente",
        'Raiva': 'Raiva',
        'Giardia': 'Giardia',
        'Gripe': 'Gripe',
        'Leishmaniose': 'Leishmaniose',
      };
    }

    if (widget.vacina != null) {
      setState(() {
        categoria = widget.vacina!.categoria!;
        if (widget.vacina!.marca != null) marca.text = widget.vacina!.marca!;
        dose = widget.vacina!.dose!;
        data.text = DateFormat('dd-MM-yyyy').format(widget.vacina!.data!);
        _data = widget.vacina!.data!;
        if (widget.vacina!.custo != null)
          custo.text = UtilBrasilFields.obterReal(widget.vacina!.custo!);

        if (widget.vacina!.lote != null) lote.text = widget.vacina!.lote!;
        lote.text = widget.vacina!.lote!;

        repetirEm =
            widget.vacina!.proximaData!.difference(widget.vacina!.data!).inDays;
      });
    } else {
      data.text = DateFormat('dd-MM-yyyy').format(_data);
    }
  }

  DateTime _data = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(
        children: [
          ClipOval(
              child: Container(
                  height: 100,
                  color: kPrimaryColor,
                  child: Image.asset("assets/images/ico_vacina.png"))),
          Espaco(),
          Text(
            widget.vacina == null ? 'Adicionar Vacina' : 'Editar Vacina',
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
            Consumer<VacinasRepository>(
              builder: (context, vacinas, child) {
                if (vacinas.map[widget.idPet] != null)
                  for (Vacina vac in vacinas.map[widget.idPet]!) {
                    if (!listaCategorias.containsValue(vac.categoria)) {
                      listaCategorias[vac.categoria!] = vac.categoria!;
                    }
                  }

                listaCategorias['Outra'] = 'Outra';
                return DropDownGenerico(
                  map: listaCategorias,
                  label: "Categoria",
                  funcao: (String x) {
                    setState(() {
                      categoria = x;

                      if (x == "Outra") {
                        dose = "1ª dose";
                      }
                    });
                  },
                  valor: categoria,
                  prefix: Icons.category,
                );
              },
            ),
            if (categoria == "Outra") Espaco(),
            if (categoria == "Outra")
              TextFormGenerico(
                  controller: outraCategoria,
                  keyboardType: TextInputType.name,
                  label: "Nova Categoria",
                  prefix: Icons.abc),
            Espaco(),
            TextFormGenerico(
                controller: marca,
                keyboardType: TextInputType.name,
                label: "Marca",
                prefix: Icons.abc),
            Espaco(),
            Consumer<VacinasRepository>(builder: (context, vacinas, child) {
              Map<String, String> listaDoses = {
                '1ª dose': "1ª dose",
                '2ª dose': "2ª dose",
                "3ª dose": "3ª dose",
                "Reforço anual": "Reforço anual"
              };

              // for(Vacina vac in vacinas.map[widget.idPet]!){
              //   if(vac.categoria==categoria){
              //     if(vac.dose=="1ª dose"){
              //     listaDoses.remove("1ª dose");
              //     dose="2ª dose";
              //   }else if(vac.dose=="2ª dose"){
              //     listaDoses.remove("2ª dose");
              //     dose="3ª dose";
              //   }else if(vac.dose=="3ª dose"){
              //     listaDoses.remove("3ª dose");
              //     dose="Reforço anual";
              //   }
              //   }

              // }

              return DropDownGenerico(
                map: listaDoses,
                label: "Dose",
                funcao: (String x) {
                  setState(() {
                    dose = x;
                    if (x == "Reforço anual") {
                      repetirEm = 365;
                    }
                  });
                },
                valor: dose,
                prefix: Icons.colorize,
              );
            }),
            Espaco(),
            TextFormGenerico(
                controller: lote,
                keyboardType: TextInputType.name,
                label: "Lote",
                prefix: Icons.numbers),
            Espaco(),
            TextFormGenerico(
              controller: custo,
              label: "Custo (R\$)",
              prefix: Icons.currency_exchange_outlined,
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
              }, current:  widget.vacina?.data!),
            ),
            Espaco(),
            DropDownGenerico(
              map: {'21 dias': 21, '1 ano': 365},
              label: "Repetir em",
              funcao: (int x) {
                repetirEm = x;
              },
              valor: repetirEm,
              prefix: Icons.repeat,
            )
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
        Consumer<VacinasRepository>(
          builder: (context, vacinas, child) {
            return TextButton(
              child: Text(widget.vacina == null ? 'adicionar' : 'alterar'),
              onPressed: () {
               
                Vacina _vacina = Vacina(
                    data: _data,
                    categoria:
                        categoria == "Outra" ? outraCategoria.text : categoria,
                    marca: marca.text,
                    lote: lote.text,
                    dose: dose,
                    custo: (custo.text != "")
                        ? UtilBrasilFields.converterMoedaParaDouble(custo.text)
                        : 0,
                    proximaData: _data.add(Duration(days: repetirEm)));
                

                 if (widget.vacina != null)
                vacinas.update(widget.vacina!, _vacina, widget.idPet);
              else
                vacinas.set(_vacina, widget.idPet);

                Navigator.pop(context);
              },
            );
          },
        )
      ],
    );
  }
}
