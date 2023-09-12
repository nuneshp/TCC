import 'package:flutter/material.dart';
import 'package:tcc_hugo/const_colors.dart';
import 'package:tcc_hugo/widgets/util.dart';
import 'package:lottie/lottie.dart';

class CircularProgress extends StatelessWidget {
  String? textStatus;
  bool visible;
  CircularProgress({Key? key, this.textStatus, this.visible = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible,
      child: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        color: Colors.white.withAlpha(230),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
               Lottie.asset("assets/lotties/loading.json", height: 180),
              
              Text(textStatus != null ? textStatus! : "", style: TextStyle(color: kPrimaryColor),)
            ],
          ),
        ),
      ),
    );
  }
}
