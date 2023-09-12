import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcc_hugo/const_colors.dart';
import 'package:tcc_hugo/models/pet.dart';
import 'package:tcc_hugo/repositorys/antiparasitario_repository.dart';
import 'package:tcc_hugo/repositorys/banho_repository.dart';
import 'package:tcc_hugo/repositorys/consulta_repository.dart';
import 'package:tcc_hugo/repositorys/tosa_repository.dart';
import 'package:tcc_hugo/repositorys/vacina_repository.dart';
import 'package:tcc_hugo/repositorys/vermifugo_repository.dart';
import 'package:tcc_hugo/widgets/util.dart';

class CardGastos extends StatefulWidget {
  Pet pet;
  DateTime inicio;
  DateTime fim;
  CardGastos(this.pet, this.inicio, this.fim, {super.key});

  @override
  State<CardGastos> createState() => _CardGastosState();
}

class _CardGastosState extends State<CardGastos> {
  bool detalhar = false;
  @override
  Widget build(BuildContext context) {
    return Consumer6<
            BanhosRepository,
            VacinasRepository,
            TosasRepository,
            VermifugosRepository,
            AntiparasitariosRepository,
            ConsultasRepository>(
        builder: (context, banhos, vacinas, tosas, vermifugos, antiparasitarios,
            consultas, child) {
      double gastoTotal = 0;
      double gastosBanhos = 0;
      double gastosVacinas = 0;
      double gastosTosas = 0;
      double gastosVermifugos = 0;
      double gastosAntiparasitarios = 0;
      double gastosConsultas = 0;

      if (banhos.isLoading ||
          vacinas.isLoading ||
          tosas.isLoading ||
          vermifugos.isLoading ||
          antiparasitarios.isLoading ||
          consultas.isLoading) return CircularProgressIndicator();

      if (banhos.map.isNotEmpty) {
        if (banhos.map.containsKey(widget.pet.id) &&
            banhos.map[widget.pet.id]!.isNotEmpty) {
          for (var banho in banhos.map[widget.pet.id]!) {
            if (banho.data!.isAfter(widget.inicio) &&
                banho.data!.isBefore(widget.fim)) {
              if (banho.custo != null) {
                gastosBanhos += banho.custo!;
              }
            }
          }
        }
      }

      if (vacinas.map.isNotEmpty) {
        if (vacinas.map.containsKey(widget.pet.id) &&
            vacinas.map[widget.pet.id]!.isNotEmpty) {
          for (var vacina in vacinas.map[widget.pet.id]!) {
            if (vacina.data!.isAfter(widget.inicio) &&
                vacina.data!.isBefore(widget.fim)) {
              if (vacina.custo != null) {
                gastosVacinas += vacina.custo!;
              }
            }
          }
        }
      }

      if (tosas.map.isNotEmpty) {
        if (tosas.map.containsKey(widget.pet.id) &&
            tosas.map[widget.pet.id]!.isNotEmpty) {
          for (var tosa in tosas.map[widget.pet.id]!) {
            if (tosa.data!.isAfter(widget.inicio) &&
                tosa.data!.isBefore(widget.fim)) {
              if (tosa.custo != null) {
                gastosTosas += tosa.custo!;
              }
            }
          }
        }
      }

      if (vermifugos.map.isNotEmpty) {
        if (vermifugos.map.containsKey(widget.pet.id) &&
            vermifugos.map[widget.pet.id]!.isNotEmpty) {
          for (var vermifugo in vermifugos.map[widget.pet.id]!) {
            if (vermifugo.data!.isAfter(widget.inicio) &&
                vermifugo.data!.isBefore(widget.fim)) {
              if (vermifugo.custo != null) {
                gastosVermifugos += vermifugo.custo!;
              }
            }
          }
        }
      }

      if (antiparasitarios.map.isNotEmpty) {
        if (antiparasitarios.map.containsKey(widget.pet.id) &&
            antiparasitarios.map[widget.pet.id]!.isNotEmpty) {
          for (var antiparasitario in antiparasitarios.map[widget.pet.id]!) {
            if (antiparasitario.data!.isAfter(widget.inicio) &&
                antiparasitario.data!.isBefore(widget.fim)) {
              if (antiparasitario.custo != null) {
                gastosAntiparasitarios += antiparasitario.custo!;
              }
            }
          }
        }
      }

      if (consultas.map.isNotEmpty) {
        if (consultas.map.containsKey(widget.pet.id) &&
            consultas.map[widget.pet.id]!.isNotEmpty) {
          for (var consulta in consultas.map[widget.pet.id]!) {
            if (consulta.data!.isAfter(widget.inicio) &&
                consulta.data!.isBefore(widget.fim)) {
              if (consulta.custo != null) {
                gastosConsultas += consulta.custo!;
              }
            }
          }
        }
      }

      gastoTotal = gastosBanhos +
          gastosVacinas +
          gastosTosas +
          gastosVermifugos +
          gastosAntiparasitarios +
          gastosConsultas;

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: InkWell(
          onTap: () {
            setState(() {
              detalhar = !detalhar;
            });
          },
          child: Card(
            elevation: 5,
            child: Container(
                child: ListTile(
              dense: true,
              leading: ClipOval(
                  child: Container(
                      height: 40,
                      width: 40,
                      child: Image.network(widget.pet.foto!))),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text("${widget.pet.nome!.toUpperCase()}",
                              style: TextStyle(
                                  color: kSecundaryColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: RichText(
                            text: TextSpan(text: "R\$", style: TextStyle(fontSize: 8, color: Colors.black), children: [
                              TextSpan(
                                  text:
                                      " ${gastoTotal.toStringAsFixed(2).replaceAll(".", ",")}",style: TextStyle(fontSize: 18))
                            ]),
                          ),
                        ),
                        Icon(
                          detalhar
                              ? Icons.arrow_drop_up_outlined
                              : Icons.arrow_drop_down_outlined,
                        )
                      ],
                    ),
                  ),
                  Visibility(
                    visible: detalhar,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Banhos: ${UtilBrasilFields.obterReal(gastosBanhos)}"),
                          Espaco(height: 5,),
                          Text("Vacinas: ${UtilBrasilFields.obterReal(gastosVacinas)}"),
                          Espaco(height: 5,),
                          Text("Tosas: ${UtilBrasilFields.obterReal(gastosTosas)}"),
                          Espaco(height: 5,),
                          Text("Vermífugos: ${UtilBrasilFields.obterReal(gastosVermifugos)}"),
                          Espaco(height: 5,),
                          Text("Antiparasitários: ${UtilBrasilFields.obterReal(gastosAntiparasitarios)}"),
                          Espaco(height: 5,),
                          Text("Consultas: ${UtilBrasilFields.obterReal(gastosConsultas)}"),
                          Espaco(height: 5,),
                          Text("Outros: R\$"),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )),
          ),
        ),
      );
    });
  }
}
