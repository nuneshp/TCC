import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class IndicadorSucesso extends StatefulWidget {
  String? routeName;
  String image;
  IndicadorSucesso({Key? key, this.routeName, required this.image})
      : super(key: key);

  @override
  State<IndicadorSucesso> createState() => _IndicadorSucessoState();
}

class _IndicadorSucessoState extends State<IndicadorSucesso>
    with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          if (widget.routeName != null) {
            Navigator.pushNamed(context, widget.routeName!);
          } else {
            Navigator.pop(context);
             Navigator.pop(context);
          }
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(      
      body: Center(
        child: SizedBox(
            width: 250,
            height: 250,
            child: Lottie.asset(widget.image, controller: _controller,
                onLoaded: (composition) {
              _controller
                ..duration = composition.duration
                ..forward();
            })),
      ),
    );
  }

  
}

Future showAndNav({
    required BuildContext context,
    required String image,
    String? routeName,
  }) async {
    showDialog<void>(
      context: context,
      useSafeArea: false,
      builder: (BuildContext context) {
        return IndicadorSucesso(
          image: image,
          routeName: routeName,
        );
      },
    );
    
  }
