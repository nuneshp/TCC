import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:tcc_hugo/const_colors.dart';
import 'package:tcc_hugo/models/pet.dart';
import 'package:tcc_hugo/repositorys/pet_repository.dart';
import 'package:tcc_hugo/widgets/util.dart';

class WidgetCabecalhoPet extends StatelessWidget {
  int indexPet;
  WidgetCabecalhoPet({Key? key, required this.indexPet}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return  Consumer<PetsRepository>(builder: (context, pets, child) {
              return    Padding(
      padding: const EdgeInsets.only(left:20, right:20, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
         Column(
          crossAxisAlignment: CrossAxisAlignment.center,
           children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
              pets.lista[indexPet].foto!=null?
             ClipOval(
               child: Image.network(
                 pets.lista[indexPet].foto!,
                 height: 90,
                 width: 90,
               ),
             ):ClipOval(
               child: Image.asset(
                 "assets/images/logo.png",
                 height: 90,
                 width: 90,
               ),
             ),
              InkWell(
                onTap: (){
                  Navigator.pushNamed(context, '/addEditPet', arguments: indexPet);
                },
                child: ClipOval(
                  child: Container(
                    padding: EdgeInsets.all(2),
                    color: kSecundaryColor,
                    child: Icon(Icons.settings, color: kWhite, size: 18,)),
                )) 
            ],),
            
             Espaco(),
             Text(pets.lista[indexPet].nome!.toUpperCase(),
                  style: TextStyle(
                      fontSize: 16,
                      color: kPrimaryColor,
                      fontWeight: FontWeight.w600)),
           ],
         ),
         
         
          Column(

            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              
              
              Text("${Util().idadePet(pets.lista[indexPet].nascimento!)}",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: kPrimaryColor)),
              Text("Idade",
                  style: TextStyle(fontSize: 16, color: Colors.black))
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              
              
              Text("${pets.lista[indexPet].raca!}",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: kPrimaryColor)),
              Text("Raça",
                  style: TextStyle(fontSize: 16, color: Colors.black))
            ],
          ),
        ],
      ),
    );
  });
}
}