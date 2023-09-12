// import 'dart:collection';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:tcc_hugo/databases/db_firestore.dart';
// import 'package:tcc_hugo/models/banho.dart';
// import 'package:tcc_hugo/repositorys/pet_repository.dart';
// import 'package:tcc_hugo/services/auth_service.dart';
// import 'package:tcc_hugo/services/storage.dart';

// class BanhosRepository extends ChangeNotifier {
//   Map<String, List<Banho>> _map = {};
//   late PetsRepository pets;
//   late FirebaseFirestore db;
//   late Storage storage;
//   late AuthService auth;
//   bool isLoading = true;

//   BanhosRepository({required this.auth, required this.pets}) {
//     _startRepository();
//   }

//   _startRepository() async {
//     _startFirestore();
//     await _read();
//   }

//   _startFirestore() {
//     db = DBFirestore.get();
//     storage = Storage(auth: auth);
//   }

//   refresh() async {
//     _map = {};
//     _read();
//   }

//   _read() async {
//     if (auth.usuario != null && _map.isEmpty && pets.lista.isNotEmpty) {
//       for (var pet in pets.lista) {
//         final snapshot = await db
//             .collection(
//                 'usuarios/${auth.usuario!.email}/pets/${pet.id!}/banhos')
//             .get();

//         List<Banho> lista = [];
//         for (var doc in snapshot.docs) {
//           Banho banho = Banho.fromJson(doc.data());

//           lista.add(banho);
//         }

//         _map[pet.id!] = lista;
//       }
//     }
//     isLoading = false;
//     notifyListeners();
//   }

//   UnmodifiableMapView<String, List<Banho>> get map => UnmodifiableMapView(_map);

//   set(Banho banho, String idPet) async {
//     // banho.id=DateTime.now().toString();
//     final collectionBanho =
//         db.collection('usuarios/${auth.usuario!.email}/pets/$idPet/banhos');
//     final collectionNotifica = db.collection('notificoes');

//     // Criar o objeto Batch
//     final batch = db.batch();
//     final banhoRef = collectionBanho.doc(banho.id);
//     batch.set(banhoRef, banho.toJson());

//     if (banho.proximaData!.isAfter(DateTime.now())) {
//       final notificaRef = collectionNotifica.doc(banho.id);
      
//       batch.set(notificaRef, {
//         'email_user': auth.usuario!.email,
//         'titulo': 'Banho agendado',
//         'descricao': 'lembre de dar banho',
//         'idPet': idPet,
//         'payload': '',
//         'data': banho.proximaData
//       });
//     }

// // Executar o batch write
//     await batch.commit();

//     // await db
//     //     .collection('usuarios/${auth.usuario!.email}/pets/$idPet/banhos')
//     //     .doc(banho.id)
//     //     .set(banho.toJson());

//     _map[idPet]!.add(banho);

//     notifyListeners();
//   }

//   remove(Banho banho, String idPet) async {
//     await db
//         .collection('usuarios/${auth.usuario!.email}/pets/$idPet/banhos')
//         .doc(banho.id)
//         .delete();
//     _map[idPet]!.remove(banho);
//     notifyListeners();
//   }

//   update(Banho banho, String idPet) async {
//     _map[idPet]![_map[idPet]!.indexWhere((element) => element.id == banho.id)] =
//         banho;

//     await db
//         .collection('usuarios/${auth.usuario!.email}/pets/$idPet/banhos')
//         .doc(banho.id)
//         .update(banho.toJson());

//     notifyListeners();
//   }
// }
