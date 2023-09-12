import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tcc_hugo/const_colors.dart';
import 'package:tcc_hugo/const_text_styles.dart';
import 'package:tcc_hugo/models/antiparasitario.dart';
import 'package:tcc_hugo/models/banho.dart';
import 'package:tcc_hugo/models/consulta.dart';
import 'package:tcc_hugo/models/tosa.dart';
import 'package:tcc_hugo/models/vacina.dart';
import 'package:tcc_hugo/models/vermifugo.dart';
import 'package:tcc_hugo/repositorys/antiparasitario_repository.dart';
import 'package:tcc_hugo/repositorys/banho_repository.dart';
import 'package:tcc_hugo/repositorys/consulta_repository.dart';
import 'package:tcc_hugo/repositorys/pet_repository.dart';
import 'package:tcc_hugo/repositorys/tosa_repository.dart';
import 'package:tcc_hugo/repositorys/vacina_repository.dart';
import 'package:tcc_hugo/repositorys/vermifugo_repository.dart';
import 'package:tcc_hugo/widgets/buttonGenerico.dart';

class ResumoDeGastos extends StatefulWidget {
  const ResumoDeGastos({super.key});

  @override
  State<ResumoDeGastos> createState() => _ResumoDeGastosState();
}

class _ResumoDeGastosState extends State<ResumoDeGastos> {
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text(
              "Gastos",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20,
                  color: kPrimaryColor,
                  fontWeight: FontWeight.w600),
            ),
            InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/relatorioGastos');
                },
                child: Row(children: [
                  Text("Detalhar ", style: styleText1.copyWith(fontSize: 12)),
                  Icon(
                    Icons.details_outlined,
                    color: kPrimaryColor,
                  )
                ]))
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
        child: Text("Resumo geral dos gastos",
            style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w400,
              fontSize: 12,
            )),
      ),
      Consumer<PetsRepository>(builder: (context, pets, child) {
        if (pets.isLoading)
          return Center(
            child: CircularProgressIndicator(),
          );
        return Consumer6<
                BanhosRepository,
                TosasRepository,
                VacinasRepository,
                VermifugosRepository,
                ConsultasRepository,
                AntiparasitariosRepository>(
            builder: (context, banhos, tosas, vacinas, vermifugos, consultas,
                antiparasitarios, child) {
          if (banhos.isLoading ||
              tosas.isLoading ||
              vacinas.isLoading ||
              vermifugos.isLoading ||
              consultas.isLoading ||
              antiparasitarios.isLoading)
            return Center(
              child: CircularProgressIndicator(),
            );
          double gastoMes = 0;
          double gastoAno = 0;
          double gastoTotal = 0;

          if (banhos.map.isNotEmpty) {
            for (var pet in banhos.pets.lista) {
              //banhos
              if (banhos.map.isNotEmpty) {
                if (banhos.map.containsKey(pet.id) &&
                    banhos.map[pet.id]!.isNotEmpty) {
                  for (var banho in banhos.map[pet.id]!) {
                    if (banho.custo != null) {
                      gastoTotal += banho.custo!;
                      if (isDateInCurrentMonth(banho.data!)) {
                        gastoMes += banho.custo!;
                        gastoAno += banho.custo!;
                      } else if (isDateInCurrentYear(banho.data!)) {
                        gastoAno += banho.custo!;
                      }
                    }
                  }
                }
              }
              //tosas
              if (tosas.map.isNotEmpty) {
                if (tosas.map.containsKey(pet.id) &&
                    tosas.map[pet.id]!.isNotEmpty) {
                  for (var tosa in tosas.map[pet.id]!) {
                    if (tosa.custo != null) {
                      gastoTotal += tosa.custo!;
                      if (isDateInCurrentMonth(tosa.data!)) {
                        gastoMes += tosa.custo!;
                        gastoAno += tosa.custo!;
                      } else if (isDateInCurrentYear(tosa.data!)) {
                        gastoAno += tosa.custo!;
                      }
                    }
                  }
                }
              }

              //vacinas
              if (vacinas.map.isNotEmpty) {
                if (vacinas.map.containsKey(pet.id) &&
                    vacinas.map[pet.id]!.isNotEmpty) {
                  for (var vacina in vacinas.map[pet.id]!) {
                    if (vacina.custo != null) {
                      gastoTotal += vacina.custo!;
                      if (isDateInCurrentMonth(vacina.data!)) {
                        gastoMes += vacina.custo!;
                        gastoAno += vacina.custo!;
                      } else if (isDateInCurrentYear(vacina.data!)) {
                        gastoAno += vacina.custo!;
                      }
                    }
                  }
                }
              }
              //vermifugos
              if (vermifugos.map.isNotEmpty) {
                if (vermifugos.map.containsKey(pet.id) &&
                    vermifugos.map[pet.id]!.isNotEmpty) {
                  for (var vermifugo in vermifugos.map[pet.id]!) {
                    if (vermifugo.custo != null) {
                      gastoTotal += vermifugo.custo!;
                      if (isDateInCurrentMonth(vermifugo.data!)) {
                        gastoMes += vermifugo.custo!;
                        gastoAno += vermifugo.custo!;
                      } else if (isDateInCurrentYear(vermifugo.data!)) {
                        gastoAno += vermifugo.custo!;
                      }
                    }
                  }
                }
              }

              //consultass
              if (consultas.map.isNotEmpty) {
                if (consultas.map.containsKey(pet.id) &&
                    consultas.map[pet.id]!.isNotEmpty) {
                  for (var consulta in consultas.map[pet.id]!) {
                    if (consulta.custo != null) {
                      gastoTotal += consulta.custo!;
                      if (isDateInCurrentMonth(consulta.data!)) {
                        gastoMes += consulta.custo!;
                        gastoAno += consulta.custo!;
                      } else if (isDateInCurrentYear(consulta.data!)) {
                        gastoAno += consulta.custo!;
                      }
                    }
                  }
                }
              }

              //
              //antiparasitario
              if (antiparasitarios.map.isNotEmpty) {
                if (antiparasitarios.map.containsKey(pet.id) &&
                    antiparasitarios.map[pet.id]!.isNotEmpty) {
                  for (var antiparasitario in antiparasitarios.map[pet.id]!) {
                    if (antiparasitario.custo != null) {
                      gastoTotal += antiparasitario.custo!;
                      if (isDateInCurrentMonth(antiparasitario.data!)) {
                        gastoMes += antiparasitario.custo!;
                        gastoAno += antiparasitario.custo!;
                      } else if (isDateInCurrentYear(antiparasitario.data!)) {
                        gastoAno += antiparasitario.custo!;
                      }
                    }
                  }
                }
              }
            }
          }

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                card(DateFormat('MMMM y', 'pt_BR').format(DateTime.now()),
                    gastoMes),
                card("Ano de "+DateFormat('y', 'pt_BR').format(DateTime.now()), gastoAno),
                card("Todos", gastoTotal),
              ],
            ),
          );
        });
      })
    ]);
  }

  bool isDateInCurrentMonth(DateTime date) {
    DateTime currentDate = DateTime.now();
    return date.year == currentDate.year && date.month == currentDate.month;
  }

  bool isDateInCurrentYear(DateTime date) {
    DateTime currentDate = DateTime.now();
    return date.year == currentDate.year;
  }

  card(String txt, double valor) {
    return Expanded(
      child: SizedBox(
        height: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "R\$                  ",
              style: TextStyle(fontSize: 10),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: Text(
                "${valor.toStringAsFixed(2).replaceAll(".", ",")}",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
            ),
            Text(
              txt.toUpperCase(),
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 10,
                  color: kPrimaryColor),
            )
          ],
        ),
      ),
    );
  }
}
