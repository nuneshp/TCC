import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tcc_hugo/databases/db_firestore.dart';
import 'package:tcc_hugo/models/banho.dart';
import 'package:tcc_hugo/models/pet.dart';
import 'package:tcc_hugo/repositorys/pet_repository.dart';
import 'package:tcc_hugo/services/auth_service.dart';
import 'package:tcc_hugo/services/storage.dart';

class BanhosRepository extends ChangeNotifier {
  Map<String, List<Banho>> _map = {};
  late PetsRepository pets;
  late FirebaseFirestore db;
  late Storage storage;
  late AuthService auth;
  bool isLoading = true;

  BanhosRepository({required this.auth, required this.pets}) {
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

        List<Banho> lista = [];
        if (snapshot.exists) {
          if (snapshot.data()!.containsKey('banhos')) {
            List<dynamic> banhosData = snapshot.data()!['banhos'];
            lista = banhosData
                .map((banhoData) => Banho.fromJson(banhoData))
                .toList();
          }
        }

        _map[pet.id!] = lista;
      }
    }
    isLoading = false;
    notifyListeners();
  }

  UnmodifiableMapView<String, List<Banho>> get map => UnmodifiableMapView(_map);

  set(Banho banho, String idPet) async {
    Pet? pet = pets.getPet(idPet);
    banho.id = DateTime.now().toString();

    final collectionBanho =
        db.collection('usuarios/${auth.usuario!.email}/pets');
    final collectionNotifica = db.collection('notificacoes');

    // Criar o objeto Batch
    final batch = db.batch();
    final banhoRef = collectionBanho.doc(idPet);
    batch.set(
        banhoRef,
        {
          "banhos": FieldValue.arrayUnion([banho.toJson()])
        },
        SetOptions(merge: true));

    if (banho.proximaData!.isAfter(DateTime.now())) {
      final notificaRef = collectionNotifica.doc("lista");

      batch.set(
          notificaRef,
          {
            auth.usuario!.uid: {
              idPet: FieldValue.arrayUnion([
                {
                  'titulo': pet!.nome!.toUpperCase(),
                  'descricao': 'Banho agendado para hoje',
                  'idPet': idPet,
                  'payload': '',
                  'data': banho.proximaData
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

    _map[idPet]!.add(banho);
    notifyListeners();
  }

  remove(Banho banho, String idPet) async {
    Pet? pet = pets.getPet(idPet);
    final collectionBanho =
        db.collection('usuarios/${auth.usuario!.email}/pets');
    final collectionNotifica = db.collection('notificacoes');

    // Criar o objeto Batch
    final batch = db.batch();
    final banhoRef = collectionBanho.doc(idPet);

    batch.update(
      banhoRef,
      {
        "banhos": FieldValue.arrayRemove([banho.toJson()])
      },
    );

    if (banho.proximaData!.isAfter(DateTime.now())) {
      final notificaRef = collectionNotifica.doc("lista");

      batch.update(
        notificaRef,
        {
          "${auth.usuario!.uid}.$idPet": FieldValue.arrayRemove(
            [
              {
                'titulo': pet!.nome!.toUpperCase(),
                'descricao': 'Banho agendado para hoje',
                'idPet': idPet,
                'payload': '',
                'data': banho.proximaData
              },
            ],
          )
        },
      );
    }

    await batch.commit();

    _map[idPet]!.remove(banho);
    notifyListeners();
  }

  update(Banho old, Banho novo, String idPet) async {
    try {
      await remove(old, idPet);
      await set(novo, idPet);
    } catch (e) {
      print("erro");
    }
  }
}
