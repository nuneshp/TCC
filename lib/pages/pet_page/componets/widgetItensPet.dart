import 'package:flutter/material.dart';
import 'package:tcc_hugo/const_colors.dart';

class WidgetItensPet extends StatelessWidget {
  int indexPet;
   WidgetItensPet({Key? key, required this.indexPet}) : super(key: key);

  List icones = [
      {"nome": "Banhos", "img": "assets/images/ico_banho.png", "rota": "/banho"},
      {"nome": "Vacinas", "img": "assets/images/ico_vacina.png", "rota": "/vacina"},
      {"nome": "Tosas", "img": "assets/images/ico_tosa.png", "rota": "/tosa"},
      {"nome": "Vermífugos", "img": "assets/images/ico_vermifugo.png", "rota": "/vermifugo"},
      {"nome": "Antiparasit.", "img": "assets/images/ico_antiparasitario.png", "rota": "/antiparasitario"},
      {"nome": "Pesos", "img": "assets/images/ico_peso.png", "rota": "/peso"},
      {"nome": "Consultas", "img": "assets/images/ico_consulta.png", "rota": "/consulta"},
      // {"nome": "Exames", "img": "assets/images/ico_exame.png", "rota": "/exame"},
      {"nome": "Fotos", "img": "assets/images/ico_foto.png", "rota": "/foto"},
    ];

  @override
  Widget build(BuildContext context) {
    final indexPet = ModalRoute.of(context)!.settings.arguments as int;
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.transparent, borderRadius: BorderRadius.all(Radius.circular(20))),
      child: GridView.count(
        physics: NeverScrollableScrollPhysics() ,
        shrinkWrap: true,
        crossAxisCount: 5,
        children: List.generate(icones.length, (index) {
          return iconeCategoria(index, context);
        }),
      ),
    );
  }

  iconeCategoria(int index, context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, icones[index]['rota'], arguments: indexPet);
      },
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Column(
          children: [
            Expanded(
              child: ClipOval(
                child:
                    Container(
                      padding: EdgeInsets.all(6),
                      color: kSecundaryColor.withAlpha(100), child: Image.asset(icones[index]["img"], fit:BoxFit.fill)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                icones[index]["nome"],
                style: TextStyle(fontSize: 10),
              ),
            )
          ],
        ),
      ),
    );
  }
}
