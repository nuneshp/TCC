import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tcc_hugo/databases/db_firestore.dart';
import 'package:tcc_hugo/models/foto.dart';
import 'package:tcc_hugo/repositorys/pet_repository.dart';
import 'package:tcc_hugo/services/auth_service.dart';
import 'package:tcc_hugo/services/storage.dart';

class FotosRepository extends ChangeNotifier {
  bool isLoading = true;
  Map<String, List<Foto>> _map = {};
  late PetsRepository pets;
  late FirebaseFirestore db;
  late Storage storage;
  late AuthService auth;

  FotosRepository({required this.auth, required this.pets}) {
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

        List<Foto> lista = [];
        if (snapshot.exists) {
          if (snapshot.data()!.containsKey('fotos')) {
            List<dynamic> fotosData = snapshot.data()!['fotos'];
            lista =
                fotosData.map((fotoData) => Foto.fromJson(fotoData)).toList();
          }
        }

        _map[pet.id!] = lista;
      }
    }
    isLoading = false;
    notifyListeners();
  }

  UnmodifiableMapView<String, List<Foto>> get map => UnmodifiableMapView(_map);

  set(Foto foto, String idPet) async {
    foto.id = DateTime.now().toString();

    final collectionFoto =
        db.collection('usuarios/${auth.usuario!.email}/pets');

    // Criar o objeto Batch
    final batch = db.batch();
    final fotoRef = collectionFoto.doc(idPet);
    batch.set(
        fotoRef,
        {
          "fotos": FieldValue.arrayUnion([foto.toJson()])
        },
        SetOptions(merge: true));

    try {
      await batch.commit();

      if (_map[idPet] == null) {
        _map[idPet] = [];
      }

      _map[idPet]!.add(foto);
      notifyListeners();
    } catch (e) {
      print("erro ao adicionar foto");
    }
  }

  remove(Foto foto, String idPet) async {
    final collectionFoto =
        db.collection('usuarios/${auth.usuario!.email}/pets');

    // Criar o objeto Batch
    final batch = db.batch();
    final fotoRef = collectionFoto.doc(idPet);

    batch.update(
      fotoRef,
      {
        "fotos": FieldValue.arrayRemove([foto.toJson()])
      },
    );

    try {
      await batch.commit();

      _map[idPet]!.remove(foto);

      await storage.deleteImage(foto.foto.toString());
      notifyListeners();
    } catch (e) {
      print("Erro ao remover foto");
    }
  }

  // update(Foto foto, String idPet) async {
  //   _map[idPet]![_map[idPet]!.indexWhere((element) => element.id == foto.id)] =
  //       foto;

  //   await db
  //       .collection('usuarios/${auth.usuario!.email}/pets/${idPet}/fotos')
  //       .doc(foto.id)
  //       .update(foto.toJson());

  //   notifyListeners();
  // }
}
