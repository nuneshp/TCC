import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tcc_hugo/const_colors.dart';
import 'package:tcc_hugo/models/consulta.dart';
import 'package:tcc_hugo/repositorys/consulta_repository.dart';
import 'package:tcc_hugo/widgets/dropDownGenerico.dart';
import 'package:tcc_hugo/widgets/textFormGenerico.dart';
import 'package:tcc_hugo/widgets/util.dart';
import 'package:wc_form_validators/wc_form_validators.dart';

Future<void> addConsultaDialog(BuildContext context, String idPet,{Consulta? consulta}) async {
  await showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return addConsulta(idPet: idPet, consulta: consulta);
    },
  );
}

class addConsulta extends StatefulWidget {
  String idPet;
  Consulta? consulta;
  addConsulta({required this.idPet, this.consulta, super.key});

  @override
  State<addConsulta> createState() => _addConsultaState();
}

class _addConsultaState extends State<addConsulta> {
  
  TextEditingController data = TextEditingController();
  TextEditingController marca = TextEditingController();
  
  TextEditingController custo = TextEditingController();
  TextEditingController queixa = TextEditingController();
  TextEditingController diagnostico = TextEditingController();
  TextEditingController nomeVeterinario = TextEditingController();
  int repetirEm = 15;
  int repetirEmDef = 0;

  DateTime _data = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
    if (widget.consulta != null) {
      setState(() {
      data.text = DateFormat('dd-MM-yyyy').format(widget.consulta!.data!);
      _data = widget.consulta!.data!;
      if(widget.consulta!.custo!=null)
      custo.text = UtilBrasilFields.obterReal(widget.consulta!.custo!);
      if(widget.consulta!.queixa!=null)
      queixa.text = widget.consulta!.queixa!;
      if(widget.consulta!.diagnostico!=null)
      diagnostico.text = widget.consulta!.diagnostico!;
      if(widget.consulta!.nomeVeterinario!=null)
      nomeVeterinario.text = widget.consulta!.nomeVeterinario!;

      final repetir = widget.consulta!.proximaData!
          .difference(widget.consulta!.data!)
          .inDays;
      if (repetir==7 || repetir == 15 || repetir == 30) {
        setState(() {
          repetirEm = repetir;
        });
      } else {
        setState(() {
          repetirEm = 0;
          repetirEmDef = repetir;
        });
      }
  
      });
      
     
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
                  child: Image.asset("assets/images/ico_consulta.png"))),
          Espaco(),
           Text(
           widget.consulta==null?'Adicionar Consulta':'Editar Consulta',
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
              label: "Data da Consulta",
              prefix: Icons.date_range_outlined,
              validator: Validators.required("Digite a Data da Consulta"),
              keyboardType: TextInputType.none,
              onTap: () => Util().getData(context, (date) {
                _data = date;
                data.text = DateFormat('dd-MM-yyyy').format(date);
              },current: widget.consulta?.data!),
            ),
            Espaco(),
            TextFormGenerico(
                  controller: queixa,
                  keyboardType: TextInputType.name,
                  label: "Queixa",
                  prefix: Icons.numbers),
            Espaco(),
            TextFormGenerico(
                  controller: diagnostico,
                  keyboardType: TextInputType.name,
                  label: "Diagnóstico",
                  // maxLines: 5,
                  prefix: Icons.numbers),
            Espaco(),
            TextFormGenerico(
                  controller: nomeVeterinario,
                  keyboardType: TextInputType.name,
                  label: "Nome do Veterinário",
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
            DropDownGenerico(
              map: {
                '7 dias': 7,
                '15 dias': 15,
                '30 dias': 30,
                'Definir': 0
              },
              label: "Retorno em",
              funcao: (int x) {
                setState(() {
                  repetirEm = x;
                });
              },
              valor: [7, 15, 30].contains(repetirEm) ? repetirEm : 0,
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
                        "${repetirEmDef} ${(repetirEmDef!=1)?'dias':'dia'}"
                        , // Exibe o valor atual do Slider
                        style: TextStyle(
                            color: kPrimaryColor), // Define a cor do texto como vermelho
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
        Consumer<ConsultasRepository>(builder: (context, consultas, child){
          
          return 
          TextButton(
          child: Text(widget.consulta==null?'adicionar':'alterar'),
          onPressed: () {
         
            Consulta _consulta = Consulta(
                data: _data,
                proximaData: _data.add(repetirEm != 0
                    ? Duration(days: repetirEm)
                    : Duration(days: repetirEmDef)),
                queixa: queixa.text,
                diagnostico: diagnostico.text,
                nomeVeterinario: nomeVeterinario.text,    
                 custo: (custo.text != "") ? UtilBrasilFields.converterMoedaParaDouble(custo.text) : 0);

              if (widget.consulta != null)
                consultas.update(widget.consulta!, _consulta, widget.idPet);
              else
                consultas.set(_consulta, widget.idPet);

            Navigator.pop(context);
          },
        );
        })
      ],
    );
  }
}
