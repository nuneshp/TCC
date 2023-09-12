import 'package:flutter/material.dart';
import 'package:tcc_hugo/auth_check.dart';
import 'package:tcc_hugo/pages/avaliacao_page/avaliacao_page.dart';
import 'package:tcc_hugo/pages/home_page/components/calendario.dart';
import 'package:tcc_hugo/pages/home_page/home_page.dart';
import 'package:tcc_hugo/pages/perfil_page/perfil_page.dart';
import 'package:tcc_hugo/pages/relatorio_gastos_page/relatorio_gastos_page.dart';

import 'pages/antiparasitario_page/antiparasitario_page.dart';
import 'pages/banho_page/banho_page.dart';
import 'pages/consulta_page/consulta_page.dart';
import 'pages/foto_page/foto_page.dart';
import 'pages/login/esqueceu_senha_page.dart';
import 'pages/login/login_page.dart';
import 'pages/login/registrar_page.dart';
import 'pages/login/verificar_email_page.dart';
import 'pages/peso_page/peso_page.dart';
import 'pages/pet_page/add_pet_page.dart';
import 'pages/pet_page/pet_detalhes_page.dart';
import 'pages/postagem_page/postagem_page.dart';
import 'pages/tosa_page/tosa_page.dart';
import 'pages/vacina_page/vacina_page.dart';
import 'pages/vermifugo_page/vermifugo_page.dart';

class Routes {
  static Map<String, Widget Function(BuildContext)> list =
      <String, WidgetBuilder>{
    HomePage.routeName: (context) => HomePage(),
    Calendario.routeName:(context) => Calendario(),
    AuthCheck.routeName: (context) => AuthCheck(),
    RegistrarPage.routeName: (context) => RegistrarPage(),
    VerificarEmailPage.routeName: (context) => VerificarEmailPage(),
    LoginPage.routeName: (context) => LoginPage(),
    AddPetPage.routeName: (context) => AddPetPage(),
    PetDetalhesPage.routeName: (context) => PetDetalhesPage(),
    EsqueceuSenhaPage.routeName: (context) => EsqueceuSenhaPage(),
    PesoPage.routeName: (context) => PesoPage(),
    VermifugoPage.routeName: (context) => VermifugoPage(),
    BanhoPage.routeName: (context) => BanhoPage(),
    TosaPage.routeName: (context) => TosaPage(),
    VacinaPage.routeName: (context) => VacinaPage(),
    PostagemPage.routeName: (context) => PostagemPage(),
    ConsultaPage.routeName: (context) => ConsultaPage(),
    FotoPage.routeName: (context) => FotoPage(),
    AntiparasitarioPage.routeName: (context) => AntiparasitarioPage(),
    PerfilPage.routeName: (context) => PerfilPage(),
    RelatorioGastosPage.routeName: (context) => RelatorioGastosPage(),
    AvaliacaoPage.routeName: (context) => AvaliacaoPage()
   
  };

  static String initial = '/';

  static GlobalKey<NavigatorState>? navigatorKey = GlobalKey<NavigatorState>();
}

class NotificacaoPage extends StatefulWidget {
  const NotificacaoPage({super.key});

  @override
  State<NotificacaoPage> createState() => _NotificacaoPageState();
}

class _NotificacaoPageState extends State<NotificacaoPage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
