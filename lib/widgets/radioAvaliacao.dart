import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:tcc_hugo/const_colors.dart';

class RadioButtonAvaliacao extends StatefulWidget {
  List<String> itens;
  void Function(int?)? onChanged;
  RadioButtonAvaliacao({Key? key, required this.onChanged, required this.itens})
      : super(key: key);

  @override
  State<RadioButtonAvaliacao> createState() => _RadioButtonAvaliacaoState();
}

class _RadioButtonAvaliacaoState extends State<RadioButtonAvaliacao> {
  int val = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(width: 1, color: kPrimaryColor.withAlpha(100))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ...widget.itens.map(
            (item) => Flexible(
              child: ListTile(
                dense: true,
                title: Text(item,
                    style: TextStyle(color: kPrimaryColor, fontSize: 14)),
                leading: Radio(
                  value: widget.itens.indexOf(item),
                  groupValue: val,
                  onChanged: widget.onChanged,
                  activeColor: kPrimaryColor,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
