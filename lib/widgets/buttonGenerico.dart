import 'package:flutter/material.dart';
import 'package:tcc_hugo/const_colors.dart';

class ButtonGenerico extends StatefulWidget {
  String label;
  double height;
  bool loading;
  Color cor;
  void Function()? onPressed;
  ButtonGenerico(
      {Key? key,
      this.onPressed,
      required this.label,
      this.height = 40,
      this.loading = false, this.cor=kSecundaryColor})
      : super(key: key);

  @override
  State<ButtonGenerico> createState() => _ButtonGenericoState();
}

class _ButtonGenericoState extends State<ButtonGenerico> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: widget.onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
            Visibility(
              visible: widget.loading,
              child: Container(
                  height: widget.height * 0.6,
                  width: widget.height * 0.6,
                  margin: EdgeInsets.only(right: 20),
                  child: CircularProgressIndicator(
                    color: kWhite,
                  )),
            ),
            Container(
                height: widget.height,
                alignment: Alignment.center,
                child: Text(widget.label, style: TextStyle(color: kWhite),)),
          ],
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.cor,
          textStyle: TextStyle(
              fontSize: widget.height * 0.5, fontWeight: FontWeight.w600),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(360)),
        ));
  }
}
