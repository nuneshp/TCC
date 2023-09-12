import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:tcc_hugo/const_colors.dart';
import 'package:tcc_hugo/repositorys/pet_repository.dart';
import 'package:tcc_hugo/services/auth_service.dart';
import 'package:tcc_hugo/widgets/selectCameraGaleria.dart';
import 'package:tcc_hugo/widgets/textFormGenerico.dart';
import 'package:tcc_hugo/widgets/util.dart';
import 'package:wc_form_validators/wc_form_validators.dart';

import '../../widgets/buttonGenerico.dart';

class PerfilPage extends StatefulWidget {
  static const routeName = '/perfilTutor';
  const PerfilPage({super.key});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  bool alterarFoto = false;
  bool alterarSenha = false;
  bool alterarNome = false;
  bool excluirConta = false;
  bool loadingFoto = false;
  bool loadingSenha = false;
  bool loadingNome = false;
  bool loadingExcluirConta = false;
  bool validar = false;

  final _formKeyNome = GlobalKey<FormState>();
  TextEditingController nome = TextEditingController();
  final _formKeySenha = GlobalKey<FormState>();
  TextEditingController senha = TextEditingController();
  TextEditingController novaSenha = TextEditingController();
  TextEditingController confirmaNovaSenha = TextEditingController();
  final _formKeySenhaExcluirConta = GlobalKey<FormState>();
  TextEditingController senhaExcluir = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(
        title: Text("Pertil do Tutor",
            textAlign: TextAlign.start, style: TextStyle(color: kPrimaryColor)),
        iconTheme: const IconThemeData(color: kPrimaryColor),
        elevation: 0,
        backgroundColor: kWhite,
      ),
      body: Consumer2<AuthService, PetsRepository>(
          builder: (context, auth, pets, child) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      20.0), // Aumente o valor para arredondar mais
                ),
                color: kWhite,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Container(
                            padding: const EdgeInsets.all(20.0),
                            child: ClipOval(
                                // borderRadius: BorderRadius.circular(10.0),
                                child: (auth.usuario!.photoURL != null)
                                    ? FadeInImage.assetNetwork(
                                        fit: BoxFit.fitHeight,
                                        width: 110,
                                        placeholder:
                                            "assets/images/loading_postagem.gif",
                                        image: auth.usuario!.photoURL!,
                                        imageErrorBuilder:
                                            (context, error, stackTrace) {
                                          return ClipRect(
                                            child: Align(
                                              widthFactor: 0.62,
                                              heightFactor: 0.78,
                                              alignment: Alignment.center,
                                              child: Lottie.asset(
                                                "assets/lotties/profile_avatar.json",
                                                height: 150,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          );
                                        },
                                      )
                                    : ClipRect(
                                        child: Align(
                                          widthFactor: 0.62,
                                          heightFactor: 0.78,
                                          alignment: Alignment.center,
                                          child: Lottie.asset(
                                            "assets/lotties/profile_avatar.json",
                                            height: 150,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ))),
                        Text(
                          "${auth.usuario!.displayName!.toUpperCase()}",
                          style: TextStyle(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.bold),
                        ),
                        Text("${auth.usuario!.email}",
                            style: TextStyle(
                                color: kSecundaryColor,
                                fontWeight: FontWeight.normal)),
                        Espaco()
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                                text: (pets.lista.length == 1)
                                    ? "${pets.lista.length} pet"
                                    : "${pets.lista.length} pets",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: kPrimaryColor),
                                children: [
                                  TextSpan(
                                      text: (pets.lista.length == 1)
                                          ? "\ncadastrado"
                                          : "\ncadastrados",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal))
                                ])),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  20.0), // Aumente o valor para arredondar mais
                            ),
                            color: Colors.grey[100],
                            child: Column(children: [
                              InkWell(
                                onTap: () async {
                                  if (!loadingFoto) {
                                    try {
                                      final temp =
                                          await selectCameraGaleriaDialog(
                                              context);
                                      if (temp != null) {
                                        final _foto =
                                            await Util().getImage(temp);
                                        if (_foto != null) {
                                          setState(() {
                                            loadingFoto = true;
                                          });
                                          await auth.updateFoto(_foto);
                                          setState(() {
                                            loadingFoto = false;
                                          });
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "Foto atualizada com sucesso")));
                                        }
                                      }
                                    } catch (e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  "Falha na alteração da foto")));
                                      setState(() {
                                        loadingFoto = false;
                                      });
                                    }
                                  }
                                },
                                child: Container(
                                  height: 40,
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: kSecundaryColor,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20.0),
                                        topRight: Radius.circular(20.0),
                                        bottomLeft: Radius.circular(20),
                                        bottomRight: Radius.circular(20)),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Icon(
                                        Icons.photo,
                                        color: kWhite,
                                      ),
                                      Text(
                                        loadingFoto
                                            ? "Aguarde"
                                            : "Alterar Foto ",
                                        style: TextStyle(
                                            color: kWhite,
                                            fontSize: 18,
                                            fontWeight: FontWeight.normal),
                                      ),
                                      loadingFoto
                                          ? SizedBox(
                                              height: 20,
                                              width: 20,
                                              child: CircularProgressIndicator(
                                                color: kWhite,
                                                strokeWidth: 2,
                                              ))
                                          : Container(
                                              width: 20,
                                            )
                                    ],
                                  ),
                                ),
                              ),
                            ]))),
                    Espaco(height: 5),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                20.0), // Aumente o valor para arredondar mais
                          ),
                          color: Colors.grey[100],
                          child: Column(children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  if (alterarSenha) alterarSenha = false;
                                  if (excluirConta) excluirConta = false;
                                  alterarNome = !alterarNome;
                                });
                              },
                              child: Container(
                                height: 40,
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: kSecundaryColor,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20.0),
                                      topRight: Radius.circular(20.0),
                                      bottomLeft:
                                          Radius.circular(alterarNome ? 0 : 20),
                                      bottomRight: Radius.circular(
                                          alterarNome ? 0 : 20)),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Icon(
                                      Icons.person,
                                      color: kWhite,
                                    ),
                                    Text(
                                      "Alterar Nome",
                                      style: TextStyle(
                                          color: kWhite,
                                          fontSize: 18,
                                          fontWeight: FontWeight.normal),
                                    ),
                                    Icon(
                                      alterarNome
                                          ? Icons.arrow_drop_up_outlined
                                          : Icons.arrow_drop_down_outlined,
                                      color: kWhite,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            if (alterarNome)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 50.0, vertical: 20),
                                child: Form(
                                  autovalidateMode: AutovalidateMode.always,
                                  key: _formKeyNome,
                                  child: Column(children: [
                                    TextFormGenerico(
                                        controller: nome,
                                        label: "Novo nome",
                                        hint: "Digite novo nome",
                                        prefix: Icons.person,
                                        keyboardType: TextInputType.text,
                                        validator: Validators.compose([
                                          Validators.required(
                                              'Digite o novo nome!'),
                                        ])),
                                    Espaco(),
                                    ButtonGenerico(
                                      height: 30,
                                      cor: kPrimaryColor,
                                      label: !loadingNome
                                          ? "Alterar nome"
                                          : "Alterando...",
                                      loading: loadingNome,
                                      onPressed: () async {
                                        if (_formKeyNome.currentState!
                                                .validate() &&
                                            !loadingNome) {
                                          try {
                                            setState(() => loadingNome = true);

                                            await auth
                                                .updateDisplayName(nome.text);

                                            setState(() {
                                              loadingNome = false;
                                              alterarNome = false;
                                            });
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Text(
                                                        "Nome alterado com sucesso!")));
                                          } on AuthException catch (e) {
                                            setState(() => loadingNome = false);

                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Text(e.message)));
                                          }
                                        }
                                      },
                                    )
                                  ]),
                                ),
                              ),
                          ])),
                    ),
                    Espaco(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                20.0), // Aumente o valor para arredondar mais
                          ),
                          color: Colors.grey[100],
                          child: Column(children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  if (alterarNome) alterarNome = false;
                                  if (excluirConta) excluirConta = false;
                                  alterarSenha = !alterarSenha;
                                });
                              },
                              child: Container(
                                height: 40,
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: kSecundaryColor,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20.0),
                                      topRight: Radius.circular(20.0),
                                      bottomLeft: Radius.circular(
                                          alterarSenha ? 0 : 20),
                                      bottomRight: Radius.circular(
                                          alterarSenha ? 0 : 20)),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Icon(
                                      Icons.password,
                                      color: kWhite,
                                    ),
                                    Text(
                                      "Alterar Senha",
                                      style: TextStyle(
                                          color: kWhite,
                                          fontSize: 18,
                                          fontWeight: FontWeight.normal),
                                    ),
                                    Icon(
                                      alterarSenha
                                          ? Icons.arrow_drop_up_outlined
                                          : Icons.arrow_drop_down_outlined,
                                      color: kWhite,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            if (alterarSenha)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 50.0, vertical: 20),
                                child: Form(
                                  autovalidateMode: validar
                                      ? AutovalidateMode.always
                                      : AutovalidateMode.disabled,
                                  key: _formKeySenha,
                                  child: Column(children: [
                                    TextFormGenerico(
                                        controller: senha,
                                        label: "Senha atual",
                                        isPass: true,
                                        hint: "Digite a senha atual",
                                        prefix: Icons.password,
                                        keyboardType: TextInputType.text,
                                        validator: Validators.compose([
                                          Validators.required(
                                              'Digite a senha atual!'),
                                        ])),
                                    Espaco(),
                                    TextFormGenerico(
                                        controller: novaSenha,
                                        label: "Nova senha",
                                        isPass: true,
                                        hint: "Digite a nova senha",
                                        prefix: Icons.password,
                                        keyboardType: TextInputType.text,
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
                                            return "A senha deve conter:\nNo mínimo 8 dígitos\nPelo menos uma letra Maiúscula\ne uma Minúscula\nPelo menos um Símbolo e um Número ";
                                          }
                                          return null;
                                        }),
                                    Espaco(),
                                    TextFormGenerico(
                                      controller: confirmaNovaSenha,
                                      label: "Confirme a nova senha",
                                      isPass: true,
                                      hint: "Confirme a nova senha",
                                      prefix: Icons.password,
                                      keyboardType: TextInputType.emailAddress,
                                      validator: ((value) {
                                        if (value != novaSenha.text)
                                          return "Divergência entre as senhas!";
                                      }),
                                    ),
                                    Espaco(),
                                    ButtonGenerico(
                                      height: 30,
                                      cor: kPrimaryColor,
                                      label: !loadingSenha
                                          ? "Alterar senha"
                                          : "Alterando...",
                                      loading: loadingSenha,
                                      onPressed: () async {
                                        setState(() {
                                          validar = true;
                                        });

                                        if (_formKeySenha.currentState!
                                                .validate() &&
                                            !loadingSenha) {
                                          try {
                                            setState(() => loadingSenha = true);

                                            await auth.updatePassword(
                                                senha.text, novaSenha.text);

                                            setState(() {
                                              loadingSenha = false;
                                              alterarSenha = false;
                                              senha.text = "";
                                              novaSenha.text = "";
                                              confirmaNovaSenha.text = "";
                                            });
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Text(
                                                        "Senha alterada com sucesso!")));
                                          } on AuthException catch (e) {
                                            setState(
                                                () => loadingSenha = false);

                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Text(e.message)));
                                          }
                                        }
                                      },
                                    )
                                  ]),
                                ),
                              ),
                          ])),
                    ),
                    Espaco(
                      height: 5,
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    //   child: Card(
                    //       shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(
                    //             20.0), // Aumente o valor para arredondar mais
                    //       ),
                    //       color: Colors.grey[100],
                    //       child: Column(children: [
                    //         InkWell(
                    //           onTap: () {
                    //             setState(() {
                    //               if(alterarNome)alterarNome=false;
                    //               if(alterarSenha)alterarSenha=false;
                    //               excluirConta = !excluirConta;
                    //             });
                    //           },
                    //           child: Container(
                    //             height: 40,
                    //             padding: EdgeInsets.all(5),
                    //             decoration: BoxDecoration(
                    //               color: kSecundaryColor,
                    //               borderRadius: BorderRadius.only(
                    //                   topLeft: Radius.circular(20.0),
                    //                   topRight: Radius.circular(20.0),
                    //                   bottomLeft: Radius.circular(
                    //                       excluirConta ? 0 : 20),
                    //                   bottomRight: Radius.circular(
                    //                       excluirConta ? 0 : 20)),
                    //             ),
                    //             child: Row(
                    //               mainAxisAlignment:
                    //                   MainAxisAlignment.spaceAround,
                    //               children: [
                    //                 Icon(
                    //                   Icons.delete,
                    //                   color: kWhite,
                    //                 ),
                    //                 Text(
                    //                   "Excluir a Conta",
                    //                   style: TextStyle(
                    //                       color: kWhite,
                    //                       fontSize: 18,
                    //                       fontWeight: FontWeight.normal),
                    //                 ),
                    //                 Icon(
                    //                   alterarNome
                    //                       ? Icons.arrow_drop_up_outlined
                    //                       : Icons.arrow_drop_down_outlined,
                    //                   color: kWhite,
                    //                 )
                    //               ],
                    //             ),
                    //           ),
                    //         ),
                    //         if (excluirConta)
                    //           Padding(
                    //             padding: const EdgeInsets.symmetric(
                    //                 horizontal: 50.0, vertical: 20),
                    //             child: Form(
                    //               autovalidateMode: AutovalidateMode.always,
                    //               key: _formKeySenhaExcluirConta,
                    //               child: Column(children: [
                    //                 TextFormGenerico(
                    //                     controller: senhaExcluir,
                    //                     label: "Senha",
                    //                     hint: "Digite a senha",
                    //                     prefix: Icons.person,
                    //                     keyboardType: TextInputType.text,
                    //                     validator: Validators.compose([
                    //                       Validators.required(
                    //                           'Digite a senha!'),
                    //                     ])),
                    //                 Espaco(),
                    //                 ButtonGenerico(
                    //                   height: 30,
                    //                   cor: kPrimaryColor,
                    //                   label: !loadingExcluirConta
                    //                       ? "Excluir"
                    //                       : "Excluindo...",
                    //                   loading: loadingExcluirConta,
                    //                   onPressed: () async {
                    //                     if (_formKeyNome.currentState!
                    //                             .validate() &&
                    //                         !loadingExcluirConta) {
                    //                       try {
                    //                         setState(() =>
                    //                             loadingExcluirConta = true);

                    //                         await auth.excluirConta(senhaExcluir.text);

                    //                         setState(() {
                    //                           loadingExcluirConta = false;
                    //                           excluirConta = false;
                    //                         });
                    //                         ScaffoldMessenger.of(context)
                    //                             .showSnackBar(SnackBar(
                    //                                 content: Text(
                    //                                     "Conta excluída com sucesso!")));
                    //                       } on AuthException catch (e) {
                    //                         setState(() => loadingNome = false);

                    //                         ScaffoldMessenger.of(context)
                    //                             .showSnackBar(SnackBar(
                    //                                 content: Text(e.message)));
                    //                       }
                    //                     }
                    //                   },
                    //                 )
                    //               ]),
                    //             ),
                    //           ),
                    //       ])),
                    // ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
