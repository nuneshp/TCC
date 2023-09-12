import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:tcc_hugo/const_colors.dart';
import 'package:tcc_hugo/services/avaliacao_service.dart';
import 'package:tcc_hugo/widgets/radioAvaliacao.dart';
import 'package:tcc_hugo/widgets/radioButton.dart';
import 'package:tcc_hugo/widgets/textFormGenerico.dart';
import 'package:tcc_hugo/widgets/util.dart';

class AvaliacaoPage extends StatefulWidget {
  static const routeName = '/avaliacao';
  const AvaliacaoPage({super.key});

  @override
  State<AvaliacaoPage> createState() => _AvaliacaoPageState();
}

class _AvaliacaoPageState extends State<AvaliacaoPage> {
  PageController controller = PageController();
  int indexPage = 0;
  bool aguardeEnvio = false;
  List<String> perguntas = [
    "Eu acho que gostaria de usar essa aplicação frequentemente.",
    "Eu achei essa aplicação desnecessariamente complexa.",
    "Eu achei a aplicação fácil para usar.",
    "Eu acho que precisaria do apoio de um suporte técnico para usar essa aplicação.",
    "Eu achei que as várias funções da aplicação estavam bem integradas.",
    "Eu achei que havia muita inconsistência na aplicação.",
    "Imagino que a maioria das pessoas possa aprender a utilizar este aplicativo muito rapidamente.",
    "Achei a aplicação muito complicada de se usar.",
    "Eu me senti muito confiante em utilizar esta aplicação.",
    "Eu precisei aprender várias coisas antes que eu pudesse começar a usar essa aplicação."
  ];
  List<String> alternativas = [
    "Discordo Totalmente",
    "Discordo",
    "Indiferente",
    "Concordo",
    "Concordo Totalmente"
  ];
  List<String> alternativasLogo = ["😡", "😠", "😒", "😁", "😍"];
  List<dynamic> respostas = [
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
  ]; // Inicialize as respostas com -1 (nenhuma resposta)

  TextEditingController descritiva1 = TextEditingController();
  TextEditingController descritiva2 = TextEditingController();
  TextEditingController descritiva3 = TextEditingController();
  TextEditingController descritiva4 = TextEditingController();
  TextEditingController descritiva5 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kWhite,
        appBar: AppBar(
          title: Text("Voltar",
              style: TextStyle(
                  fontSize: 16,
                  color: kPrimaryColor,
                  fontWeight: FontWeight.w600)),
          iconTheme: const IconThemeData(color: kPrimaryColor),
          elevation: 0,
          backgroundColor: kWhite,
        ),
        body: Consumer<AvaliacaoService>(
          builder: (context, avalia, child) {
            if (avalia.isLoading) return CircularProgressIndicator();

            return PageView(
              controller: controller,
              physics: NeverScrollableScrollPhysics(),
              children: [
                avalia.avaliado
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Lottie.asset(
                            "assets/lotties/joinha.json",
                          ),
                          Text(
                            "Já avaliado!\n Deseja reavaliar?\n",
                            textAlign: TextAlign.center,
                          ),
                          TextButton(
                              onPressed: () {
                                proximaPagina();
                              },
                              child: Text("Reavaliar"))
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                              "Este aplicativo é parte\nintegrante do trabalho de\nconclusão de curso de\nSistemas de Informação. \n\n\nSua avaliação é muito importante!\n\nAvalie a usabilidade", 
                              textAlign: TextAlign.center,),
                          TextButton(
                              onPressed: () {
                                proximaPagina();
                              },
                              child: Text("Iniciar"))
                        ],
                      ),
                ...perguntas.asMap().entries.map((pergunta) => Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("${pergunta.key + 1}/${perguntas.length + 1}"),
                        Espaco(
                          height: 25,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text("${pergunta.value}",
                              style: TextStyle(
                                fontSize: 22,
                              ),
                              textAlign: TextAlign.center),
                        ),
                        Espaco(
                          height: 25,
                        ),
                        ...alternativas
                            .asMap()
                            .entries
                            .map((alternativa) => InkWell(
                                  onTap: () {
                                    setState(() {
                                      respostas[pergunta.key] =
                                          alternativa.key + 1;
                                    });
                                    print(respostas);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0, vertical: 5),
                                    child: ListTile(
                                        tileColor: (respostas[pergunta.key] ==
                                                alternativa.key + 1)
                                            ? Colors.green
                                            : null,
                                        title: Text(alternativa.value),
                                        leading: Text(
                                          alternativasLogo[alternativa.key],
                                          style: TextStyle(fontSize: 40),
                                        )
                                        // Image.asset(
                                        //   "assets/images/logo.png",
                                        //   width: 50,
                                        //   height: 50,
                                        // ),
                                        ),
                                  ),
                                )),
                        Espaco(
                          height: 40,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            if (indexPage != 0)
                              TextButton(
                                  onPressed: voltarPagina,
                                  child: Text("Anterior")),
                            TextButton(
                                onPressed: respostas[pergunta.key] != null
                                    ? proximaPagina
                                    : null,
                                child: Text("Próxima"))
                          ],
                        )
                      ],
                    )),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Text("11/11"),
                        Espaco(),
                        Text("Como você avalia a facilidade de completar tarefas comuns nesta aplicação? Há algum aspecto que facilite ou dificulte a conclusão dessas tarefas?"),
                        TextFormGenerico(
                          controller: descritiva1,
                          maxLines: 5,
                          prefix: Icons.question_answer
                        ),
                        Espaco(height: 20,),
                        Text("Ao explorar a aplicação, você sente que a sequência de telas e a organização das informações fazem sentido? Existe alguma área onde você se sentiu confuso(a) ou perdido(a) durante a navegação?"),
                        TextFormGenerico(
                          controller: descritiva2,
                          maxLines: 5,
                          prefix: Icons.question_answer
                        ),
                        Espaco(height: 20,),
                        Text("A aplicação fornece feedback suficiente após a realização de ações? Como você percebe o feedback visual, como animações ou mensagens de confirmação? Há momentos em que você não tem certeza se a ação foi concluída com sucesso?"),
                        TextFormGenerico(
                          controller: descritiva3,
                          maxLines: 5,
                          prefix: Icons.question_answer
                        ),
                        Espaco(height: 20,),
                        Text("A interface segue padrões de design consistentes em toda a aplicação? Você acha que os elementos visuais e de interação estão alinhados com as expectativas comuns de design de aplicativos móveis?"),
                        TextFormGenerico(
                          controller: descritiva4,
                          maxLines: 5,
                          prefix: Icons.question_answer
                        ),
                        Espaco(height: 20,),
                        Text("Como você avalia o nível de controle que você possui sobre a aplicação? Você consegue personalizar as configurações e opções de acordo com suas preferências? Há alguma funcionalidade em que você gostaria de ter mais flexibilidade ou controle?"),
                        TextFormGenerico(
                          controller: descritiva5,
                          maxLines: 5,
                          prefix: Icons.question_answer,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                                onPressed: voltarPagina, child: Text("Anterior")),
                            TextButton(
                                onPressed: () {
                                  respostas.addAll([
                                    descritiva1.text,
                                    descritiva2.text,
                                    descritiva3.text,
                                    descritiva4.text,
                                    descritiva5.text
                                  ]);
                                  print(respostas);
                                  proximaPagina();
                                },
                                child: Text("Próxima"))
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                aguardeEnvio
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Formulário preenchido",
                              style: TextStyle(
                                fontSize: 22,
                              ),
                              textAlign: TextAlign.center),
                          Text(
                              "Click no botão abaixo para\nrealizar o reggistro de\nsua colaboração",
                              style: TextStyle(
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center),
                          Espaco(),
                          TextButton(
                              onPressed: () async {
                                setState(() {
                                  aguardeEnvio = true;
                                });
                                await avalia.set(respostas);
                                proximaPagina();
                              },
                              child: Text("Finalizar e enviar!"))
                        ],
                      ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset("assets/lotties/send_email.json", height: 250, repeat: false),
                    Text(
                        "Sua colaboração foi registrada!\n\nObrigado!!\n\n", textAlign: TextAlign.center,),
                        TextButton(onPressed: ()=> Navigator.of(context).pop(), child: Text("Fechar"))
                  ],
                )
              ],
            );
          },
        ));
  }

  void proximaPagina() {
    setState(() {
      if (indexPage < perguntas.length + 3) {
        indexPage++;
        controller.animateToPage(
          indexPage,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void voltarPagina() {
    setState(() {
      if (indexPage > 0) {
        indexPage--;
        controller.animateToPage(
          indexPage,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }
}
