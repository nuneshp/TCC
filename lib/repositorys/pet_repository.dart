import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tcc_hugo/databases/db_firestore.dart';
import 'package:tcc_hugo/models/foto.dart';
import 'package:tcc_hugo/models/pet.dart';
import 'package:tcc_hugo/services/auth_service.dart';
import 'package:tcc_hugo/services/storage.dart';

class PetsRepository extends ChangeNotifier {
  bool isLoading = true;
  List<Pet> _lista = [];
  late FirebaseFirestore db;
  late Storage storage;
  late AuthService auth;

  PetsRepository({required this.auth}) {
    _startRepository();
  }

  _startRepository() async {
    await _startFirestore();
    await _readPets();
  }

  _startFirestore() {
    db = DBFirestore.get();
    storage = Storage(auth: auth);
  }

  refresh() async {
    try {
      isLoading = true;
      _lista = [];
      await _readPets();
      isLoading = false;
      notifyListeners();
    } catch (e) {}
  }

  Future<void> _readPets() async {
    if (auth.usuario != null && lista.isEmpty) {
      final snapshot =
          await db.collection('usuarios/${auth.usuario!.email}/pets').get();

      if (snapshot.docs.isNotEmpty) {
        for (var doc in snapshot.docs) {
          Pet pet = Pet.fromJson(doc.data());

          _lista.add(pet);
        }
      }
      isLoading = false;
      notifyListeners();
    }
  }

  UnmodifiableListView<Pet> get lista => UnmodifiableListView(_lista);

  setPet(Pet pet) async {
    pet.id = "${pet.nome}_${DateTime.now().toString().hashCode}";
    await db
        .collection('usuarios/${auth.usuario!.email}/pets')
        .doc(pet.id)
        .set(pet.toJson());

    _lista.add(pet);
    notifyListeners();
  }

  remove(Pet pet, List<Foto>? listaFotos) async {
    // print(pet.id);
    try {
      final collectionPet =
          db.collection('usuarios/${auth.usuario!.email}/pets');
      final collectionNotifica = db.collection('notificacoes');

      final batch = db.batch();

      final petRef = collectionPet.doc(pet.id);
      batch.delete(petRef);

      final notificaRef = collectionNotifica.doc("lista");
      batch.update(
        notificaRef,
        {
          auth.usuario!.uid: {
            pet.id: {},
          },
        },
      );
      batch.update(
        notificaRef,
        {
          auth.usuario!.uid: FieldValue.arrayRemove([
            {pet.id: {}}
          ])
        },
      );

      await batch.commit();

      _lista.remove(pet);

      //deleta a foto do perfil
      if (pet.foto != null) {
        await storage.deleteImage(pet.foto.toString());
      }

      //deleta todas as fotos da galeria do pet
      if (listaFotos != null && listaFotos.isNotEmpty) {
        for (var foto in listaFotos) {
          if (foto.foto != null) await storage.deleteImage(foto.foto!);
        }
      }

      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  update({required Pet pet, String? oldURL}) async {
    late int index;
    _lista.forEach((element) {
      if (element.id == pet.id) {
        index = _lista.indexOf(element);
      }
    });

    await db
        .collection('usuarios/${auth.usuario!.email}/pets')
        .doc(pet.id)
        .update(pet.toJson());

    if (oldURL != null) {
      await storage.deleteImage(oldURL);
    }
    _lista[index] = pet;

    notifyListeners();
  }

  String? idPet(int indexPet) {
    if (_lista.isNotEmpty && indexPet >= 0 && indexPet < _lista.length) {
      return _lista[indexPet].id;
    }
    return null;
  }

  Pet? getPet(String idPet) {
    Pet? _pet;
    if (_lista.isNotEmpty && idPet != "" ) {
      for(Pet pet in _lista)
        if(pet.id == idPet)
          _pet=pet;
    }
    return _pet;
  }
}
