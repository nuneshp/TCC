import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:tcc_hugo/const_colors.dart';
import 'package:tcc_hugo/pages/login/login_page.dart';
import 'package:tcc_hugo/pages/login/verificar_email_page.dart';
import 'package:tcc_hugo/services/auth_service.dart';
import 'package:tcc_hugo/widgets/util.dart';

import 'pages/home_page/home_page.dart';

class AuthCheck extends StatefulWidget {
  static const routeName = '/';

  const AuthCheck({Key? key}) : super(key: key);

  @override
  State<AuthCheck> createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  bool splash = true;

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        splash = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(
      builder: (context, auth, _) {
        if (splash) {
          return splashScreen();
        } else if (auth.isLoading)
          return loading();
        else if (auth.usuario == null)
          return LoginPage();
        else if (auth.usuario!.emailVerified == false)
          return VerificarEmailPage();
        else
          return HomePage();
      },
    );
  }

  splashScreen() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Espaco(height: 100,),
            Image.asset(
              "assets/images/logo.png",
              height: 180,
            ),
            Espaco(height: 20,),
            
            const Text("AmigoPet",
                style: TextStyle(color: kPrimaryColor, fontSize: 18)),
            const Text(
              "Ajudando a cuidar do seu Pet",
              style: TextStyle(color: kPrimaryColor, fontSize: 14),
            ),
            Espaco(height: 50,),
            Lottie.asset('assets/lotties/loading_estrela.json', height: 50, animate: true),
                        Espaco(height: 50,),
            const Text(
              "Desenvolvido por:\nHugo Nunes\nV 0.0.1", textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black87, fontSize: 10),
            )
          ],
        ),
      ),
    );
  }

  Widget loading() {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
