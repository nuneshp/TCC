import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcc_hugo/repositorys/antiparasitario_repository.dart';
import 'package:tcc_hugo/repositorys/banho_repository.dart';
import 'package:tcc_hugo/repositorys/consulta_repository.dart';
import 'package:tcc_hugo/repositorys/foto_repository.dart';
import 'package:tcc_hugo/repositorys/peso_repository.dart';
import 'package:tcc_hugo/repositorys/pet_repository.dart';
import 'package:tcc_hugo/repositorys/tosa_repository.dart';
import 'package:tcc_hugo/repositorys/vacina_repository.dart';
import 'package:tcc_hugo/repositorys/vermifugo_repository.dart';
import 'package:tcc_hugo/services/auth_service.dart';
import 'package:tcc_hugo/services/devices_service.dart';
import 'package:tcc_hugo/widgets/buttonGenerico.dart';
import 'package:tcc_hugo/widgets/textFormGenerico.dart';
import 'package:tcc_hugo/widgets/util.dart';
import 'package:wc_form_validators/wc_form_validators.dart';

class LoginPage extends StatefulWidget {
  static const routeName = '/login';
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController senha = TextEditingController();
  bool loading = false;
  bool validar = false;
  late PetsRepository petsRepository;

  // login() async {
  //   try {
  //     await context.read<AuthService>().login(email.text, senha.text);
  //     await context.read<DevicesService>().setToken();
  //   } on AuthException catch (e) {
  //     setState(() => loading = false);

  //     ScaffoldMessenger.of(context)
  //         .showSnackBar(SnackBar(content: Text(e.message)));
  //   }
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 80),
        child: Form(
          autovalidateMode: validar? AutovalidateMode.always:AutovalidateMode.disabled,
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  height: 180,
                  child: Image.asset(
                    "assets/images/logo.png",
                    fit: BoxFit.cover,
                  )),
              Espaco(height: 30),
              const Text(
                "Login",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Espaco(height: 20),
              TextFormGenerico(
                controller: email,
                hint: "Digite o Email",
                label: "Email",
                prefix: Icons.email,
                keyboardType: TextInputType.emailAddress,
                validator: Validators.compose([
                  Validators.required('Digite o Email!'),
                  Validators.email("Insira um Email válido!"),
                ]),
              ),
              Espaco(),
              TextFormGenerico(
                controller: senha,
                isPass: true,
                hint: "Digite a senha",
                label: "Senha",
                prefix: Icons.password,
                validator: Validators.required('Digite a Senha!'),
              ),
              Espaco(),
              Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    child: const Text("Esqueceu a senha?"),
                    onPressed: () {
                      Navigator.pushNamed(context, "/esqueceuSenha");
                    },
                  )),
              Espaco(height: 20),
              Consumer2<AuthService, DevicesService>(
                builder: (context, auth, devices, child) {
                  return ButtonGenerico(
                    label: !loading ? "Entrar" : "Entrando...",
                    loading: loading,
                    onPressed: () async {
                      setState(() {
                        validar =true;
                      });

                      if (_formKey.currentState!.validate()) {
                        setState(() => loading = true);
                        try {
                          await auth.login(email.text, senha.text);
                          devices.setToken();

                        
                        } on AuthException catch (e) {
                          setState(() => loading = false);

                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text(e.message)));
                        }
                      }
                    },
                  );
                },
              ),
              Espaco(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text("Não tem uma conta?"),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed("/registrar");
                      },
                      child: const Text("Cadastre-se"))
                ],
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
