// import 'dart:collection';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:tcc_hugo/databases/db_firestore.dart';
// import 'package:tcc_hugo/models/vacina.dart';
// import 'package:tcc_hugo/repositorys/pet_repository.dart';
// import 'package:tcc_hugo/services/auth_service.dart';
// import 'package:tcc_hugo/services/storage.dart';

// class VacinasRepository extends ChangeNotifier {
//   bool isLoading = true;
//   Map<String, List<Vacina>> _map = {};
//   late PetsRepository pets;
//   late FirebaseFirestore db;
//   late Storage storage;
//   late AuthService auth;

//   VacinasRepository({required this.auth, required this.pets}) {
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

//   refresh()async{
//     _map = {};
//     _read();
//   }  

//    _read() async {
    
//     if (auth.usuario != null && _map.isEmpty && pets.lista.isNotEmpty) {
//       for(var pet in pets.lista) {
//         final snapshot = await db
//             .collection('usuarios/${auth.usuario!.email}/pets/${pet.id!}/vacinas')
//             .get();

//         List<Vacina> lista = [];
//         for(var doc in snapshot.docs) {
//           Vacina vacina = Vacina.fromJson(doc.data());
          

//           lista.add(vacina);
//         }

//         _map[pet.id!] = lista;
//       }

//       isLoading =false;
//       notifyListeners();
//        }
//   }

  
//   UnmodifiableMapView<String, List<Vacina>> get map => UnmodifiableMapView(_map);

//   set(Vacina vacina, String idPet) async {
//     vacina.id = DateTime.now().toString();
//     await db
//         .collection('usuarios/${auth.usuario!.email}/pets/$idPet/vacinas')
//         .doc(vacina.id)
//         .set(vacina.toJson());

//     _map[idPet]!.add(vacina);
//     notifyListeners();
//   }

//   remove(Vacina vacina, String idPet) async {
//     await db
//         .collection('usuarios/${auth.usuario!.email}/pets/$idPet/vacinas')
//         .doc(vacina.id)
//         .delete();
//     _map[idPet]!.remove(vacina);
//     notifyListeners();
//   }

//   update(Vacina vacina, String idPet) async {
//     _map[idPet]![_map[idPet]!.indexWhere((element) => element.id == vacina.id)] =
//         vacina;

//     await db
//         .collection('usuarios/${auth.usuario!.email}/pets/$idPet/vacinas')
//         .doc(vacina.id)
//         .update(vacina.toJson());

//     notifyListeners();
//   }

//   Map<String, List<Vacina>> getVacinasCat(String idPet){
//     Map<String, List<Vacina>> catVacinas = {};
//   List<Vacina> list=[];

//   if (_map.containsKey(idPet)) {
//     list = _map[idPet]!;

    
//     for(var element in list){
//       if(!catVacinas.containsKey(element.categoria)){
//         catVacinas[element.categoria!]=[];
//       }
//       catVacinas[element.categoria]!.add(element);
//     }
    
//   }

//   return catVacinas;
//   }
// }
