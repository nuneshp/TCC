import 'package:flutter/material.dart';
import 'package:tcc_hugo/const_colors.dart';

class DropDownGenerico<T> extends StatefulWidget {
  final Map<String, T> map;
  final String label;
  final void Function(T) funcao;
  final T? valor;
  final IconData prefix;
  

  const DropDownGenerico({
    required this.map,
    required this.label,
    required this.funcao,
    this.valor,
    this.prefix = Icons.ac_unit_outlined,
  });

  @override
  _DropDownGenericoState<T> createState() => _DropDownGenericoState<T>();
}

class _DropDownGenericoState<T> extends State<DropDownGenerico<T>> {
  late T? _valorSelecionado;
  late bool _textoVisivel;

  @override
  void initState() {
    super.initState();
    _valorSelecionado = widget.valor;
    _textoVisivel = true;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButtonFormField<dynamic>(
        value: _valorSelecionado,
        onChanged: (valor) {
          setState(() {
            _valorSelecionado = valor;
          });
          widget.funcao(valor!);
        },
        items: widget.map.entries
            .map((entry) => DropdownMenuItem<T>(
                  value: entry.value,
                  child: Text(
                    entry.key,
                    style: TextStyle(
                      color: Color(0xFF525E75),
                    ),
                  ),
                ))
            .toList(),
        icon: Icon(
          Icons.arrow_drop_down,
          color: Color(0xFF525E75),
        ),
        decoration: InputDecoration(
          prefixIcon: Icon(
            widget.prefix,
            color: Color(0xFF525E75),
          ),
          alignLabelWithHint: true,
          contentPadding: EdgeInsets.only(top: 20, bottom: 0, left: 10),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: kPrimaryColor.withAlpha(100)),
            borderRadius: BorderRadius.circular(20),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: kPrimaryColor.withAlpha(150), width: 2),
            borderRadius: BorderRadius.circular(20),
          ),
          labelText: widget.label,
          labelStyle: TextStyle(
            color: kPrimaryColor,
          ),
          filled: true,
          fillColor: Colors.transparent,
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          isDense: true,
        ),
        style: TextStyle(
          color: kPrimaryColor,
          fontSize: 16,
        ),
      ),
    );
  }
}
