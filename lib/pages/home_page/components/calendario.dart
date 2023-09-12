import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tcc_hugo/const_colors.dart';
import 'package:tcc_hugo/repositorys/antiparasitario_repository.dart';
import 'package:tcc_hugo/repositorys/banho_repository.dart';
import 'package:tcc_hugo/repositorys/consulta_repository.dart';
import 'package:tcc_hugo/repositorys/peso_repository.dart';
import 'package:tcc_hugo/repositorys/pet_repository.dart';
import 'package:tcc_hugo/repositorys/tosa_repository.dart';
import 'package:tcc_hugo/repositorys/vacina_repository.dart';
import 'package:tcc_hugo/repositorys/vermifugo_repository.dart';
import 'package:tcc_hugo/widgets/util.dart';

import '../../../models/evento.dart';

class Calendario extends StatefulWidget {
  static const routeName = '/calendario';
  const Calendario({super.key});

  @override
  State<Calendario> createState() => _CalendarioState();
}

class _CalendarioState extends State<Calendario> {
  List<Evento> events = [];
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

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
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: SingleChildScrollView(
              child: Consumer6<
                      // PetsRepository,
                      BanhosRepository,
                      TosasRepository,
                      VacinasRepository,
                      VermifugosRepository,
                      ConsultasRepository,
                      AntiparasitariosRepository>(
                  builder: (context, banhos, tosas, vacinas, vermifugos,
                      consultas, antiparasitarios, child) {

                         

                if (banhos.isLoading ||
                    tosas.isLoading ||
                    vacinas.isLoading ||
                    vermifugos.isLoading ||
                    consultas.isLoading ||
                    antiparasitarios.isLoading)
                  return SizedBox(
                    height: MediaQuery.of(context).size.height*0.8,
                    child: Lottie.asset("assets/lotties/calendario_loading.json"));

                if (banhos.pets.lista.isNotEmpty && banhos.map.isNotEmpty) {
                  events = [];

                  for (var pet in banhos.pets.lista) {
                    //banhos
                    if (banhos.map.isNotEmpty) {
                      if (banhos.map.containsKey(pet.id) &&
                          banhos.map[pet.id]!.isNotEmpty) {
                        for (var banho in banhos.map[pet.id]!) {
                          //verifica se é o ultimo
                          bool _check = false;
                          for (var i in banhos.map[pet.id]!) {
                            if (banho.data!.difference(i.data!).inDays < 0)
                              _check = true;
                          }
                          events.add(Evento(
                              "Banho",
                              banho.proximaData!,
                              pet.nome!,
                              pet.foto,
                              "/banho",
                              banhos.pets.lista.indexOf(pet),
                              _check));
                        }
                      }
                    }
                    //tosas
                    if (tosas.map.isNotEmpty) {
                      if (tosas.map.containsKey(pet.id) &&
                          tosas.map[pet.id]!.isNotEmpty) {
                        for (var tosa in tosas.map[pet.id]!) {
                          //verifica se é o ultimo
                          bool _check = false;
                          for (var i in tosas.map[pet.id]!) {
                            if (tosa.data!.difference(i.data!).inDays < 0)
                              _check = true;
                          }
                          events.add(Evento(
                              "Tosa",
                              tosa.proximaData!,
                              pet.nome!,
                              pet.foto,
                              "/tosa",
                              banhos.pets.lista.indexOf(pet),
                              _check));
                        }
                      }
                    }

                    //pesos - nao é recorrente
                    // if (pesos.map.isNotEmpty) {
                    //   if (pesos.map.containsKey(pet.id) &&
                    //       pesos.map[pet.id]!.isNotEmpty) {
                    //     for (var peso in pesos.map[pet.id]!) {
                    //       events.add(Evento("Peso", peso.data!,pet.nome!, pet.foto! ));
                    //     }
                    //   }
                    // }

                    //vacinas
                    if (vacinas.map.isNotEmpty) {
                      if (vacinas.map.containsKey(pet.id) &&
                          vacinas.map[pet.id]!.isNotEmpty) {
                        for (var vacina in vacinas.map[pet.id]!) {
                          //verifica se é o ultimo
                          bool _check = false;

                          for (var i in vacinas.map[pet.id]!) {
                            if (vacina.categoria == i.categoria &&
                                vacina.data!.difference(i.data!).inDays < 0) {
                              _check = true;
                            }
                          }

                          events.add(Evento(
                              "Vacina (${vacina.categoria})",
                              vacina.proximaData!,
                              pet.nome!,
                              pet.foto,
                              "/vacina",
                              banhos.pets.lista.indexOf(pet),
                              _check));
                        }
                      }
                    }
                    //vermifugos
                    if (vermifugos.map.isNotEmpty) {
                      if (vermifugos.map.containsKey(pet.id) &&
                          vermifugos.map[pet.id]!.isNotEmpty) {
                        for (var vermifugo in vermifugos.map[pet.id]!) {
                          //verifica se é o ultimo
                          bool _check = false;
                          for (var i in vermifugos.map[pet.id]!) {
                            if (vermifugo.data!.difference(i.data!).inDays < 0)
                              _check = true;
                          }
                          events.add(Evento(
                              "Vermifugo",
                              vermifugo.proximaData!,
                              pet.nome!,
                              pet.foto,
                              "/vermifugo",
                              banhos.pets.lista.indexOf(pet),
                              _check));
                        }
                      }
                    }

                    //consultass
                    if (consultas.map.isNotEmpty) {
                      if (consultas.map.containsKey(pet.id) &&
                          consultas.map[pet.id]!.isNotEmpty) {
                        for (var consulta in consultas.map[pet.id]!) {
                          //verifica se é o ultimo
                          bool _check = false;
                          for (var i in consultas.map[pet.id]!) {
                            if (consulta.data!.difference(i.data!).inDays < 0)
                              _check = true;
                          }
                          events.add(Evento(
                              "Consulta",
                              consulta.proximaData!,
                              pet.nome!,
                              pet.foto,
                              "/consulta",
                              banhos.pets.lista.indexOf(pet),
                              _check));
                        }
                      }
                    }

                    //
                    //consultass
                    if (antiparasitarios.map.isNotEmpty) {
                      if (antiparasitarios.map.containsKey(pet.id) &&
                          antiparasitarios.map[pet.id]!.isNotEmpty) {
                        for (var antiparasitario
                            in antiparasitarios.map[pet.id]!) {
                          //verifica se é o ultimo
                          bool _check = false;
                          for (var i in antiparasitarios.map[pet.id]!) {
                            if (antiparasitario.data!
                                    .difference(i.data!)
                                    .inDays <
                                0) _check = true;
                          }
                          events.add(Evento(
                              "Antiparasitarios",
                              antiparasitario.proximaData!,
                              pet.nome!,
                              pet.foto,
                              "/antiparasitario",
                              banhos.pets.lista.indexOf(pet),
                              _check));
                        }
                      }
                    }
                  }
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Datas Importantes",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20,
                          color: kPrimaryColor,
                          fontWeight: FontWeight.w600),
                    ),
                    Espaco(),
                    TableCalendar(
                      firstDay: DateTime.utc(2010, 10, 16),
                      lastDay: DateTime.utc(2030, 3, 14),
                      focusedDay: _focusedDay,
                      locale: 'pt_BR',
                      eventLoader: (day) {
                        return events
                            .where((event) => isSameDay(event.date, day))
                            .toList();
                      },
                      headerStyle: const HeaderStyle(
                        formatButtonVisible: false,
                        titleCentered: true,
                        titleTextStyle:
                            TextStyle(color: Colors.white, fontSize: 20.0),
                        decoration: BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10))),
                        formatButtonTextStyle:
                            TextStyle(color: Colors.white, fontSize: 16.0),
                        leftChevronIcon: Icon(
                          Icons.chevron_left,
                          color: Colors.white,
                          size: 28,
                        ),
                        rightChevronIcon: Icon(
                          Icons.chevron_right,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      calendarBuilders: CalendarBuilders(
                        markerBuilder: (context, date, events) {
                          if (events.isNotEmpty) {
                            //testando isso
                            int _atrasado = 0;
                            int _ok = 0;
                            int _futuro = 0;

                            for (Evento event in events as List<Evento>) {
                              if (event.check) {
                                _ok++;
                              } else if (event.date
                                      .difference(DateTime.now())
                                      .inDays >=
                                  0) {
                                _futuro++;
                              } else {
                                _atrasado++;
                              }
                            } //

                            return Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  if (_atrasado > 0)
                                    Container(
                                      padding: EdgeInsets.all(1),
                                      height: 15,
                                      width: 15,
                                      color: Colors.red,
                                      child: Center(
                                        child: Text(
                                          _atrasado.toString(),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  if (_futuro > 0)
                                    Container(
                                      padding: EdgeInsets.all(1),
                                      height: 15,
                                      width: 15,
                                      color: kSecundaryColor,
                                      child: Center(
                                        child: Text(
                                          _futuro.toString(),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  if (_ok > 0)
                                    Container(
                                      padding: EdgeInsets.all(1),
                                      height: 15,
                                      width: 15,
                                      color: Colors.green,
                                      child: Center(
                                        child: Text(
                                          _ok.toString(),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                ]);
                          } else {
                            return Container();
                          }
                        },
                        dowBuilder: (context, day) {
                          if (day.weekday == DateTime.sunday ||
                              day.weekday == DateTime.saturday) {
                            final text = DateFormat.E().format(day);

                            return Center(
                              child: Text(
                                text,
                                style: TextStyle(color: Colors.blue),
                              ),
                            );
                          }
                        },
                      ),
                      calendarFormat: CalendarFormat.month,
                      selectedDayPredicate: (day) {
                        return isSameDay(_selectedDay, day);
                      },
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          _selectedDay = selectedDay;
                          _focusedDay =
                              focusedDay; // update `_focusedDay` here as well
                        });
                      },
                    ),
                    Espaco(
                      height: 30,
                    ),
                    Text(
                      "Tarefas ${DateFormat('dd/MMMM', 'pt_BR').format(_selectedDay)}",
                      style: TextStyle(
                          fontSize: 20,
                          color: kPrimaryColor,
                          fontWeight: FontWeight.w600),
                    ),
                    Divider(),
                    Espaco(),
                    ...events.map(
                        (myEvents) => (isSameDay(myEvents.date, _selectedDay))
                            ? InkWell(
                                onTap: () {
                                  Navigator.pushNamed(context, myEvents.rota,
                                      arguments: myEvents.indexPet);
                                },
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: ListTile(
                                          leading: myEvents.urlImage != null
                                              ? ClipOval(
                                                  child: Image.network(
                                                    myEvents.urlImage!,
                                                  ),
                                                )
                                              : ClipOval(
                                                  child: Image.asset(
                                                      "assets/images/logo.png"),
                                                ),
                                          title: Text('${myEvents.title}'),
                                          subtitle: Text(
                                              ' ${myEvents.nomePet.toUpperCase()}')),
                                    ),
                                    myEvents.check
                                        ? Expanded(
                                            child: Icon(
                                            Icons.event_available_outlined,
                                            color: Colors.green,
                                          ))
                                        : (DateTime.now()
                                                    .difference(myEvents.date)
                                                    .inDays <=
                                                0)
                                            ? Expanded(
                                                child: Icon(
                                                Icons.event_outlined,
                                                color: kSecundaryColor,
                                              ))
                                            : Expanded(
                                                child: Icon(
                                                Icons.event_busy_outlined,
                                                color: Colors.red,
                                              ))
                                  ],
                                ),
                              )
                            : Container())
                  ],
                );
              }),
            )));
  }
}
