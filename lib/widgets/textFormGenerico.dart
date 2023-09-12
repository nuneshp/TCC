import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tcc_hugo/const_colors.dart';

class TextFormGenerico extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData prefix;
  final bool isPass;
  final TextInputType? keyboardType;
  final Function()? onTap;
  final Function(String)? onChanged;
  final Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final int maxLines;
  final bool moeda;
  final bool number;
  final int decimal;

  TextFormGenerico(
      {Key? key,
      required this.controller,
      this.label = "",
      this.hint = "",
      this.prefix = Icons.ac_unit_outlined,
      this.isPass = false,
      this.onTap,
      this.keyboardType = TextInputType.name,
      this.onSaved,
      this.onChanged,
      this.validator,
      this.maxLines = 1,
      this.moeda = false,
      this.number = false,
      this.decimal = 2
      })
      : super(key: key);

  @override
  _TextFormGenericoState createState() => _TextFormGenericoState();
}

class _TextFormGenericoState extends State<TextFormGenerico> {
  late bool textoVisivel;

  @override
  void initState() {
    super.initState();

    if (widget.isPass) {
      textoVisivel = false;
    } else {
      textoVisivel = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: widget.onTap,
      onSaved: widget.onSaved,
      onChanged: widget.onChanged,
      validator: widget.validator,
      controller: widget.controller,
      obscureText: !textoVisivel,
      keyboardType: widget.keyboardType,
      maxLines: widget.maxLines,
      inputFormatters: widget.moeda
          ? [
              FilteringTextInputFormatter.digitsOnly,
              CentavosInputFormatter(moeda: true, casasDecimais: widget.decimal)
            ]
          : (widget.number
              ? [
                  FilteringTextInputFormatter.digitsOnly,
                  CentavosInputFormatter(moeda: false, casasDecimais: widget.decimal)
                ]
              : []),
      decoration: InputDecoration(
        label: widget.label != ""
            ? Text(
                widget.label,
                style: TextStyle(color: kPrimaryColor),
              )
            : null,
        hintText: widget.hint,
        isDense: true,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(
              color: kPrimaryColor.withAlpha(100),
              width: 1,
            )),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: kPrimaryColor.withAlpha(100),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: kPrimaryColor.withAlpha(150),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
        prefixIcon: Icon(
          widget.prefix,
          size: 22,
          color: Color(0xFF525E75),
        ),
        suffixIcon: widget.isPass
            ? InkWell(
                onTap: () => setState(
                  () => textoVisivel = !textoVisivel,
                ),
                child: Icon(
                  textoVisivel
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: Colors.grey,
                  size: 22,
                ),
              )
            : null,
      ),
    );
  }
}
