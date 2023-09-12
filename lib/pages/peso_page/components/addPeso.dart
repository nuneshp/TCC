import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tcc_hugo/const_colors.dart';
import 'package:tcc_hugo/models/peso.dart';
import 'package:tcc_hugo/models/pet.dart';
import 'package:tcc_hugo/repositorys/peso_repository.dart';
import 'package:tcc_hugo/widgets/textFormGenerico.dart';
import 'package:tcc_hugo/widgets/util.dart';
import 'package:wc_form_validators/wc_form_validators.dart';

Future<void> addPesoDialog(context, String idPet,{Peso? peso}) async {
  
   await showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      
      
      return AddPeso(idPet: idPet, peso:peso);
    },
  );
}

class AddPeso extends StatefulWidget {
  String idPet;
  Peso? peso;
   AddPeso({required this.idPet, this.peso ,super.key});

  @override
  State<AddPeso> createState() => _AddPesoState();
}

class _AddPesoState extends State<AddPeso> {
  late Pet pet ;
  TextEditingController data = TextEditingController();
  TextEditingController peso = TextEditingController();

  DateTime _data = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
    if (widget.peso != null) {
      setState(() {
      data.text = DateFormat('dd-MM-yyyy').format(widget.peso!.data!);
      _data = widget.peso!.data!;
      if(widget.peso!.peso!=null)
      peso.text = UtilBrasilFields.obterReal(widget.peso!.peso!, moeda: false, decimal: 3);
  
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
                    child: Image.asset("assets/images/ico_peso.png"))),
            Espaco(),
             Text(
              widget.peso==null?'Adicionar Peso':'Editar Peso',
              style: TextStyle(color: kPrimaryColor),
            ),
          ],
        ),
        content: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Espaco(),
            TextFormGenerico(
              controller: data,
              label: "Data da Pesagem",
              prefix: Icons.date_range_outlined,
              validator: Validators.required("Digite a Data da Pesagem"),
              keyboardType: TextInputType.none,
              onTap: () => Util().getData(context, (date) {
                _data = date;
                data.text = DateFormat('dd-MM-yyyy').format(date);
              }, current: widget.peso?.data!),
            ),
            Espaco(),
            TextFormGenerico(
              controller: peso,
              label: "Peso (Kg)",
              prefix: Icons.balance,
              validator: Validators.required("Digite o Peso do pet"),
              keyboardType: TextInputType.number,
              number: true,
              decimal: 3,
            ),
            
          ],
        )),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          Consumer<PesosRepository>(builder: (context, pesos, child){
            return TextButton(
            child:  Text(widget.peso==null?'adicionar':'alterar'),
            onPressed: () {
              
              Peso _peso = Peso(data: _data, peso: (peso.text != "") ? UtilBrasilFields.converterMoedaParaDouble(peso.text) : 0);
             
              if (widget.peso != null)
                pesos.update(widget.peso!, _peso, widget.idPet);
              else
                pesos.set(_peso, widget.idPet);

              Navigator.pop(context);
            },
          );
          })
        ],
      );
  }
}
