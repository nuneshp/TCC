import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:tcc_hugo/const_colors.dart';

class RadioButton extends StatefulWidget {
  List<String> itens;
  TextEditingController controller;
  RadioButton({Key? key, required this.controller, required this.itens}) : super(key: key);

  @override
  State<RadioButton> createState() => _RadioButtonState();
}

class _RadioButtonState extends State<RadioButton> {
  // exemplo List<String> itens = ["Macho", "Fêmea"];

  int val = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if(widget.controller.text!=""){
      val=widget.itens.indexOf(widget.controller.text);
    }
    else{
      widget.controller.text = widget.itens[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          width: 1,
          color: kPrimaryColor.withAlpha(100)
        )
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ...widget.itens.map((item) => Flexible(
            child: InkWell(
              onTap: (){
                setState(() {
                    val = widget.itens.indexOf(item);
                  });
                  widget.controller.text = widget.itens[val];
              },
              child: ListTile(
                dense: true,
                title: Text(item,style: TextStyle(color:kPrimaryColor, fontSize: 14)),
                leading: Radio(
                  value: widget.itens.indexOf(item),
                  groupValue: val,
                  onChanged: (value){
                    setState(() {
                    val = widget.itens.indexOf(item);
                  });
                  widget.controller.text = widget.itens[val];
              },
                  activeColor: kPrimaryColor,
                ),
              ),
            ),
          ),
          )
        
        ],
      ),
    );
  }
}
