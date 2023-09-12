import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:tcc_hugo/const_colors.dart';
import 'package:tcc_hugo/services/auth_service.dart';
import 'package:tcc_hugo/widgets/util.dart';

class VerificarEmailPage extends StatefulWidget {
  static const routeName = '/verificarEmail';
  const VerificarEmailPage({Key? key}) : super(key: key);

  @override
  State<VerificarEmailPage> createState() => _VerificarEmailPageState();
}

class _VerificarEmailPageState extends State<VerificarEmailPage>
    with WidgetsBindingObserver {
  bool envia = true;
  int contador = 60;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    iniciarContador();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      await context.read<AuthService>().refresh();
    }
  }

  void iniciarContador() {
    if (envia) {
      // Inicia o contador regressivo
      Timer.periodic(Duration(seconds: 1), (timer) {
        if (contador > 0) {
          setState(() {
            contador--;
          });
        } else {
          timer.cancel(); // Cancela o timer quando o contador chegar a zero
          setState(() {
            envia = true;
          });
        }
      });
    }
  }

  void reenviar() {
    if (envia) {
      context.read<AuthService>().sendEmailVerification();

      setState(() {
        envia = false;
        contador = 60; // Reinicia o contador para 60 segundos
      });

      iniciarContador();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(
        leading: InkWell(
            onTap: () {
              final auth = Provider.of<AuthService>(context, listen: false);

              auth.logout();
            },
            child: Icon(Icons.undo)),
        title: Text(
          "Voltar para Login",
          style: TextStyle(color: kPrimaryColor),
        ),
        elevation: 0,
        backgroundColor: kWhite,
        iconTheme: IconThemeData(color: kPrimaryColor),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipOval(
              child: Image.asset(
                'assets/images/logo.png',
                width: 40,
              ),
            ),
          )
        ],
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Lottie.asset("assets/lotties/send_email.json",
              height: 250, repeat: false),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              "Enviamos um Email com link\npara confirmação da sua conta!\n\nApós confirmado efetue o login!",
              textAlign: TextAlign.center,
            ),
          ),
          Espaco(
            height: 30,
          ),
          TextButton(
            onPressed: envia
                ? reenviar
                : null, // Desabilita o botão enquanto envia for false
            child: Text(
              envia ? "Não recebi, reenviar" : "Aguarde $contador segundos",
              style: TextStyle(
                color: envia
                    ? Colors.blue
                    : Colors
                        .grey, // Altera a cor do texto dependendo do estado do envio
              ),
            ),
          )
        ]),
      ),
    );
  }
}
