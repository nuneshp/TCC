import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tcc_hugo/databases/db_firestore.dart';
import 'package:tcc_hugo/models/pet.dart';
import 'package:tcc_hugo/models/vermifugo.dart';
import 'package:tcc_hugo/repositorys/pet_repository.dart';
import 'package:tcc_hugo/services/auth_service.dart';
import 'package:tcc_hugo/services/storage.dart';

class VermifugosRepository extends ChangeNotifier {
  bool isLoading =true;
  Map<String, List<Vermifugo>> _map = {};
  late PetsRepository pets;
  late FirebaseFirestore db;
  late Storage storage;
  late AuthService auth;

  VermifugosRepository({required this.auth, required this.pets}) {
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

        List<Vermifugo> lista = [];
        if (snapshot.exists) {
          if (snapshot.data()!.containsKey('vermifugos')) {
            List<dynamic> vermifugosData = snapshot.data()!['vermifugos'];
            lista = vermifugosData
                .map((vermifugoData) => Vermifugo.fromJson(vermifugoData))
                .toList();
          }
        }

        _map[pet.id!] = lista;
      }
    }
    isLoading = false;
    notifyListeners();
  
  }

  
  UnmodifiableMapView<String, List<Vermifugo>> get map => UnmodifiableMapView(_map);

  set(Vermifugo vermifugo, String idPet) async {
    Pet? pet = pets.getPet(idPet);
   vermifugo.id=DateTime.now().toString();

    final collectionVermifugo =
        db.collection('usuarios/${auth.usuario!.email}/pets');
    final collectionNotifica = db.collection('notificacoes');

    // Criar o objeto Batch
    final batch = db.batch();
    final vermifugoRef = collectionVermifugo.doc(idPet);
    batch.set(
        vermifugoRef,
        {
          "vermifugos": FieldValue.arrayUnion([vermifugo.toJson()])
        },
        SetOptions(merge: true));

    if (vermifugo.proximaData!.isAfter(DateTime.now())) {
      final notificaRef = collectionNotifica.doc("lista");

      batch.set(
          notificaRef,
          {
            auth.usuario!.uid: {idPet: FieldValue.arrayUnion([
      {
                  'titulo': pet!.nome!.toUpperCase(),
                  'descricao': 'Vermífugo agendado para hoje',
                  'idPet': idPet,
                  'payload': '',
                  'data': vermifugo.proximaData
                },
            ])}
          },
          SetOptions(merge: true));
    }

    await batch.commit();

    if(_map[idPet]==null){
      _map[idPet]=[];
    }
    _map[idPet]!.add(vermifugo);
    notifyListeners();
  }

  remove(Vermifugo vermifugo, String idPet) async {
      Pet? pet = pets.getPet(idPet);
       final collectionVermifugo =
        db.collection('usuarios/${auth.usuario!.email}/pets');
    final collectionNotifica = db.collection('notificacoes');

    // Criar o objeto Batch
    final batch = db.batch();
    final vermifugoRef = collectionVermifugo.doc(idPet);

    batch.update(
      vermifugoRef,
      {
        "vermifugos": FieldValue.arrayRemove([vermifugo.toJson()])
      },
    );

    if (vermifugo.proximaData!.isAfter(DateTime.now())) {
      final notificaRef = collectionNotifica.doc("lista");

      batch.update(
        notificaRef,
        {
          "${auth.usuario!.uid}.$idPet": FieldValue.arrayRemove([
            {
                  'titulo': pet!.nome!.toUpperCase(),
                  'descricao': 'Vermífugo agendado para hoje',
                  'idPet': idPet,
                  'payload': '',
                  'data': vermifugo.proximaData
                },
          ])
        },
      );
    }

    await batch.commit();

    _map[idPet]!.remove(vermifugo);
    notifyListeners();
}

  update(Vermifugo old, Vermifugo novo, String idPet) async {
    try {
      remove(old, idPet);
      set(novo, idPet);
    } catch (e) {
      print("erro");
    }
  }
}
