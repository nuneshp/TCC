import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:tcc_hugo/const_colors.dart';
import 'package:tcc_hugo/models/usuario.dart';
import 'package:tcc_hugo/services/auth_service.dart';
import 'package:tcc_hugo/widgets/buttonGenerico.dart';
import 'package:tcc_hugo/widgets/selectCameraGaleria.dart';
import 'package:tcc_hugo/widgets/textFormGenerico.dart';
import 'package:tcc_hugo/widgets/util.dart';
import 'package:wc_form_validators/wc_form_validators.dart';

class RegistrarPage extends StatefulWidget {
  static const routeName = '/registrar';
  RegistrarPage({Key? key}) : super(key: key);

  @override
  State<RegistrarPage> createState() => _RegistrarPageState();
}

class _RegistrarPageState extends State<RegistrarPage> {
  XFile? fotoPerfil;
  final _formKey = GlobalKey<FormState>();
  TextEditingController nome = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController senha = TextEditingController();
  TextEditingController senha2 = TextEditingController();
  bool loading = false;
  bool validar = false;
  late Usuario user;

  registrar() async {
    try {
      await context
          .read<AuthService>()
          .registrar(fotoPerfil, nome.text, email.text, senha.text);
      // user = Usuario(nome: nome.text);
      // await context.read<UsuarioRepository>().setUsuario(user);
      Navigator.pop(context);
      // Navigator.pushNamedAndRemoveUntil(
      //     context, '/verificarEmail', (route) => false);
    } on AuthException catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kWhite,
        appBar: AppBar(
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
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
            child: Form(
              autovalidateMode: validar? AutovalidateMode.always: AutovalidateMode.disabled,
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () async {
                      final temp = await selectCameraGaleriaDialog(context);
                      if (temp != null) {
                        final _foto = await Util().getImage(temp);
                        setState(() {
                          fotoPerfil = _foto;
                        });
                      }
                    },
                    child: Stack(alignment: Alignment.bottomRight, children: [
                      fotoPerfil == null
                          ? ClipRect(
                              child: Align(
                                widthFactor: 0.62,
                                heightFactor: 0.78,
                                alignment: Alignment.center,
                                child: Lottie.asset(
                                  "assets/lotties/profile_avatar.json",
                                  height: 250,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : ClipOval(
                              child: Image.file(
                              File(fotoPerfil!.path),
                              height: 180,
                            )),
                      ClipOval(
                          child: Container(
                              padding: EdgeInsets.all(5),
                              color: kSecundaryColor,
                              child: Icon(
                                fotoPerfil != null
                                    ? Icons.edit
                                    : Icons.photo_camera,
                                size: 40,
                                color: kWhite,
                              ))),
                    ]),
                  ),
                  Espaco(height: 30),
                  const Text(
                    "Registro",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Espaco(height: 20),
                  TextFormGenerico(
                    controller: nome,
                    hint: "Digite seu Nome",
                    label: "Nome do tutor",
                    prefix: Icons.person,
                    keyboardType: TextInputType.name,
                    validator: Validators.required("Insira um Nome!"),
                  ),
                  Espaco(),
                  TextFormGenerico(
                    controller: email,
                    hint: "Digite o Email",
                    label: "Email",
                    prefix: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                    validator: Validators.compose([
                      Validators.required('Digite o Email!'),
                      Validators.email("Insira um Email válido!")
                    ]),
                  ),
                  Espaco(),
                  TextFormGenerico(
                      controller: senha,
                      isPass: true,
                      hint: "Digite a senha",
                      label: "Senha",
                      prefix: Icons.password,
                      validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "A senha não pode ser vazia!";
                                          }
                                          if (value.length < 8 ||
                                              !value
                                                  .contains(RegExp(r'[a-z]')) ||
                                              !value
                                                  .contains(RegExp(r'[A-Z]')) ||
                                              !value.contains(RegExp(
                                                  r'[!@#\$%^&*(),.?":{}|<>]')) ||
                                              !value
                                                  .contains(RegExp(r'[0-9]'))) {
                                            return "A senha deve conter:\nNo mínimo 8 dígitos\nPelo menos uma letra Maiúscula e uma Minúscula\nPelo menos um Símbolo e um Número ";
                                          }
                                          return null;}),
                  Espaco(),
                  TextFormGenerico(
                    controller: senha2,
                    isPass: true,
                    hint: "Confirme a senha",
                    label: "Confirme a Senha",
                    prefix: Icons.password,
                    validator: ((value) {
                      if (value != senha.text)
                        return "Divergência entre as senhas!";
                    }),
                  ),
                  Espaco(height: 20),
                  ButtonGenerico(
                    label: !loading ? "Registrar" : "Registrando...",
                    loading: loading,
                    onPressed: () {
                      setState(() {
                        validar =true;
                      });

                      if (_formKey.currentState!.validate()) {
                        setState(() => loading = true);
                        registrar();
                      }
                    },
                  ),
                  Espaco(height: 20),
                ],
              ),
            ),
          ),
        ));
  }
}
