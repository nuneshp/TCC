import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:tcc_hugo/const_colors.dart';
import 'package:tcc_hugo/services/auth_service.dart';
import 'package:tcc_hugo/widgets/textFormGenerico.dart';
import 'package:tcc_hugo/widgets/util.dart';

class EsqueceuSenhaPage extends StatefulWidget {
  static const routeName = '/esqueceuSenha';
  const EsqueceuSenhaPage({Key? key}) : super(key: key);

  @override
  State<EsqueceuSenhaPage> createState() => _EsqueceuSenhaPageState();
}

class _EsqueceuSenhaPageState extends State<EsqueceuSenhaPage> {
  TextEditingController email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(
        title: Text("Voltar para Login", style: TextStyle(color: kPrimaryColor),),
        elevation: 0,
        backgroundColor: kWhite,
        iconTheme: IconThemeData(color: kPrimaryColor),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipOval(
              child: Image.asset('assets/images/logo.png', width: 40,),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Lottie.asset("assets/lotties/sleep_cat.json", height: 250),
                Text(
                  "Esqueceu a senha?\n Preencha o campo abaixo e solicite a\n redefinição de senha",
                  textAlign: TextAlign.center,
                ),
                Espaco(
                  height: 40,
                ),
                TextFormGenerico(
                  controller: email,
                  label: "Email",
                  hint: "Digite o email",
                  prefix: Icons.email,
                ),
                Espaco(height: 20,),
                TextButton(
                    onPressed: (() async {
                      await context
                          .read<AuthService>()
                          .resetPassword(email.text);
                    }),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                       
                        
                         ClipOval(
                           child: Container(
                            height: 30,
                            width: 30,
                            color: Colors.blue.withAlpha(200),
                            child: Icon(Icons.send_rounded, color: kWhite,)),
                         ),
                         Espaco(),
                         Text("Solicitar Email\nde redefinição", textAlign: TextAlign.right,),
                      ],
                    )),
                Espaco(
                  height: 80,
                ),
                InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, "/login");
                    },
                    child: Text("AmigoPet"))
              ]),
        ),
      ),
    );
  }
}
