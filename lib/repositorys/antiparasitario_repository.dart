import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tcc_hugo/databases/db_firestore.dart';
import 'package:tcc_hugo/models/antiparasitario.dart';
import 'package:tcc_hugo/models/pet.dart';
import 'package:tcc_hugo/models/vermifugo.dart';
import 'package:tcc_hugo/repositorys/pet_repository.dart';
import 'package:tcc_hugo/services/auth_service.dart';
import 'package:tcc_hugo/services/storage.dart';

class AntiparasitariosRepository extends ChangeNotifier {
  bool isLoading = true;
  Map<String, List<Antiparasitario>> _map = {};
  late PetsRepository pets;
  late FirebaseFirestore db;
  late Storage storage;
  late AuthService auth;

  AntiparasitariosRepository({required this.auth, required this.pets}) {
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

        List<Antiparasitario> lista = [];
        if (snapshot.exists) {
          if (snapshot.data()!.containsKey('antiparasitarios')) {
            List<dynamic> antiparasitariosData =
                snapshot.data()!['antiparasitarios'];
            lista = antiparasitariosData
                .map((antiparasitarioData) =>
                    Antiparasitario.fromJson(antiparasitarioData))
                .toList();
          }
        }

        _map[pet.id!] = lista;
      }
    }
    isLoading = false;
    notifyListeners();
  }

  UnmodifiableMapView<String, List<Antiparasitario>> get map =>
      UnmodifiableMapView(_map);

  set(Antiparasitario antiparasitario, String idPet) async {
    Pet? pet = pets.getPet(idPet);

    antiparasitario.id = DateTime.now().toString();

    final collectionAntiparasitario =
        db.collection('usuarios/${auth.usuario!.email}/pets');
    final collectionNotifica = db.collection('notificacoes');

    // Criar o objeto Batch
    final batch = db.batch();
    final antiparasitarioRef = collectionAntiparasitario.doc(idPet);
    batch.set(
        antiparasitarioRef,
        {
          "antiparasitarios": FieldValue.arrayUnion([antiparasitario.toJson()])
        },
        SetOptions(merge: true));

    if (antiparasitario.proximaData!.isAfter(DateTime.now())) {
      final notificaRef = collectionNotifica.doc("lista");

      batch.set(
          notificaRef,
          {
            auth.usuario!.uid: {
              idPet: FieldValue.arrayUnion([
                {
                  'titulo': pet!.nome!.toUpperCase(),
                  'descricao': 'Antiparasitário agendado para hoje',
                  'idPet': idPet,
                  'payload': '',
                  'data': antiparasitario.proximaData
                },
              ])
            }
          },
          SetOptions(merge: true));
    }

    await batch.commit();

    if (_map[idPet] == null) {
      _map[idPet] = [];
    }
    _map[idPet]!.add(antiparasitario);
    notifyListeners();
  }

  remove(Antiparasitario antiparasitario, String idPet) async {
    Pet? pet = pets.getPet(idPet);
    final collectionAntiparasitario =
        db.collection('usuarios/${auth.usuario!.email}/pets');
    final collectionNotifica = db.collection('notificacoes');

    // Criar o objeto Batch
    final batch = db.batch();
    final antiparasitarioRef = collectionAntiparasitario.doc(idPet);

    batch.update(
      antiparasitarioRef,
      {
        "antiparasitarios": FieldValue.arrayRemove([antiparasitario.toJson()])
      },
    );

    if (antiparasitario.proximaData!.isAfter(DateTime.now())) {
      final notificaRef = collectionNotifica.doc("lista");

      batch.update(
        notificaRef,
        {
          "${auth.usuario!.uid}.$idPet": FieldValue.arrayRemove([
            {
                  'titulo': pet!.nome!.toUpperCase(),
                  'descricao': 'Antiparasitário agendado para hoje',
                  'idPet': idPet,
                  'payload': '',
                  'data': antiparasitario.proximaData
                },
          ])
        },
      );
    }

    await batch.commit();

    _map[idPet]!.remove(antiparasitario);
    notifyListeners();
  }

  update(Antiparasitario old, Antiparasitario novo, String idPet) async {
    try {
      remove(old, idPet);
      set(novo, idPet);
    } catch (e) {
      print("erro");
    }
  }
}
