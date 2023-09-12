import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tcc_hugo/databases/db_firestore.dart';
import 'package:tcc_hugo/models/peso.dart';
import 'package:tcc_hugo/repositorys/pet_repository.dart';
import 'package:tcc_hugo/services/auth_service.dart';
import 'package:tcc_hugo/services/storage.dart';

class PesosRepository extends ChangeNotifier {
  bool isLoading = true;
  Map<String, List<Peso>> _map = {};
  late PetsRepository pets;
  late FirebaseFirestore db;
  late Storage storage;
  late AuthService auth;

  PesosRepository({required this.auth, required this.pets}) {
    _startRepository();
  }

  _startRepository() async {
    await _startFirestore();
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

        List<Peso> lista = [];
        if (snapshot.exists) {
          if (snapshot.data()!.containsKey('pesos')) {
            List<dynamic> pesosData = snapshot.data()!['pesos'];
            lista = pesosData
                .map((pesoData) => Peso.fromJson(pesoData))
                .toList();
          }
        }

        _map[pet.id!] = lista;
      }
    }
    isLoading = false;
    notifyListeners();
  }

  
  UnmodifiableMapView<String, List<Peso>> get map => UnmodifiableMapView(_map);

  set(Peso peso, String idPet) async {
  peso.id=DateTime.now().toString();

    final collectionPeso =
        db.collection('usuarios/${auth.usuario!.email}/pets');
    
    // Criar o objeto Batch
    final batch = db.batch();
    final pesoRef = collectionPeso.doc(idPet);
    batch.set(
        pesoRef,
        {
          "pesos": FieldValue.arrayUnion([peso.toJson()])
        },
        SetOptions(merge: true));

    await batch.commit();

    if(_map[idPet]==null){
      _map[idPet]=[];
    }

    _map[idPet]!.add(peso);
    notifyListeners();
    }

  remove(Peso peso, String idPet) async {
    final collectionPeso =
        db.collection('usuarios/${auth.usuario!.email}/pets');
    
    // Criar o objeto Batch
    final batch = db.batch();
    final pesoRef = collectionPeso.doc(idPet);

    batch.update(
      pesoRef,
      {
        "pesos": FieldValue.arrayRemove([peso.toJson()])
      },
    );


    await batch.commit();

    _map[idPet]!.remove(peso);
    notifyListeners();
    }

  update(Peso old, Peso novo, String idPet) async {
    try {
      remove(old, idPet);
      set(novo, idPet);
    } catch (e) {
      print("erro");
    }
  }
}
