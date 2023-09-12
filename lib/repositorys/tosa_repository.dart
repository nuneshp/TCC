import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tcc_hugo/databases/db_firestore.dart';
import 'package:tcc_hugo/models/pet.dart';
import 'package:tcc_hugo/models/tosa.dart';
import 'package:tcc_hugo/repositorys/pet_repository.dart';
import 'package:tcc_hugo/services/auth_service.dart';
import 'package:tcc_hugo/services/storage.dart';

class TosasRepository extends ChangeNotifier {
  bool isLoading =true;
  Map<String, List<Tosa>> _map = {};
  late PetsRepository pets;
  late FirebaseFirestore db;
  late Storage storage;
  late AuthService auth;

  TosasRepository({required this.auth, required this.pets}) {
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

        List<Tosa> lista = [];
        if (snapshot.exists) {
          if (snapshot.data()!.containsKey('tosas')) {
            List<dynamic> tosasData = snapshot.data()!['tosas'];
            lista = tosasData
                .map((tosaData) => Tosa.fromJson(tosaData))
                .toList();
          }
        }

        _map[pet.id!] = lista;
      }
    }
    isLoading = false;
    notifyListeners();
  }

  
  UnmodifiableMapView<String, List<Tosa>> get map => UnmodifiableMapView(_map);

  set(Tosa tosa, String idPet) async {
    Pet? pet = pets.getPet(idPet);
    tosa.id=DateTime.now().toString();

    final collectionTosa =
        db.collection('usuarios/${auth.usuario!.email}/pets');
    final collectionNotifica = db.collection('notificacoes');

    // Criar o objeto Batch
    final batch = db.batch();
    final tosaRef = collectionTosa.doc(idPet);
    batch.set(
        tosaRef,
        {
          "tosas": FieldValue.arrayUnion([tosa.toJson()])
        },
        SetOptions(merge: true));

    if (tosa.proximaData!.isAfter(DateTime.now())) {
      final notificaRef = collectionNotifica.doc("lista");

      batch.set(
          notificaRef,
          {
            auth.usuario!.uid: {idPet: FieldValue.arrayUnion([
              {
                  'titulo': pet!.nome!.toUpperCase(),
                  'descricao': 'Tosa agendada para hoje',
                  'idPet': idPet,
                  'payload': '',
                  'data': tosa.proximaData
                },
            ])}
          },
          SetOptions(merge: true));
    }

    await batch.commit();

    if(_map[idPet]==null){
      _map[idPet]=[];
    }

    _map[idPet]!.add(tosa);
    notifyListeners();
  }

  remove(Tosa tosa, String idPet) async {
    Pet? pet = pets.getPet(idPet);
       final collectionTosa =
        db.collection('usuarios/${auth.usuario!.email}/pets');
    final collectionNotifica = db.collection('notificacoes');

    // Criar o objeto Batch
    final batch = db.batch();
    final tosaRef = collectionTosa.doc(idPet);

    batch.update(
      tosaRef,
      {
        "tosas": FieldValue.arrayRemove([tosa.toJson()])
      },
    );

    if (tosa.proximaData!.isAfter(DateTime.now())) {
      final notificaRef = collectionNotifica.doc("lista");

      batch.update(
        notificaRef,
        {
          "${auth.usuario!.uid}.$idPet": FieldValue.arrayRemove([
            {
                  'titulo': pet!.nome!.toUpperCase(),
                  'descricao': 'Tosa agendada para hoje',
                  'idPet': idPet,
                  'payload': '',
                  'data': tosa.proximaData
                },
          ])
        },
      );
    }

    await batch.commit();

    _map[idPet]!.remove(tosa);
    notifyListeners();
}

  update(Tosa old, Tosa novo, String idPet) async {
    try {
      remove(old, idPet);
      set(novo, idPet);
    } catch (e) {
      print("erro");
    }
  }
}
