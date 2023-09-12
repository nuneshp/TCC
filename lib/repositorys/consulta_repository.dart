import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tcc_hugo/databases/db_firestore.dart';
import 'package:tcc_hugo/models/consulta.dart';
import 'package:tcc_hugo/models/pet.dart';
import 'package:tcc_hugo/repositorys/pet_repository.dart';
import 'package:tcc_hugo/services/auth_service.dart';
import 'package:tcc_hugo/services/storage.dart';

class ConsultasRepository extends ChangeNotifier {
  bool isLoading = true;
  Map<String, List<Consulta>> _map = {};
  late PetsRepository pets;
  late FirebaseFirestore db;
  late Storage storage;
  late AuthService auth;

  ConsultasRepository({required this.auth, required this.pets}) {
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

        List<Consulta> lista = [];
        if (snapshot.exists) {
          if (snapshot.data()!.containsKey('consultas')) {
            List<dynamic> consultasData = snapshot.data()!['consultas'];
            lista = consultasData
                .map((consultaData) => Consulta.fromJson(consultaData))
                .toList();
          }
        }

        _map[pet.id!] = lista;
      }
    }
    isLoading = false;
    notifyListeners();
  }

  UnmodifiableMapView<String, List<Consulta>> get map =>
      UnmodifiableMapView(_map);

  set(Consulta consulta, String idPet) async {
    Pet? pet = pets.getPet(idPet);
    consulta.id = DateTime.now().toString();

    final collectionConsulta =
        db.collection('usuarios/${auth.usuario!.email}/pets');
    final collectionNotifica = db.collection('notificacoes');

    // Criar o objeto Batch
    final batch = db.batch();
    final consultaRef = collectionConsulta.doc(idPet);
    batch.set(
        consultaRef,
        {
          "consultas": FieldValue.arrayUnion([consulta.toJson()])
        },
        SetOptions(merge: true));

    if (consulta.proximaData!.isAfter(DateTime.now())) {
      final notificaRef = collectionNotifica.doc("lista");

      batch.set(
          notificaRef,
          {
            auth.usuario!.uid: {
              idPet: FieldValue.arrayUnion([
                {
                  'titulo': pet!.nome!.toUpperCase(),
                  'descricao': 'Rotorno de Consulta agendado para hoje',
                  'idPet': idPet,
                  'payload': '',
                  'data': consulta.proximaData
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

    _map[idPet]!.add(consulta);
    notifyListeners();
  }

  remove(Consulta consulta, String idPet) async {
    Pet? pet = pets.getPet(idPet);
    final collectionConsulta =
        db.collection('usuarios/${auth.usuario!.email}/pets');
    final collectionNotifica = db.collection('notificacoes');

    // Criar o objeto Batch
    final batch = db.batch();
    final consultaRef = collectionConsulta.doc(idPet);

    batch.update(
      consultaRef,
      {
        "consultas": FieldValue.arrayRemove([consulta.toJson()])
      },
    );

    if (consulta.proximaData!.isAfter(DateTime.now())) {
      final notificaRef = collectionNotifica.doc("lista");

      batch.update(
        notificaRef,
        {
          "${auth.usuario!.uid}.$idPet": FieldValue.arrayRemove([
            {
                  'titulo': pet!.nome!.toUpperCase(),
                  'descricao': 'Rotorno de Consulta agendado para hoje',
                  'idPet': idPet,
                  'payload': '',
                  'data': consulta.proximaData
                },
          ])
        },
      );
    }

    await batch.commit();

    _map[idPet]!.remove(consulta);
    notifyListeners();
  }

  update(Consulta old, Consulta novo, String idPet) async {
    try {
      await remove(old, idPet);
      await set(novo, idPet);
    } catch (e) {
      print("erro");
    }
  }
}
