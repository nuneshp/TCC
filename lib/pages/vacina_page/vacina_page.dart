import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tcc_hugo/const_colors.dart';
import 'package:tcc_hugo/models/vacina.dart';
import 'package:tcc_hugo/pages/vacina_page/components/quadroDeVacinas.dart';
import 'package:tcc_hugo/repositorys/vacina_repository.dart';
import 'package:tcc_hugo/repositorys/pet_repository.dart';
import 'package:tcc_hugo/widgets/circularProgress.dart';
import 'package:tcc_hugo/widgets/util.dart';
import 'package:tcc_hugo/pages/vacina_page/components/addVacina.dart';

class VacinaPage extends StatefulWidget {
  static const routeName = '/vacina';
  VacinaPage({Key? key}) : super(key: key);

  @override
  State<VacinaPage> createState() => _VacinaPageState();
}

class _VacinaPageState extends State<VacinaPage> {
  @override
  Widget build(BuildContext context) {
    int indexPet = ModalRoute.of(context)!.settings.arguments as int;

    return Consumer2<PetsRepository, VacinasRepository>(
        builder: (context, pets, vacinas, child) {
      return Scaffold(
        backgroundColor: kWhite,
        appBar: AppBar(
          title: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: pets.lista[indexPet].foto != null
                    ? ClipOval(
                        child: Image.network(
                          pets.lista[indexPet].foto!,
                          width: 40,
                        ),
                      )
                    : ClipOval(
                        child: Image.asset(
                          "assets/images/logo.png",
                          height: 40,
                          width: 40,
                        ),
                      ),
              ),
              Text("${pets.lista[indexPet].nome!.toUpperCase()}",
                  style: TextStyle(
                      fontSize: 16,
                      color: kPrimaryColor,
                      fontWeight: FontWeight.w600)),
            ],
          ),
          elevation: 0,
          backgroundColor: kWhite,
          iconTheme: IconThemeData(color: kPrimaryColor),
        ),
        floatingActionButton: FloatingActionButton(
            backgroundColor: kPrimaryColor,
            isExtended: true,
            onPressed: () {
              addVacinaDialog(context, pets.lista[indexPet].id!, familia: pets.lista[indexPet].familia);
            },
            child: Icon(Icons.add)),
        body: Column(
          children: [
            Espaco(),
            Center(
                child: Image.asset(
              "assets/images/ico_vacina.png",
              height: 120,
            )),
            Espaco(),
            const Text(
              "Vacinas",
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontSize: 20,
                  color: kPrimaryColor,
                  fontWeight: FontWeight.w600),
            ),
            Espaco(),
            Consumer<VacinasRepository>(builder: (context, vacinas, child) {
              return  vacinas.isLoading
                  ? Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator()
                    
                        ],
                      ))
                  : Expanded(child: QuadroDeVacinas(indexPet: indexPet));
            })
          ],
        ),
      );
    });
  }
}
