import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tcc_hugo/databases/db_firestore.dart';
import 'package:tcc_hugo/models/pet.dart';
import 'package:tcc_hugo/models/vacina.dart';
import 'package:tcc_hugo/repositorys/pet_repository.dart';
import 'package:tcc_hugo/services/auth_service.dart';
import 'package:tcc_hugo/services/storage.dart';

class VacinasRepository extends ChangeNotifier {
  bool isLoading = true;
  Map<String, List<Vacina>> _map = {};
  late PetsRepository pets;
  late FirebaseFirestore db;
  late Storage storage;
  late AuthService auth;

  VacinasRepository({required this.auth, required this.pets}) {
    _startRepository();
  }

  _startRepository() async {
    _startFirestore();
    await _read();
  }

  _startFirestore() {
    db = DBFirestore.get();
    storage = Storage(auth: auth);
  }

  refresh() async {
    try {
      isLoading = true;
      _map = {};
      await _read();
      isLoading = false;
      notifyListeners();
    } catch (e) {}
  } 

   _read() async {
    if (auth.usuario != null && _map.isEmpty && pets.lista.isNotEmpty) {
      for (var pet in pets.lista) {
        final snapshot = await db
            .collection('usuarios/${auth.usuario!.email}/pets')
            .doc(pet.id!)
            .get();

        List<Vacina> lista = [];
        if (snapshot.exists) {
          if (snapshot.data()!.containsKey('vacinas')) {
            List<dynamic> vacinasData = snapshot.data()!['vacinas'];
            lista = vacinasData
                .map((vacinaData) => Vacina.fromJson(vacinaData))
                .toList();
          }
        }

        _map[pet.id!] = lista;
      }
    }
    isLoading = false;
    notifyListeners();
  }

  
  UnmodifiableMapView<String, List<Vacina>> get map => UnmodifiableMapView(_map);

  set(Vacina vacina, String idPet) async {
    Pet? pet = pets.getPet(idPet);
      vacina.id=DateTime.now().toString();

    final collectionVacina =
        db.collection('usuarios/${auth.usuario!.email}/pets');
    final collectionNotifica = db.collection('notificacoes');

    // Criar o objeto Batch
    final batch = db.batch();
    final vacinaRef = collectionVacina.doc(idPet);
    batch.set(
        vacinaRef,
        {
          "vacinas": FieldValue.arrayUnion([vacina.toJson()])
        },
        SetOptions(merge: true));

    if (vacina.proximaData!.isAfter(DateTime.now())) {
      final notificaRef = collectionNotifica.doc("lista");

      batch.set(
          notificaRef,
          {
            auth.usuario!.uid: {idPet: FieldValue.arrayUnion([
              {
                  'titulo': pet!.nome!.toUpperCase(),
                  'descricao': 'Vacina (${vacina.categoria}) agendada para hoje',
                  'idPet': idPet,
                  'payload': '',
                  'data': vacina.proximaData
                },
            ])}
          },
          SetOptions(merge: true));
    }

    await batch.commit();

    if(_map[idPet]==null){
      _map[idPet]=[];
    }
    _map[idPet]!.add(vacina);
    notifyListeners();
  }

  remove(Vacina vacina, String idPet) async {
    Pet? pet = pets.getPet(idPet);
    final collectionVacina =
        db.collection('usuarios/${auth.usuario!.email}/pets');
    final collectionNotifica = db.collection('notificacoes');

    // Criar o objeto Batch
    final batch = db.batch();
    final vacinaRef = collectionVacina.doc(idPet);

    batch.update(
      vacinaRef,
      {
        "vacinas": FieldValue.arrayRemove([vacina.toJson()])
      },
    );

    if (vacina.proximaData!.isAfter(DateTime.now())) {
      final notificaRef = collectionNotifica.doc("lista");

      batch.update(
        notificaRef,
        {
          "${auth.usuario!.uid}.$idPet": FieldValue.arrayRemove([
            {
                  'titulo': pet!.nome!.toUpperCase(),
                  'descricao': 'Vacina (${vacina.categoria}) agendada para hoje',
                  'idPet': idPet,
                  'payload': '',
                  'data': vacina.proximaData
                },
          ])
        },
      );
    }

    await batch.commit();

    _map[idPet]!.remove(vacina);
    notifyListeners();
  }


  update(Vacina old, Vacina novo, String idPet) async {
    try {
      remove(old, idPet);
      set(novo, idPet);
    } catch (e) {
      print("erro");
    }
  }

  Map<String, List<Vacina>> getVacinasCat(String idPet){
    Map<String, List<Vacina>> catVacinas = {};
  List<Vacina> list=[];

  if (_map.containsKey(idPet)) {
    list = _map[idPet]!;

    
    for(var element in list){
      if(!catVacinas.containsKey(element.categoria)){
        catVacinas[element.categoria!]=[];
      }
      catVacinas[element.categoria]!.add(element);
    }
    
  }

  return catVacinas;
  }
}
